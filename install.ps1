<#
.SYNOPSIS
  一键安装 Claude for Legal CN to Codex
.DESCRIPTION
  1. 克隆上游法律内容 (zhou210712/claude-for-legal-ZH)
  2. 安装 SKILL.md 包装层到 ~/.codex/skills/
  3. 配置 MCP 连接器（通过 Codex-Claude-legal-CN-mcp-connectors 独立仓库）
  4. 设置内容链接便于自动更新
#>

#Requires -Version 5.1

$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$SkillsDir = "$env:USERPROFILE\.codex\skills"
$VendorDir = "$env:USERPROFILE\.codex\vendor"
$UpstreamDir = "$VendorDir\claude-for-legal-CN"
$GitUrl = 'https://github.com/zhou210712/claude-for-legal-ZH.git'

Write-Host '=== Claude for Legal CN to Codex 安装 ===' -ForegroundColor Green
Write-Host ''

# [1/4] 上游内容
Write-Host '[1/4] 克隆上游法律内容...' -ForegroundColor Yellow
$null = New-Item -ItemType Directory -Force $VendorDir
if (Test-Path "$UpstreamDir\README.md") {
    Push-Location $UpstreamDir
    git pull 2>&1 | Out-Null
    Pop-Location
    Write-Host "  上游已是最新: $UpstreamDir"
} else {
    Write-Host "  正在克隆: $GitUrl"
    Push-Location $VendorDir
    git clone $GitUrl claude-for-legal-CN 2>&1 | Out-Null
    Pop-Location
    if (-not (Test-Path "$UpstreamDir\README.md")) {
        Write-Host '  [错误] 克隆失败' -ForegroundColor Red
        exit 1
    }
    Write-Host '  上游已克隆'
}

# [2/4] 技能包装层
Write-Host '[2/4] 安装技能包装层...' -ForegroundColor Yellow
$domains = @('commercial-legal','privacy-legal','product-legal','corporate-legal',
    'employment-legal','regulatory-legal','ai-governance-legal','litigation-legal',
    'law-student','legal-clinic','legal-builder-hub','ip-legal','solo-law-firm')
foreach ($name in $domains) {
    $srcSkill = "$RepoRoot\skills\$name\SKILL.md"
    $tgtDir = "$SkillsDir\$name"
    $null = New-Item -ItemType Directory -Force $tgtDir
    if (Test-Path $srcSkill) { Copy-Item $srcSkill "$tgtDir\SKILL.md" -Force }
    $upstreamModule = "$UpstreamDir\$name"
    if (Test-Path "$upstreamModule\CLAUDE.md") { Copy-Item "$upstreamModule\CLAUDE.md" "$tgtDir\CLAUDE.md" -Force }
    if (Test-Path "$upstreamModule\README.md") { Copy-Item "$upstreamModule\README.md" "$tgtDir\README.md" -Force }
    if (Test-Path "$upstreamModule\references") {
        $null = New-Item -ItemType Directory -Force "$tgtDir\references"
        Get-ChildItem "$upstreamModule\references\*" -File -ErrorAction SilentlyContinue | ForEach-Object {
            Copy-Item $_.FullName "$tgtDir\references\" -Force
        }
    }
    if (Test-Path "$upstreamModule\skills") {
        Get-ChildItem "$upstreamModule\skills" -Directory -ErrorAction SilentlyContinue | ForEach-Object {
            $subTgt = "$tgtDir\skills\$($_.Name)"
            $null = New-Item -ItemType Directory -Force $subTgt
            if (Test-Path "$($_.FullName)\SKILL.md") { Copy-Item "$($_.FullName)\SKILL.md" "$subTgt\SKILL.md" -Force }
        }
    }
    if (Test-Path "$upstreamModule\agents") {
        $null = New-Item -ItemType Directory -Force "$tgtDir\agents"
        Get-ChildItem "$upstreamModule\agents\*" -File -ErrorAction SilentlyContinue | ForEach-Object {
            Copy-Item $_.FullName "$tgtDir\agents\" -Force
        }
    }
}
# 根技能
$rootTgt = "$SkillsDir\claude-legal-cn"
$null = New-Item -ItemType Directory -Force $rootTgt
Copy-Item "$RepoRoot\skills\claude-legal-cn\SKILL.md" "$rootTgt\SKILL.md" -Force
Write-Host '  技能安装完成'


# [2.5/4] solo-law-firm 技能集（自包含，无需上游）
Write-Host '[2.5/4] 安装 solo-law-firm 技能集...' -ForegroundColor Yellow
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
} else {
    Write-Host "  [警告] solo-law-firm 技能源目录不存在，跳过" -ForegroundColor Yellow
}

# [3/4] MCP 连接器（委托到独立仓库）
Write-Host '[3/4] 配置 MCP 连接器...' -ForegroundColor Yellow
$McpRepoUrl = 'https://github.com/laubeing-droid/Codex-Claude-legal-CN-mcp-connectors.git'
$McpDir = "$RepoRoot\mcp-connectors"
if (-not (Test-Path "$McpDir\install.ps1")) {
    Write-Host '  正在克隆 MCP 连接器仓库...' -ForegroundColor Yellow
    Push-Location $RepoRoot
    git clone --depth 1 $McpRepoUrl mcp-connectors 2>&1 | Out-Null
    Pop-Location
}
if (Test-Path "$McpDir\install.ps1") {
    Write-Host '  运行 MCP 连接器安装脚本...' -ForegroundColor Yellow
    & "$McpDir\install.ps1"
} else {
    Write-Host '  [警告] 无法获取 MCP 连接器，跳过' -ForegroundColor Yellow
}

# [4/4] 环境配置
Write-Host '[4/4] 配置 PowerShell 执行策略...' -ForegroundColor Yellow
$policy = Get-ExecutionPolicy -Scope CurrentUser 2>$null
if ($policy -eq 'Restricted') {
    Set-ExecutionPolicy -Scope CurrentUser -RemoteSigned -Force
    Write-Host '  执行策略已设为 RemoteSigned'
} else {
    Write-Host '  执行策略正常'
}

# 验证
$missing = @()
$all = $domains + @('claude-legal-cn'); $soloCount = 0; if (Test-Path "$SkillsDir\solo-law-firm") { Get-ChildItem -Recurse "$SkillsDir\solo-law-firm" -Filter 'SKILL.md' | ForEach-Object { $soloCount++ } }
foreach ($name in $all) {
    if (-not (Test-Path "$SkillsDir\$name\SKILL.md")) { $missing += $name }
}
if ($missing.Count -eq 0) {
    Write-Host "  OK: $($all.Count) 个入口技能 + $soloCount 个 solo-law-firm 技能" -ForegroundColor Green
} else {
    Write-Host "  缺失: $($missing -join ', ')" -ForegroundColor Red
    exit 1
}

Write-Host ''
Write-Host '安装完成！重启 Codex Desktop 使技能生效。' -ForegroundColor Green
Write-Host 'MCP 连接器由 Codex-Claude-legal-CN-mcp-connectors 管理，替换凭证即可使用。' -ForegroundColor Cyan
Write-Host '  配置指南: docs/connectors.md' -ForegroundColor Cyan
Write-Host '  独立仓库: https://github.com/laubeing-droid/Codex-Claude-legal-CN-mcp-connectors' -ForegroundColor Cyan

