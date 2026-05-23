<#
.SYNOPSIS
  通用安装脚本：Codex Desktop / Claude Code / Claude Desktop
.DESCRIPTION
  自动检测本机环境，安装中国法律技能到所有检测到的客户端：
  1. 克隆上游法律内容
  2. 安装到 Codex ~/.codex/skills/ 或 Claude Code ~/.claude/rules/
  3. 配置 MCP 连接器（委托 mcp-connectors）
  4. 环境配置
#>

$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

# ─── 路径常量 ──────────────────────────────────────────
$VendorDir = "$env:USERPROFILE\.codex\vendor"
$UpstreamDir = "$VendorDir\claude-for-legal-CN"
$GitUrl = 'https://github.com/SH88-source/claude-for-legal-CN.git'
$SkillsDir = "$env:USERPROFILE\.codex\skills"
$ClaudeRulesDir = "$env:USERPROFILE\.claude\rules"
$ClaudeCodeConfig = "$env:USERPROFILE\.claude\settings.json"
$McpRepoUrl = 'https://github.com/laubeing-droid/codex-legal-mcp-connectors.git'
$McpDir = "$RepoRoot\mcp-connectors"

$domains = @('commercial-legal','privacy-legal','product-legal','corporate-legal',
    'employment-legal','regulatory-legal','ai-governance-legal','litigation-legal',
    'law-student','legal-clinic','legal-builder-hub','ip-legal')

# ─── 环境检测 ──────────────────────────────────────────
function Test-Env {
    param([string]$Path)
    return (Test-Path $Path)
}

Write-Host '=== 中国法律技能包 通用安装 ===' -ForegroundColor Green
Write-Host ''

# 检测各环境
$hasCodex = Test-Env "$env:USERPROFILE\.codex"
$hasClaudeCode = Test-Env $ClaudeCodeConfig
$hasClaudeDesktop = Test-Env "$env:LOCALAPPDATA\Claude\claude_desktop_config.json"

$targets = @()
if ($hasCodex) { $targets += 'codex'; Write-Host '  [OK] Codex Desktop' -ForegroundColor Green }
else { Write-Host '  [!]  Codex Desktop (未安装)' -ForegroundColor DarkGray }

if ($hasClaudeCode) { $targets += 'claude-code'; Write-Host '  [OK] Claude Code' -ForegroundColor Green }
else { Write-Host '  [!]  Claude Code (未安装)' -ForegroundColor DarkGray }

if ($hasClaudeDesktop) { $targets += 'claude-desktop'; Write-Host '  [OK] Claude Desktop' -ForegroundColor Green }
else { Write-Host '  [!]  Claude Desktop (未安装)' -ForegroundColor DarkGray }

if ($targets.Count -eq 0) {
    Write-Host '  [!!] 未检测到任何 MCP 客户端。将仅安装上游缓存和 MCP 连接器。' -ForegroundColor Yellow
    $targets = @('codex')  # fallback: 至少配 Codex 格式
}

Write-Host ''

# ─── [1/4] 上游内容 ──────────────────────────────────
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
        Write-Host '  [错误] 克隆失败' -ForegroundColor Red; exit 1
    }
    Write-Host '  上游已克隆'
}

# ─── [2/4] 安装到目标环境 ────────────────────────────
Write-Host '[2/4] 安装技能...' -ForegroundColor Yellow

