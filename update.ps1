<#
.SYNOPSIS
  通用更新脚本：同步上游 + 更新全环境技能 + 委托 MCP 诊断
.DESCRIPTION
  1. 从上游拉取最新内容
  2. 同步到 Codex ~/.codex/skills/ 或 Claude Code ~/.claude/rules/
  3. MCP 连接器诊断（委托 mcp-connectors）
  4. 验证安装完整性
#>

$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$SkillsDir = "$env:USERPROFILE\.codex\skills"
$UpstreamDir = "$env:USERPROFILE\.codex\vendor\claude-for-legal-CN"
$ClaudeRulesDir = "$env:USERPROFILE\.claude\rules"
$ClaudeCodeConfig = "$env:USERPROFILE\.claude\settings.json"
$McpDir = "$RepoRoot\mcp-connectors"
$McpRepoUrl = 'https://github.com/laubeing-droid/codex-legal-mcp-connectors.git'

$domains = @(
    'commercial-legal','privacy-legal','product-legal','corporate-legal',
    'employment-legal','regulatory-legal','ai-governance-legal','litigation-legal',
    'law-student','legal-clinic','legal-builder-hub','ip-legal'
)

function Test-Env { param([string]$Path) return (Test-Path $Path) }

Write-Host '=== 更新中国法律技能 ===' -ForegroundColor Green

# [1/5] 上游更新
Write-Host '[1/5] 更新上游内容...' -ForegroundColor Yellow
if (-not (Test-Path "$UpstreamDir\.git")) {
    Write-Host '[错误] 上游内容不存在。请先运行 install.ps1。' -ForegroundColor Red
    exit 1
}
Push-Location $UpstreamDir
$result = git pull 2>&1
Pop-Location
Write-Host "  [上游] $($result -join '')"

# [2/5] 同步技能
Write-Host '[2/5] 同步技能...' -ForegroundColor Yellow
$hasCodex = Test-Env "$env:USERPROFILE\.codex"
$hasClaudeCode = Test-Env $ClaudeCodeConfig

foreach ($name in $domains) {
    $src = "$UpstreamDir\$name"
    if (-not (Test-Path $src)) { continue }

    # Codex Desktop
    if ($hasCodex) {
        $tgt = "$SkillsDir\$name"
        $null = New-Item -ItemType Directory -Force $tgt
        $localSkill = "$RepoRoot\skills\$name\SKILL.md"
        if (Test-Path $localSkill) { Copy-Item $localSkill "$tgt\SKILL.md" -Force }
        if (Test-Path "$src\CLAUDE.md") { Copy-Item "$src\CLAUDE.md" "$tgt\CLAUDE.md" -Force }
        if (Test-Path "$src\README.md") { Copy-Item "$src\README.md" "$tgt\README.md" -Force }
        if (Test-Path "$src\.mcp.json") { Copy-Item "$src\.mcp.json" "$tgt\.mcp.json" -Force -ErrorAction SilentlyContinue }
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
    }

    # Claude Code
    if ($hasClaudeCode) {
        $null = New-Item -ItemType Directory -Force $ClaudeRulesDir
        $ruleFile = "$ClaudeRulesDir\legal-$name.md"
        if (Test-Path "$src\CLAUDE.md") {
            $claudeContent = Get-Content "$src\CLAUDE.md" -Encoding UTF8 -Raw
            $ruleContent = @"
# 中国法律技能：$name
# 自动同步自 SH88-source/claude-for-legal-CN | 更新时间: $(Get-Date -Format 'yyyy-MM-dd HH:mm')

$(if (Test-Path "$src\README.md") { Get-Content "$src\README.md" -Encoding UTF8 -Raw })

## 上游核心指令
$claudeContent
"@
            Set-Content -Path $ruleFile -Value $ruleContent -Encoding UTF8
        }
    }
}

# 根技能
if ($hasCodex) {
    $rootTgt = "$SkillsDir\codex-for-legal-cn"
    $null = New-Item -ItemType Directory -Force $rootTgt
    Copy-Item "$RepoRoot\skills\codex-for-legal-cn\SKILL.md" "$rootTgt\SKILL.md" -Force
}
Write-Host '  同步完成'

# [3/5] MCP 验证（委托）
Write-Host '[3/5] MCP 连接器检查...' -ForegroundColor Yellow
if (-not (Test-Path "$McpDir\detect.ps1")) {
    Write-Host '  正在克隆 MCP 连接器仓库...'
    Push-Location $RepoRoot
    git clone --depth 1 $McpRepoUrl mcp-connectors 2>&1 | Out-Null
    Pop-Location
}
if (Test-Path "$McpDir\verify.ps1") {
    & "$McpDir\verify.ps1"
} else {
    Write-Host '  [警告] 无法获取 MCP 验证脚本' -ForegroundColor Yellow
}

# [4/5] MCP 更新
Write-Host '[4/5] MCP 连接器更新...' -ForegroundColor Yellow
if (Test-Path "$McpDir\update.ps1") {
    & "$McpDir\update.ps1"
} else {
    Write-Host '  MCP 更新脚本不可用，跳过' -ForegroundColor DarkGray
}

# [5/5] 验证完整性
Write-Host '[5/5] 验证安装完整性...' -ForegroundColor Yellow
if ($hasCodex) {
    $missing = @()
    $all = $domains + @('codex-for-legal-cn')
    foreach ($name in $all) {
        if (-not (Test-Path "$SkillsDir\$name\SKILL.md")) { $missing += $name }
    }
    if ($missing.Count -eq 0) {
        Write-Host "  [OK] Codex: $($all.Count) 个技能" -ForegroundColor Green
    } else {
        Write-Host "  [!!] Codex: 缺失 $($missing -join ', ')" -ForegroundColor Yellow
    }
}
if ($hasClaudeCode) {
    $ruleCount = (Get-ChildItem "$ClaudeRulesDir\legal-*.md" -ErrorAction SilentlyContinue).Count
    Write-Host "  [OK] Claude Code: $ruleCount 个规则文件" -ForegroundColor Green
}

Write-Host ''
Write-Host '更新完成。重启对应客户端使生效。' -ForegroundColor Green
Write-Host 'MCP 连接器由 codex-legal-mcp-connectors 管理。' -ForegroundColor Cyan
