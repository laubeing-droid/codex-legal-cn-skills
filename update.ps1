<#
.SYNOPSIS
  手动更新 Claude for Legal CN to Codex
.DESCRIPTION
  1. 从上游拉取最新内容
  2. 同步技能包装层到 ~/.codex/skills/
  3. MCP 连接器检查（委托给 Codex-Claude-legal-CN-mcp-connectors 仓库）
  4. 运行 MCP 更新脚本（如可用）
  5. 验证安装完整性
#>

#Requires -Version 5.1

$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$SkillsDir = "$env:USERPROFILE\.codex\skills"
$UpstreamDir = "$env:USERPROFILE\.codex\vendor\claude-for-legal-CN"
$McpDir = "$RepoRoot\mcp-connectors"
$McpRepoUrl = 'https://github.com/laubeing-droid/Codex-Claude-legal-CN-mcp-connectors.git'

$domains = @(
    'commercial-legal','privacy-legal','product-legal','corporate-legal',
    'employment-legal','regulatory-legal','ai-governance-legal','litigation-legal',
    'law-student','legal-clinic','legal-builder-hub','ip-legal','solo-law-firm'
)

Write-Host '=== 更新 Codex 中国法律技能 ===' -ForegroundColor Green

# ---- [1/5] 更新上游内容 ----
Write-Host '[1/5] 更新上游内容...' -ForegroundColor Yellow
if (-not (Test-Path "$UpstreamDir\.git")) {
    Write-Host '[错误] 上游内容不存在。请先运行 install.ps1。' -ForegroundColor Red
    exit 1
}
Push-Location $UpstreamDir
$result = git pull 2>&1
Pop-Location
Write-Host "  [上游] $($result -join '')"

# ---- [2/5] 同步技能包装层 ----
Write-Host '[2/5] 同步技能包装层...' -ForegroundColor Yellow
$count = 0
foreach ($name in $domains) {
    $src = "$UpstreamDir\$name"
    $tgt = "$SkillsDir\$name"
    if (-not (Test-Path $src)) { continue }
    if (-not (Test-Path $tgt)) { $null = New-Item -ItemType Directory -Force $tgt }

    # 技能定义（本仓库覆盖）
    $localSkill = "$RepoRoot\skills\$name\SKILL.md"
    if (Test-Path $localSkill) { Copy-Item $localSkill "$tgt\SKILL.md" -Force }

    # 上游内容
    if (Test-Path "$src\CLAUDE.md") { Copy-Item "$src\CLAUDE.md" "$tgt\CLAUDE.md" -Force }
    if (Test-Path "$src\README.md") { Copy-Item "$src\README.md" "$tgt\README.md" -Force }
    if (Test-Path "$src\references") {
        $null = New-Item -ItemType Directory -Force "$tgt\references"
        Get-ChildItem "$src\references\*" -File -ErrorAction SilentlyContinue | ForEach-Object {
            Copy-Item $_.FullName "$tgt\references\" -Force
        }
    }
    if (Test-Path "$src\skills") {
        Get-ChildItem "$src\skills" -Directory -ErrorAction SilentlyContinue | ForEach-Object {
            $subTgt = "$tgt\skills\$($_.Name)"
            $null = New-Item -ItemType Directory -Force $subTgt
            if (Test-Path "$($_.FullName)\SKILL.md") { Copy-Item "$($_.FullName)\SKILL.md" "$subTgt\SKILL.md" -Force }
        }
    }
    if (Test-Path "$src\agents") {
        $null = New-Item -ItemType Directory -Force "$tgt\agents"
        Get-ChildItem "$src\agents\*" -File -ErrorAction SilentlyContinue | ForEach-Object {
            Copy-Item $_.FullName "$tgt\agents\" -Force
        }
    }
    $count++
}
# 根技能
$rootTgt = "$SkillsDir\claude-legal-cn"
$null = New-Item -ItemType Directory -Force $rootTgt
Copy-Item "$RepoRoot\skills\claude-legal-cn\SKILL.md" "$rootTgt\SKILL.md" -Force
Write-Host "  已同步 $count 个技能领域 + 根技能"

# ---- [3/5] MCP 连接器检查（委托给独立仓库） ----
Write-Host '[3/5] MCP 连接器检查...' -ForegroundColor Yellow
if (-not (Test-Path "$McpDir\verify.ps1")) {
    Write-Host '  正在克隆 MCP 连接器仓库...' -ForegroundColor Yellow
    Push-Location $RepoRoot
    git clone --depth 1 $McpRepoUrl mcp-connectors 2>&1 | Out-Null
    Pop-Location
}
if (Test-Path "$McpDir\verify.ps1") {
    Write-Host '  运行 MCP 连接器验证...' -ForegroundColor Yellow
    & "$McpDir\verify.ps1"
} else {
    Write-Host '  [警告] 无法获取 MCP 连接器验证脚本，跳过 MCP 检查' -ForegroundColor Yellow
    Write-Host '  如需手动检查，请运行: git clone https://github.com/laubeing-droid/Codex-Claude-legal-CN-mcp-connectors.git' -ForegroundColor DarkGray
}

# ---- [4/5] MCP 更新（如可用） ----
Write-Host '[4/5] MCP 连接器更新...' -ForegroundColor Yellow
if (Test-Path "$McpDir\update.ps1") {
    Write-Host '  运行 MCP 连接器更新...' -ForegroundColor Yellow
    & "$McpDir\update.ps1"
} else {
    Write-Host '  MCP 连接器更新脚本不可用，跳过' -ForegroundColor DarkGray
}

# ---- [5/5] 验证安装完整性 ----
Write-Host '[5/5] 验证安装完整性...' -ForegroundColor Yellow
$missing = @()
$all = $domains + @('claude-legal-cn'); $soloCount = 0; if (Test-Path "$SkillsDir\solo-law-firm") { Get-ChildItem -Recurse "$SkillsDir\solo-law-firm" -Filter 'SKILL.md' | ForEach-Object { $soloCount++ } }
foreach ($name in $all) {
    if (-not (Test-Path "$SkillsDir\$name\SKILL.md")) { $missing += $name }
}
if ($missing.Count -eq 0) {
    Write-Host "  [OK] $($all.Count) 个技能全部存在" -ForegroundColor Green
} else {
    Write-Host "  [!!] 缺失 $($missing.Count) 个技能: $($missing -join ', ')" -ForegroundColor Yellow
    Write-Host '  建议重新运行 install.ps1' -ForegroundColor DarkGray
}

Write-Host ''
Write-Host '更新完成。重启 Codex Desktop 使新内容生效。' -ForegroundColor Green
Write-Host 'MCP 连接器由 Codex-Claude-legal-CN-mcp-connectors 独立管理。' -ForegroundColor Cyan
Write-Host '  详情: https://github.com/laubeing-droid/Codex-Claude-legal-CN-mcp-connectors' -ForegroundColor Cyan
