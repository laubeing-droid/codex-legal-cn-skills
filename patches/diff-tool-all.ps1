# diff-tool-all.ps1 — 统一上游检查入口
# 依次运行四个 diff-tool，汇总结果

param([switch]$Update, [switch]$Diff)

$ErrorActionPreference = 'Continue'
$RepoRoot = Split-Path -Parent $PSScriptRoot

$tools = @(
    @{Name="zhou210712"; Script="diff-tool-zhou.ps1"; Upstream="claude-for-legal-ZH"; Desc="中文汉化版"},
    @{Name="MAXXXXXLI";  Script="diff-tool-max.ps1";  Upstream="workbuddy-cn-legal-skills"; Desc="中国法语境覆盖"},
    @{Name="自研框架";   Script="diff-tool-align.ps1"; Upstream="PRC-US-Legal-Semantic-Alignment-Framework"; Desc="中美概念映射"},
    @{Name="solo-law-firm"; Script="diff-tool-solo.ps1"; Upstream="solo-law-firm-agents"; Desc="独立执业技能（已断开）"}
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  上游统一检查 — diff-tool-all" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$results = @()

foreach ($tool in $tools) {
    $scriptPath = Join-Path $PSScriptRoot $tool.Script
    if (-not (Test-Path $scriptPath)) {
        Write-Host "[跳过] $($tool.Name) — 脚本不存在: $($tool.Script)" -ForegroundColor Red
        $results += @{Name=$tool.Name; Status="脚本缺失"; Changes=0}
        continue
    }

    Write-Host "--- $($tool.Name) ($($tool.Desc)) ---" -ForegroundColor Yellow

    $args = @()
    if ($Update) { $args += "-Update" }
    if ($Diff)   { $args += "-Diff" }

    $output = & powershell -NoProfile -ExecutionPolicy Bypass -File $scriptPath @args 2>&1

    $totalLine = $output | Select-String -Pattern "已变更|新增|有变化" | Select-Object -Last 1
    $changes = 0
    if ($totalLine) {
        Write-Host "  $totalLine" -ForegroundColor White
        if ($totalLine -match "(\d+)\s*个文件有变化") { $changes = [int]$Matches[1] }
        elseif ($totalLine -match "(\d+)\s*已变更") { $changes = [int]$Matches[1] }
    }

    $updatesLine = $output | Select-String -Pattern "上游无更新" -SimpleMatch
    if ($updatesLine) { Write-Host "  上游无更新" -ForegroundColor Green }

    # Check for errors
    $errors = $output | Select-String -Pattern "错误|失败|fatal|error" -SimpleMatch
    if ($errors) { Write-Host "  ⚠️ 检测到错误" -ForegroundColor Red }

    $results += @{Name=$tool.Name; Status=($changes -gt 0 ? "有变更" : "无变更"); Changes=$changes}
    Write-Host ""
}

# 汇总
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  汇总" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
$totalChanges = 0
foreach ($r in $results) {
    $icon = if ($r.Changes -gt 0) { "🟡" } elseif ($r.Status -eq "脚本缺失") { "🔴" } else { "🟢" }
    Write-Host "  $icon $($r.Name): $($r.Status)"
    $totalChanges += $r.Changes
}

if ($totalChanges -eq 0) {
    Write-Host "`n所有上游无更新。" -ForegroundColor Green
} else {
    Write-Host "`n共 $totalChanges 个文件有变化。加 -Diff 查看详情，加 -Update 更新快照。" -ForegroundColor Yellow
}
Write-Host ""