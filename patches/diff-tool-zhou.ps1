param([switch]$Update, [switch]$Diff)

$ErrorActionPreference='Stop'
$RepoRoot=Split-Path -Parent $PSScriptRoot
$UpstreamUrl='https://github.com/zhou210712/claude-for-legal-ZH.git'
$UpstreamDir="$env:TEMP\zhou-check"
$SnapshotDir="$RepoRoot\patches\sub-skills"

Write-Host "=== zhou210712 上游检查 ===" -ForegroundColor Cyan

# 拉取上游
if (Test-Path "$UpstreamDir\.git") { Push-Location $UpstreamDir; git pull --ff-only 2>$null; Pop-Location }
else { if (Test-Path $UpstreamDir) { Remove-Item -Recurse -Force $UpstreamDir }; Push-Location $env:TEMP; git clone --depth 1 $UpstreamUrl zhou-check 2>&1 | Out-Null; Pop-Location }
Push-Location $UpstreamDir; $commit=git log -1 --format='%h'; $date=git log -1 --format='%ci'; Pop-Location
Write-Host "  $commit $date"

# ===== 跟踪文件清单 =====
$files=@()
$domains=@('commercial-legal','litigation-legal','employment-legal','privacy-legal','corporate-legal','ip-legal','product-legal','regulatory-legal','ai-governance-legal','law-student','legal-clinic','legal-builder-hub')
foreach ($d in $domains) { $files+=@{N="workflows/$d.CLAUDE.md";U="$d/CLAUDE.md"} }
foreach ($d in $domains) { $files+=@{N="connectors/$d.mcp.json";U="$d/.mcp.json"} }

# ===== 检查主文件 =====
Write-Host "`n--- 主文件 ---" -ForegroundColor Cyan
$changed=0; $ok=0
foreach ($f in $files) {
  $up="$UpstreamDir/$($f.U)"; $pa="$RepoRoot/patches/$($f.N)"
  if ((Test-Path $up) -and (Test-Path $pa)) {
    $uh=(Get-FileHash $up -Algorithm SHA256).Hash; $ph=(Get-FileHash $pa -Algorithm SHA256).Hash
    if ($uh -ne $ph) { Write-Host "  [Δ] $($f.N)" -ForegroundColor Yellow; $changed++ }
    else { Write-Host "  [✓] $($f.N)" -ForegroundColor Green; $ok++ }
  } elseif ((Test-Path $up) -and -not (Test-Path $pa)) { Write-Host "  [+] $($f.N) — 新文件" -ForegroundColor Magenta; $changed++ }
  else { Write-Host "  [?] $($f.N) — 缺失" -ForegroundColor Red }
}
Write-Host "  主文件: $ok 未变, $changed 已变更"

# ===== 检查子技能 =====
Write-Host "`n--- 子技能 ---" -ForegroundColor Cyan
$skChanged=0; $skOk=0; $skNew=0; $skMissing=0
foreach ($d in $domains) {
    $upSubDir="$UpstreamDir\$d\skills"
    if (-not (Test-Path $upSubDir)) { continue }
    $upSkills=Get-ChildItem $upSubDir -Directory -ErrorAction SilentlyContinue
    foreach ($s in $upSkills) {
        $skillName=$s.Name
        $upSkill="$UpstreamDir\$d\skills\$skillName\SKILL.md"
        $snapSkill="$SnapshotDir\$d\$skillName\SKILL.md"
        if (Test-Path $upSkill) {
            $uh=(Get-FileHash $upSkill -Algorithm SHA256).Hash
            if (Test-Path $snapSkill) {
                $sh=(Get-FileHash $snapSkill -Algorithm SHA256).Hash
                if ($uh -ne $sh) {
                    Write-Host "  [Δ] $d/$skillName" -ForegroundColor Yellow
                    $skChanged++
                    if ($Diff) {
                        $diffLines = & git diff --no-index "$snapSkill" "$upSkill" 2>&1
                        $diffLines | ForEach-Object { Write-Host "    $_" -ForegroundColor DarkGray }
                    }
                } else { $skOk++ }
            } else {
                Write-Host "  [+] $d/$skillName — 新技能" -ForegroundColor Magenta
                $skNew++
            }
        }
    }
    # 检查上游已删除的快照
    $snapSubDir="$SnapshotDir\$d"
    if (Test-Path $snapSubDir) {
        Get-ChildItem $snapSubDir -Directory -ErrorAction SilentlyContinue | ForEach-Object {
            $skillName=$_.Name
            $upExists=Test-Path "$UpstreamDir\$d\skills\$skillName"
            if (-not $upExists) {
                Write-Host "  [-] $d/$skillName — 上游已删除" -ForegroundColor Red
                $skMissing++
            }
        }
    }
}
Write-Host "  子技能: $skOk 未变, $skChanged 已变更, $skNew 新增, $skMissing 上游已删"

# ===== 汇总 =====
$totalChanged=$changed+$skChanged+$skNew
if ($totalChanged -eq 0) {
    Write-Host "`n上游无更新。" -ForegroundColor Green
} else {
    Write-Host "`n$totalChanged 个文件有变化（+Diff 查看详情）" -ForegroundColor Yellow
}

# ===== 更新快照 =====
if ($Update) {
    Write-Host "`n--- 更新快照 ---" -ForegroundColor Cyan
    # 主文件
    foreach ($f in $files) { $up="$UpstreamDir/$($f.U)"; $pa="$RepoRoot/patches/$($f.N)"; if (Test-Path $up) { $null=New-Item -ItemType Directory -Force (Split-Path $pa -Parent); Copy-Item $up $pa -Force } }
    # 子技能
    foreach ($d in $domains) {
        $upSubDir="$UpstreamDir\$d\skills"
        if (-not (Test-Path $upSubDir)) { continue }
        Get-ChildItem $upSubDir -Directory -ErrorAction SilentlyContinue | ForEach-Object {
            $skillName=$_.Name
            $upSkill="$UpstreamDir\$d\skills\$skillName\SKILL.md"
            $snapSkill="$SnapshotDir\$d\$skillName\SKILL.md"
            if (Test-Path $upSkill) { $null=New-Item -ItemType Directory -Force (Split-Path $snapSkill -Parent); Copy-Item $upSkill $snapSkill -Force }
        }
    }
    Write-Host "快照已更新。" -ForegroundColor Green
}

# ===== 首次运行提醒 =====
if (-not (Test-Path $SnapshotDir)) {
    Write-Host "`n[提示] 首次运行，子技能快照不存在。运行 -Update 创建快照。" -ForegroundColor Yellow
}

# 保留 TEMP 加速下次检测



