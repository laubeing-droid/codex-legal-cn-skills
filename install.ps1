<#
.SYNOPSIS
  一键安装 Claude for Legal CN to Codex
.DESCRIPTION
  1. 安装本仓库 skills/ 全部内容到 ~/.codex/skills/
  2. 配置 MCP 连接器（通过 Codex-Claude-legal-CN-mcp-connectors 独立仓库）
  3. 配置环境
#>

#Requires -Version 5.1

$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$SkillsDir = "$env:USERPROFILE\.codex\skills"

Write-Host '=== Claude for Legal CN to Codex 安装 ===' -ForegroundColor Green
Write-Host ''

# [1/3] 安装技能
Write-Host '[1/3] 安装技能...' -ForegroundColor Yellow
$domains = @('commercial-legal','privacy-legal','product-legal','corporate-legal',
    'employment-legal','regulatory-legal','ai-governance-legal','litigation-legal',
    'law-student','legal-clinic','legal-builder-hub','ip-legal','solo-law-firm')
foreach ($name in $domains) {
    $src = "$RepoRoot\skills\$name"
    $tgt = "$SkillsDir\$name"
    if (-not (Test-Path $src)) { Write-Host "  [跳过] $name — 源目录不存在"; continue }
    $null = New-Item -ItemType Directory -Force $tgt

    # SKILL.md
    if (Test-Path "$src\SKILL.md") { Copy-Item "$src\SKILL.md" "$tgt\SKILL.md" -Force }

    # CLAUDE.md
    if (Test-Path "$src\CLAUDE.md") { Copy-Item "$src\CLAUDE.md" "$tgt\CLAUDE.md" -Force }

    # README.md
    if (Test-Path "$src\README.md") { Copy-Item "$src\README.md" "$tgt\README.md" -Force }

    # references/
    if (Test-Path "$src\references") {
        $null = New-Item -ItemType Directory -Force "$tgt\references"
        Get-ChildItem "$src\references\*" -File -ErrorAction SilentlyContinue | ForEach-Object {
            Copy-Item $_.FullName "$tgt\references\" -Force
        }
    }

    # skills/（子技能）
    if (Test-Path "$src\skills") {
        Get-ChildItem "$src\skills" -Directory -ErrorAction SilentlyContinue | ForEach-Object {
            $subTgt = "$tgt\skills\$($_.Name)"
            $null = New-Item -ItemType Directory -Force $subTgt
            if (Test-Path "$($_.FullName)\SKILL.md") { Copy-Item "$($_.FullName)\SKILL.md" "$subTgt\SKILL.md" -Force }
        }
    }

    # agents/
    if (Test-Path "$src\agents") {
        $null = New-Item -ItemType Directory -Force "$tgt\agents"
        Get-ChildItem "$src\agents\*" -File -ErrorAction SilentlyContinue | ForEach-Object {
            Copy-Item $_.FullName "$tgt\agents\" -Force
        }
    }
}
# 根技能
$rootTgt = "$SkillsDir\claude-legal-cn"
$null = New-Item -ItemType Directory -Force $rootTgt
Copy-Item "$RepoRoot\skills\claude-legal-cn\SKILL.md" "$rootTgt\SKILL.md" -Force
Write-Host '  技能安装完成'

# solo-law-firm 技能集
$soloSrc = "$RepoRoot\skills\solo-law-firm"
if (Test-Path $soloSrc) {
    $soloDepts = Get-ChildItem -Directory $soloSrc
    foreach ($dept in $soloDepts) {
        $skills = Get-ChildItem -Directory $dept.FullName
        foreach ($skill in $skills) {
            $skillName = $skill.Name
            $tgtDir = "$SkillsDir\solo-law-firm\$($dept.Name)\$skillName"
            $null = New-Item -ItemType Directory -Force $tgtDir
            Copy-Item "$($skill.FullName)\SKILL.md" "$tgtDir\SKILL.md" -Force
        }
    }
    Write-Host "  solo-law-firm 技能安装完成"
}

# [2/3] MCP 连接器
Write-Host '[2/3] 配置 MCP 连接器...' -ForegroundColor Yellow
$McpRepoUrl = 'https://github.com/laubeing-droid/Codex-Claude-legal-CN-mcp-connectors.git'
$McpDir = "$RepoRoot\mcp-connectors"
if (-not (Test-Path "$McpDir\install.ps1")) {
    Write-Host '  正在克隆 MCP 连接器仓库...'
    Push-Location $RepoRoot
    git clone --depth 1 $McpRepoUrl mcp-connectors 2>&1 | Out-Null
    Pop-Location
}
if (Test-Path "$McpDir\install.ps1") {
    Write-Host '  运行 MCP 连接器安装...'
    & "$McpDir\install.ps1"
} else {
    Write-Host '  [警告] 无法获取 MCP 连接器，跳过'
}

# [3/3] 环境配置
Write-Host '[3/3] 配置 PowerShell 执行策略...' -ForegroundColor Yellow
$policy = Get-ExecutionPolicy -Scope CurrentUser 2>$null
if ($policy -eq 'Restricted') {
    Set-ExecutionPolicy -Scope CurrentUser -RemoteSigned -Force
    Write-Host '  执行策略已设为 RemoteSigned'
} else {
    Write-Host '  执行策略正常'
}

# 验证
$missing = @()
$all = $domains + @('claude-legal-cn')
foreach ($name in $all) {
    if (-not (Test-Path "$SkillsDir\$name\SKILL.md")) { $missing += $name }
}
if ($missing.Count -eq 0) {
    Write-Host "  OK: $($all.Count) 个技能" -ForegroundColor Green
} else {
    Write-Host "  缺失: $($missing -join ', ')" -ForegroundColor Red
    exit 1
}

Write-Host ''
Write-Host '安装完成！重启 Codex Desktop 使技能生效。' -ForegroundColor Green
Write-Host 'MCP 连接器由 Codex-Claude-legal-CN-mcp-connectors 管理。' -ForegroundColor Cyan
Write-Host '  配置指南: docs/connectors.md' -ForegroundColor Cyan
