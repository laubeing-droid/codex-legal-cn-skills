param([switch]$Update, [switch]$Diff)

$ErrorActionPreference='Stop'
$RepoRoot=Split-Path -Parent $PSScriptRoot
$UpstreamUrl='https://github.com/MAXXXXXLI/workbuddy-cn-legal-skills.git'
$UpstreamDir="$env:TEMP\max-check"
$SnapshotDir="$RepoRoot\patches\sub-skills-max"

Write-Host "=== MAXXXXXLI 上游检查 ===" -ForegroundColor Cyan

# 拉取上游
if (Test-Path "$UpstreamDir\.git") { Push-Location $UpstreamDir; git pull --ff-only 2>&1 | Out-Null; Pop-Location }
else { if (Test-Path $UpstreamDir) { Remove-Item -Recurse -Force $UpstreamDir }; Push-Location $env:TEMP; git clone --depth 1 $UpstreamUrl max-check 2>&1 | Out-Null; Pop-Location }
Push-Location $UpstreamDir; $c=git log -1 --format='%h'; $d=git log -1 --format='%ci'; Pop-Location
Write-Host "  $c $d"

# 提取 ZIP 中的技能
$extractDir="$env:TEMP\max-ctx"
if (Test-Path $extractDir) { Remove-Item -Recurse -Force $extractDir }; $null=New-Item -ItemType Directory -Force $extractDir
$zips=Get-ChildItem "$UpstreamDir\可导入技能包" -Filter *.zip -ErrorAction SilentlyContinue

