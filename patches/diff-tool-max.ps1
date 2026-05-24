param([switch]$Update)
$ErrorActionPreference='Stop'
$RepoRoot=Split-Path -Parent $PSScriptRoot
$UpstreamUrl='https://github.com/MAXXXXXLI/workbuddy-cn-legal-skills.git'
$UpstreamDir="$env:TEMP\max-check"
Write-Host "=== MAXXXXXLI 上游检查 ===" -ForegroundColor Cyan
if (Test-Path "$UpstreamDir\.git") { Push-Location $UpstreamDir; git pull --ff-only 2>$null; Pop-Location }
else { if (Test-Path $UpstreamDir) { Remove-Item -Recurse -Force $UpstreamDir }; Push-Location $env:TEMP; git clone --depth 1 $UpstreamUrl max-check 2>$null; Pop-Location }
Push-Location $UpstreamDir; $c=git log -1 --format='%h'; $d=git log -1 --format='%ci'; Pop-Location
Write-Host "  $c $d"
# Extract upstream context files
$extractDir="$env:TEMP\max-ctx"; if (Test-Path $extractDir) { Remove-Item -Recurse -Force $extractDir }; $null=New-Item -ItemType Directory -Force $extractDir
$zips=Get-ChildItem "$UpstreamDir\可导入技能包" -Filter *.zip
$td1="$extractDir\_g"; Expand-Archive $zips[0].FullName -DestinationPath $td1 -Force
if (Test-Path "$td1\references\china-legal-context.md") { Copy-Item "$td1\references\china-legal-context.md" "$extractDir\" }
Remove-Item -Recurse -Force $td1 -ErrorAction SilentlyContinue
$modules=@{}; foreach ($zip in $zips) { $m=($zip.BaseName -split '-')[0]; if ($modules.ContainsKey($m)) { continue }; $modules[$m]=$true
  $td="$extractDir\_m"; Expand-Archive $zip.FullName -DestinationPath $td -Force
  if (Test-Path "$td\references\china-context.md") { $sn=$m -replace '[\\/:*?"<>|]','_'; Copy-Item "$td\references\china-context.md" "$extractDir\china-context-$sn.md" }
  Remove-Item -Recurse -Force $td -ErrorAction SilentlyContinue }
Write-Host "  提取 $(@(Get-ChildItem "$extractDir\*.md").Count) 个语境文件"
# Compare
$changed=0; $ok=0
$refs=@('china-legal-context.md'); Get-ChildItem "$RepoRoot/patches/references/context/china-context-*.md" | ForEach-Object { $refs+=$_.Name }
foreach ($f in $refs) {
  $up="$extractDir\$f"; $pa="$RepoRoot/patches/references/context\$f"
  if ((Test-Path $up) -and (Test-Path $pa)) {
    $uh=(Get-FileHash $up -Algorithm SHA256).Hash; $ph=(Get-FileHash $pa -Algorithm SHA256).Hash
    if ($uh -ne $ph) { Write-Host "  [Δ] context/$f" -ForegroundColor Yellow; $changed++ }
    else { Write-Host "  [✓] context/$f" -ForegroundColor Green; $ok++ }
  }
}
$upN="$UpstreamDir/NOTICE"; $paN="$RepoRoot/patches/metadata/NOTICE.maxxxxxli"
if ((Test-Path $upN) -and (Test-Path $paN)) {
  $uh=(Get-FileHash $upN -Algorithm SHA256).Hash; $ph=(Get-FileHash $paN -Algorithm SHA256).Hash
  if ($uh -ne $ph) { Write-Host "  [Δ] NOTICE" -ForegroundColor Yellow; $changed++ } else { Write-Host "  [✓] NOTICE" -ForegroundColor Green; $ok++ }
}
$upCount=$zips.Count; $patchCount=(Get-ChildItem "$RepoRoot/patches/references/context" -File).Count
if ($upCount -ne 151) { Write-Host "  [Δ] 上游技能数: $upCount" -ForegroundColor Yellow; $changed++ }
else { Write-Host "  [✓] 技能数: 151" -ForegroundColor Green }
Write-Host "$ok 未变, $changed 已变更"
if ($changed -eq 0) { Write-Host "上游无更新。" -ForegroundColor Green; exit }
if ($Update) {
  if (Test-Path "$extractDir\china-legal-context.md") { Copy-Item "$extractDir\china-legal-context.md" "$RepoRoot/patches/references/context\" -Force }
  Get-ChildItem "$extractDir\china-context-*.md" | ForEach-Object { Copy-Item $_.FullName "$RepoRoot/patches/references/context\" -Force }
  if (Test-Path $upN) { Copy-Item $upN $paN -Force }
  Write-Host "快照已更新。" -ForegroundColor Green
}
Remove-Item -Recurse -Force $UpstreamDir -ErrorAction SilentlyContinue; Remove-Item -Recurse -Force $extractDir -ErrorAction SilentlyContinue