foreach ($name in $domains) {
    $upstreamModule = "$UpstreamDir\$name"
    if (-not (Test-Path $upstreamModule)) { continue }

    # ---- Codex Desktop: ~/.codex/skills/<domain>/ ----
    if ($targets -contains 'codex') {
        $tgtDir = "$SkillsDir\$name"
        $null = New-Item -ItemType Directory -Force $tgtDir
        # 本仓库 SKILL.md（入口包装层）
        $srcSkill = "$RepoRoot\skills\$name\SKILL.md"
        if (Test-Path $srcSkill) { Copy-Item $srcSkill "$tgtDir\SKILL.md" -Force }
        # 上游内容
        if (Test-Path "$upstreamModule\CLAUDE.md") { Copy-Item "$upstreamModule\CLAUDE.md" "$tgtDir\CLAUDE.md" -Force }
        if (Test-Path "$upstreamModule\README.md") { Copy-Item "$upstreamModule\README.md" "$tgtDir\README.md" -Force }
        if (Test-Path "$upstreamModule\.mcp.json") { Copy-Item "$upstreamModule\.mcp.json" "$tgtDir\.mcp.json" -Force }
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

    # ---- Claude Code: ~/.claude/rules/legal-<domain>.md ----
    if ($targets -contains 'claude-code') {
        $ruleDir = "$ClaudeRulesDir"
        $null = New-Item -ItemType Directory -Force $ruleDir
        $ruleFile = "$ruleDir\legal-$name.md"
        if (-not (Test-Path $ruleFile)) {
            # 从上游 CLAUDE.md 提取核心指令，生成规则文件
            $upstreamClaude = ""
            if (Test-Path "$upstreamModule\CLAUDE.md") {
                $upstreamClaude = Get-Content "$upstreamModule\CLAUDE.md" -Encoding UTF8 -Raw
            }
            # 写规则文件头 + 路由 + 上游内容摘要
            $ruleContent = @"
# 中国法律技能：$name
# 此文件由 install.ps1 自动生成，来自 SH88-source/claude-for-legal-CN

## 领域说明
$(if (Test-Path "$upstreamModule\README.md") { (Get-Content "$upstreamModule\README.md" -Encoding UTF8 -Raw) } else { "中国法律 $name 领域技能" })

## 上游指令
上游完整内容缓存于: $UpstreamDir\$name

"@
            Set-Content -Path $ruleFile -Value $ruleContent -Encoding UTF8
            Write-Host "  [添加] Claude Code -> $name" -ForegroundColor Green
        } else {
            Write-Host "  [跳过] Claude Code -> $name (已存在)" -ForegroundColor DarkYellow
        }
    }
}

# 根技能（路由规则）
if ($targets -contains 'codex') {
    $rootTgt = "$SkillsDir\codex-for-legal-cn"
    $null = New-Item -ItemType Directory -Force $rootTgt
    Copy-Item "$RepoRoot\skills\codex-for-legal-cn\SKILL.md" "$rootTgt\SKILL.md" -Force
}
if ($targets -contains 'claude-code') {
    # 创建路由规则文件（适用于 Claude Code）
    $routingRule = "$ClaudeRulesDir\legal-routing.md"
    $routingContent = @"
# 中国法律技能自动路由规则

当用户提出法律相关问题时，根据关键词自动路由到对应领域。每个领域的详细指令在对应的 legal-<domain>.md 规则文件中。

## 路由表

| 关键词 | 路由到 | 规则文件 |
|--------|--------|---------|
| 诉讼、仲裁、执行、保全、证据、代理词 | litigation-legal | legal-litigation-legal.md |
| 合同审查、违约、补充协议、函件 | commercial-legal | legal-commercial-legal.md |
| 公司、股权、投资、尽调、并购 | corporate-legal | legal-corporate-legal.md |
| 劳动、社保、解除、竞业、规章制度 | employment-legal | legal-employment-legal.md |
| 隐私、个保法、数据、出境 | privacy-legal | legal-privacy-legal.md |
| 产品上线、营销合规、广告法 | product-legal | legal-product-legal.md |
| 监管、合规跟踪、政策变化 | regulatory-legal | legal-regulatory-legal.md |
| AI治理、算法、伦理审查 | ai-governance-legal | legal-ai-governance-legal.md |
| 商标、专利、著作权、侵权 | ip-legal | legal-ip-legal.md |
| 法考、案例学习、法律学习 | law-student | legal-law-student.md |
| 法律诊所、法律援助 | legal-clinic | legal-legal-clinic.md |
| 技能安装、技能管理 | legal-builder-hub | legal-legal-builder-hub.md |

## MCP 连接器

已配置以下中国法律 MCP 连接器（在 ~/.claude/settings.json 的 mcpServers 段）：
- **chineselaw（推荐）**：33 个工具，覆盖法规、案例、企业信息检索
- **北大法宝（备选）**：10 个专用 MCP 服务

使用法律检索任务时优先调用已配置的 MCP 连接器获取当前有效法条和案例。
如 MCP 连接器不可用，基于训练数据工作，引用标注 [需验证]。

## 重要限制

- 所有输出均为律师审查草稿，不构成法律意见
- 引用法规须核验现行有效性
- 提交/发送前需经执业律师审核
"@
    if (-not (Test-Path $routingRule)) {
        Set-Content -Path $routingRule -Value $routingContent -Encoding UTF8
        Write-Host "  [添加] Claude Code -> legal-routing (路由规则)" -ForegroundColor Green
    } else {
        Write-Host "  [跳过] Claude Code -> legal-routing (已存在)" -ForegroundColor DarkYellow
    }
}
Write-Host '  技能安装完成'

# ─── [3/4] MCP 连接器 ───────────────────────────────
Write-Host '[3/4] 配置 MCP 连接器...' -ForegroundColor Yellow
if (-not (Test-Path "$McpDir\detect.ps1")) {
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

# ─── [4/4] 环境配置 ──────────────────────────────────
Write-Host '[4/4] 环境配置...' -ForegroundColor Yellow
$policy = Get-ExecutionPolicy -Scope CurrentUser 2>$null
if ($policy -eq 'Restricted') {
    Set-ExecutionPolicy -Scope CurrentUser -RemoteSigned -Force
    Write-Host '  执行策略已设为 RemoteSigned'
} else {
    Write-Host '  执行策略正常'
}

# ─── 验证 ─────────────────────────────────────────────
$all = $domains + @('codex-for-legal-cn')
if ($targets -contains 'codex') {
    $missing = @()
    foreach ($name in $all) {
        if (-not (Test-Path "$SkillsDir\$name\SKILL.md")) { $missing += $name }
    }
    if ($missing.Count -eq 0) {
        Write-Host "  [OK] Codex: $($all.Count) 个技能" -ForegroundColor Green
    } else {
        Write-Host "  [!!] Codex: 缺失 $($missing -join ', ')" -ForegroundColor Yellow
    }
}
if ($targets -contains 'claude-code') {
    $ruleCount = (Get-ChildItem "$ClaudeRulesDir\legal-*.md" -ErrorAction SilentlyContinue).Count
    Write-Host "  [OK] Claude Code: $ruleCount 个规则文件" -ForegroundColor Green
}

Write-Host ''
Write-Host '安装完成！重启对应客户端使生效。' -ForegroundColor Green
Write-Host '环境:' -ForegroundColor Cyan
foreach ($t in $targets) {
    $paths = @{
        'codex' = "~/.codex/skills/ (Codex Desktop)"
        'claude-code' = "~/.claude/rules/ (Claude Code)"
        'claude-desktop' = "Claude Desktop (Claude Plugin)"
    }
    Write-Host "  - $($paths[$t])" -ForegroundColor Cyan
}
Write-Host 'MCP 连接器由 codex-legal-mcp-connectors 管理。' -ForegroundColor Cyan
Write-Host '  仓库: https://github.com/laubeing-droid/codex-legal-mcp-connectors' -ForegroundColor Cyan
