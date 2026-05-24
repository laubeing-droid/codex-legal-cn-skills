<#
.SYNOPSIS
  手动更新 Claude for Legal CN to Codex
.DESCRIPTION
  1. 从本仓库同步 skills/ 全部内容到 ~/.codex/skills/
  2. MCP 连接器检查（委托给 Codex-Claude-legal-CN-mcp-connectors 仓库）
  3. 验证安装完整性
#>

#Requires -Version 5.1

$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$SkillsDir = "$env:USERPROFILE\.codex\skills"
$McpDir = "$RepoRoot\mcp-connectors"
$McpRepoUrl = 'https://github.com/laubeing-droid/Codex-Claude-legal-CN-mcp-connectors.git'

$domains = @(
    'commercial-legal','privacy-legal','product-legal','corporate-legal',
    'employment-legal','regulatory-legal','ai-governance-legal','litigation-legal',
    'law-student','legal-clinic','legal-builder-hub','ip-legal','solo-law-firm'
)

Write-Host '=== 更新 Codex 中国法律技能 ===' -ForegroundColor Green

# ---- [1/3] 同步技能 ----
Write-Host '[1/3] 同步技能...' -ForegroundColor Yellow
$count = 0
foreach ($name in $domains) {
    $src = "$RepoRoot\skills\$name"
    $tgt = "$SkillsDir\$name"
    if (-not (Test-Path $src)) { continue }
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

    $count++
}
# 根技能
$rootTgt = "$SkillsDir\claude-legal-cn"
$null = New-Item -ItemType Directory -Force $rootTgt
Copy-Item "$RepoRoot\skills\claude-legal-cn\SKILL.md" "$rootTgt\SKILL.md" -Force
Write-Host "  已同步 $count 个技能领域 + 根技能"

# ---- [2/3] MCP 连接器检查 ----
Write-Host '[2/3] MCP 连接器检查...' -ForegroundColor Yellow
if (-not (Test-Path "$McpDir\verify.ps1")) {
    Write-Host '  正在克隆 MCP 连接器仓库...'
    Push-Location $RepoRoot
    git clone --depth 1 $McpRepoUrl mcp-connectors 2>&1 | Out-Null
    Pop-Location
}
if (Test-Path "$McpDir\verify.ps1") {
    Write-Host '  运行 MCP 连接器验证...'
    & "$McpDir\verify.ps1"
} else {
    Write-Host '  [警告] 无法获取 MCP 连接器验证脚本，跳过 MCP 检查'
}

# ---- [3/3] 验证安装完整性 ----
Write-Host '[3/3] 验证安装完整性...' -ForegroundColor Yellow
$missing = @()
$all = $domains + @('claude-legal-cn')
foreach ($name in $all) {
    if (-not (Test-Path "$SkillsDir\$name\SKILL.md")) { $missing += $name }
}
if ($missing.Count -eq 0) {
    Write-Host "  [OK] $($all.Count) 个技能全部存在" -ForegroundColor Green
} else {
    Write-Host "  [!!] 缺失 $($missing.Count) 个技能: $($missing -join ', ')"
}

Write-Host ''
Write-Host '更新完成。重启 Codex Desktop 使新内容生效。' -ForegroundColor Green
Write-Host 'MCP 连接器由 Codex-Claude-legal-CN-mcp-connectors 独立管理。' -ForegroundColor Cyan