# 提取全局语境文件
$td1="$extractDir\_g"; 
if ($zips.Count -gt 0) {
    Expand-Archive $zips[0].FullName -DestinationPath $td1 -Force
    if (Test-Path "$td1\references\china-legal-context.md") { Copy-Item "$td1\references\china-legal-context.md" "$extractDir\" }
    Remove-Item -Recurse -Force $td1 -ErrorAction SilentlyContinue
}

# 提取所有模块的 SKILL.md + 语境文件
$modules=@{}; $allSkills=@()
foreach ($zip in $zips) { 
    $m=($zip.BaseName -split '-')[0]
    if ($modules.ContainsKey($m)) { continue }; $modules[$m]=$true
    $td="$extractDir\_m"
    Expand-Archive $zip.FullName -DestinationPath $td -Force
    # 语境文件
    if (Test-Path "$td\references\china-context.md") { 
        $sn=$m -replace '[\\/:*?"<>|]','_'
        Copy-Item "$td\references\china-context.md" "$extractDir\china-context-$sn.md" 
    }
    # 收集子技能
    if (Test-Path "$td\skills") {
        Get-ChildItem "$td\skills" -Directory -ErrorAction SilentlyContinue | ForEach-Object { $allSkills+=@{M=$m;N=$_.Name;P=$_.FullName} }
    }
    if (Test-Path "$td\SKILL.md") { $allSkills+=@{M=$m;N="$m-root";P=$td} }
    Remove-Item -Recurse -Force $td -ErrorAction SilentlyContinue 
}

Write-Host "  提取 $($allSkills.Count) 子技能, $(@(Get-ChildItem "$extractDir\*.md").Count) 语境文件"

# ===== 检查语境文件 =====
Write-Host "`n--- 语境文件 ---" -ForegroundColor Cyan
$ctxChanged=0; $ctxOk=0
$refs=@('china-legal-context.md'); Get-ChildItem "$RepoRoot/patches/references/context/china-context-*.md" -ErrorAction SilentlyContinue | ForEach-Object { $refs+=$_.Name }
foreach ($f in $refs) {
    $up="$extractDir\$f"; $pa="$RepoRoot/patches/references/context\$f"
    if ((Test-Path $up) -and (Test-Path $pa)) {
        $uh=(Get-FileHash $up -Algorithm SHA256).Hash; $ph=(Get-FileHash $pa -Algorithm SHA256).Hash
        if ($uh -ne $ph) { Write-Host "  [Δ] context/$f" -ForegroundColor Yellow; $ctxChanged++ }
        else { Write-Host "  [✓] context/$f" -ForegroundColor Green; $ctxOk++ }
    } elseif (Test-Path $up) { Write-Host "  [+] context/$f — 新文件" -ForegroundColor Magenta; $ctxChanged++ }
    else { Write-Host "  [?] context/$f — 缺失" -ForegroundColor Red }
}

# ===== 检查 NOTICE =====
$upN="$UpstreamDir/NOTICE"; $paN="$RepoRoot/patches/metadata/NOTICE.maxxxxxli"
if ((Test-Path $upN) -and (Test-Path $paN)) {
    $uh=(Get-FileHash $upN -Algorithm SHA256).Hash; $ph=(Get-FileHash $paN -Algorithm SHA256).Hash
    if ($uh -ne $ph) { Write-Host "  [Δ] NOTICE" -ForegroundColor Yellow; $ctxChanged++ } else { Write-Host "  [✓] NOTICE" -ForegroundColor Green; $ctxOk++ }
}

# ===== 检查子技能 =====
Write-Host "`n--- 子技能 ---" -ForegroundColor Cyan
$skChanged=0; $skOk=0; $skNew=0
foreach ($s in $allSkills) {
    $mod=$s.M; $name=$s.N; $srcPath=$s.P
    $upSkill="$srcPath\SKILL.md"
    $snapSkill="$SnapshotDir\$mod\$name\SKILL.md"
    if (Test-Path $upSkill) {
        $uh=(Get-FileHash $upSkill -Algorithm SHA256).Hash
        if (Test-Path $snapSkill) {
            $sh=(Get-FileHash $snapSkill -Algorithm SHA256).Hash
            if ($uh -ne $sh) {
                Write-Host "  [Δ] $mod/$name" -ForegroundColor Yellow
                $skChanged++
                if ($Diff) { 
                    $diffLines = & git diff --no-index "$snapSkill" "$upSkill" 2>&1
                    $diffLines | ForEach-Object { Write-Host "    $_" -ForegroundColor DarkGray }
                }
            } else { $skOk++ }
        } else { Write-Host "  [+] $mod/$name — 新技能" -ForegroundColor Magenta; $skNew++ }
    }
}

# ===== 汇总 =====
$totalChanged=$ctxChanged+$skChanged+$skNew
$totalOk=$ctxOk+$skOk
Write-Host "`n$totalOk 未变, $totalChanged 已变更"
if ($totalChanged -eq 0) { Write-Host "上游无更新。" -ForegroundColor Green }

# ===== 更新快照 =====
if ($Update) {
    Write-Host "`n--- 更新快照 ---" -ForegroundColor Cyan
    # 语境文件
    if (Test-Path "$extractDir\china-legal-context.md") { Copy-Item "$extractDir\china-legal-context.md" "$RepoRoot/patches/references\context\" -Force }
    Get-ChildItem "$extractDir\china-context-*.md" -ErrorAction SilentlyContinue | ForEach-Object { Copy-Item $_.FullName "$RepoRoot/patches/references\context\" -Force }
    if (Test-Path $upN) { Copy-Item $upN $paN -Force }
    # 子技能
    foreach ($s in $allSkills) {
        $mod=$s.M; $name=$s.N; $srcPath=$s.P
        $upSkill="$srcPath\SKILL.md"
        $snapSkill="$SnapshotDir\$mod\$name\SKILL.md"
        if (Test-Path $upSkill) { $null=New-Item -ItemType Directory -Force (Split-Path $snapSkill -Parent); Copy-Item $upSkill $snapSkill -Force }
    }
    Write-Host "快照已更新。" -ForegroundColor Green
}

# 首次运行提醒
if (-not (Test-Path $SnapshotDir)) {
    Write-Host "`n[提示] 首次运行，子技能快照不存在。运行 -Update 创建快照。" -ForegroundColor Yellow
}

# 清理 TEMP（保留缓存加速下次）
Remove-Item -Recurse -Force $extractDir -ErrorAction SilentlyContinue
