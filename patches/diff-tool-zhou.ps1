param([switch]$Update)
$ErrorActionPreference='Stop'
$RepoRoot=Split-Path -Parent $PSScriptRoot
$UpstreamUrl='https://github.com/zhou210712/claude-for-legal-ZH.git'
$UpstreamDir="$env:TEMP\zhou-check"
Write-Host "=== zhou210712 上游检查 ===" -ForegroundColor Cyan
if (Test-Path "$UpstreamDir\.git") { Push-Location $UpstreamDir; git pull --ff-only 2>$null; Pop-Location }
else { if (Test-Path $UpstreamDir) { Remove-Item -Recurse -Force $UpstreamDir }; Push-Location $env:TEMP; git clone --depth 1 $UpstreamUrl zhou-check 2>$null; Pop-Location }
Push-Location $UpstreamDir; $c=git log -1 --format='%h'; $d=git log -1 --format='%ci'; Pop-Location
Write-Host "  $c $d"
$files=@(
  @{N='references/laws/contract-law-core.md';U='commercial-legal/references/contract-law-core.md'}
  @{N='references/laws/civil-procedure-core.md';U='litigation-legal/references/civil-procedure-core.md'}
  @{N='references/laws/evidence-rules-core.md';U='litigation-legal/references/evidence-rules-core.md'}
  @{N='references/laws/enforcement-core.md';U='litigation-legal/references/enforcement-core.md'}
  @{N='references/laws/labor-core-rules.md';U='employment-legal/references/labor-core-rules.md'}
  @{N='references/laws/company-law-2024-core.md';U='corporate-legal/references/company-law-2024-core.md'}
  @{N='references/laws/ip-core-rules.md';U='ip-legal/references/ip-core-rules.md'}
  @{N='references/laws/admin-law-core.md';U='regulatory-legal/references/admin-law-core.md'}
  @{N='references/laws/pipil-core-provisions.md';U='privacy-legal/references/pipil-core-provisions.md'}
  @{N='references/laws/ai-governance-core.md';U='ai-governance-legal/references/ai-governance-core.md'}
  @{N='references/laws/currency-watch.md';U='ai-governance-legal/references/currency-watch.md'}
)
$domains=@('commercial-legal','litigation-legal','employment-legal','privacy-legal','corporate-legal','ip-legal','product-legal','regulatory-legal','ai-governance-legal','law-student','legal-clinic','legal-builder-hub')
foreach ($d in $domains) { $files+=@{N="workflows/$d.CLAUDE.md";U="$d/CLAUDE.md"} }
foreach ($d in $domains) { $files+=@{N="connectors/$d.mcp.json";U="$d/.mcp.json"} }
$changed=0; $ok=0
foreach ($f in $files) {
  $up="$UpstreamDir/$($f.U)"; $pa="$RepoRoot/patches/$($f.N)"
  if ((Test-Path $up) -and (Test-Path $pa)) {
    $uh=(Get-FileHash $up -Algorithm SHA256).Hash; $ph=(Get-FileHash $pa -Algorithm SHA256).Hash
    if ($uh -ne $ph) { Write-Host "  [Δ] $($f.N)" -ForegroundColor Yellow; $changed++ }
    else { Write-Host "  [✓] $($f.N)" -ForegroundColor Green; $ok++ }
  } else { Write-Host "  [?] $($f.N) — 缺失" -ForegroundColor Red }
}
Write-Host "$ok 未变, $changed 已变更"
if ($changed -eq 0) { Write-Host "上游无更新。" -ForegroundColor Green; exit }
if ($Update) {
  foreach ($f in $files) { $up="$UpstreamDir/$($f.U)"; $pa="$RepoRoot/patches/$($f.N)"; if (Test-Path $up) { $null=New-Item -ItemType Directory -Force (Split-Path $pa -Parent); Copy-Item $up $pa -Force } }
  Write-Host "快照已更新。" -ForegroundColor Green
}
Remove-Item -Recurse -Force $UpstreamDir -ErrorAction SilentlyContinue
