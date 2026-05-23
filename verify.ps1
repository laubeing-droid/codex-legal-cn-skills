<#
.SYNOPSIS
  通用验证脚本：检查 Codex Desktop / Claude Code 安装状态
.DESCRIPTION
  检查每个环境的关键文件是否存在，列出缺失项。
#>

$SkillsDir = "$env:USERPROFILE\.codex\skills"
$VendorDir = "$env:USERPROFILE\.codex\vendor"
$UpstreamDir = "$VendorDir\claude-for-legal-CN"
$ClaudeRulesDir = "$env:USERPROFILE\.claude\rules"
$ClaudeCodeConfig = "$env:USERPROFILE\.claude\settings.json"

$domains = @(
    'codex-for-legal-cn',
    'commercial-legal','privacy-legal','product-legal','corporate-legal',
    'employment-legal','regulatory-legal','ai-governance-legal','litigation-legal',
    'law-student','legal-clinic','legal-builder-hub','ip-legal'
)

Write-Host '=== 中国法律技能包 安装验证 ===' -ForegroundColor Cyan
Write-Host ''

# 环境检测
$hasCodex = Test-Path $SkillsDir
$hasClaudeCode = Test-Path $ClaudeCodeConfig

if ($hasCodex) { Write-Host "[OK] Codex Desktop" -ForegroundColor Green }
else { Write-Host "[!]  Codex Desktop (未安装)" -ForegroundColor DarkGray }

if ($hasClaudeCode) { Write-Host "[OK] Claude Code" -ForegroundColor Green }
else { Write-Host "[!]  Claude Code (未安装)" -ForegroundColor DarkGray }

Write-Host ''

# ─── Codex Desktop 检查 ─────────────────────────────
if ($hasCodex) {
    Write-Host ">>> Codex Desktop (~/.codex/skills/)" -ForegroundColor Yellow
    $allOk = $true
    foreach ($name in $domains) {
        $dir = "$SkillsDir\$name"
        $hasSkill = Test-Path "$dir\SKILL.md"
        $hasClaude = Test-Path "$dir\CLAUDE.md"
        if ($hasSkill -and $hasClaude) {
            Write-Host "  [OK] $name" -ForegroundColor Green
        } elseif ($hasSkill -and -not $hasClaude) {
            Write-Host "  [!]  $name (缺 CLAUDE.md)" -ForegroundColor Yellow
            $allOk = $false
        } else {
            Write-Host "  [!!] $name (缺失)" -ForegroundColor Red
            $allOk = $false
        }
    }
    if (Test-Path "$UpstreamDir\.git") {
        Write-Host "[OK] 上游缓存: $UpstreamDir" -ForegroundColor Green
    } else {
        Write-Host "[!]  上游缓存不存在" -ForegroundColor Yellow
    }
    if ($allOk) { Write-Host '  Codex 验证通过。' -ForegroundColor Green }
    else { Write-Host '  Codex 存在缺失，建议运行 update.ps1。' -ForegroundColor Yellow }
    Write-Host ''
}

# ─── Claude Code 检查 ──────────────────────────────
if ($hasClaudeCode) {
    Write-Host ">>> Claude Code (~/.claude/rules/)" -ForegroundColor Yellow
    $ruleFiles = Get-ChildItem "$ClaudeRulesDir\legal-*.md" -ErrorAction SilentlyContinue
    if ($ruleFiles.Count -eq 0) {
        Write-Host "  [!!] 未找到 legal-*.md 规则文件" -ForegroundColor Red
    } else {
        $claudeOk = $true
        # 检查路由规则
        if (Test-Path "$ClaudeRulesDir\legal-routing.md") {
            Write-Host "  [OK] legal-routing (路由规则)" -ForegroundColor Green
        } else {
            Write-Host "  [!!] legal-routing (缺失)" -ForegroundColor Red
            $claudeOk = $false
        }
        foreach ($name in @('commercial','litigation','employment','privacy','corporate','ip','product','regulatory','ai-governance','law-student','legal-clinic','legal-builder')) {
            $found = $ruleFiles | Where-Object { $_.Name -like "legal-$name*" } | Select-Object -First 1
            if ($found) { Write-Host "  [OK] $($found.Name)" -ForegroundColor Green }
        }
        Write-Host "  Total: $($ruleFiles.Count) 个规则文件" -ForegroundColor Cyan
        if ($claudeOk) { Write-Host '  Claude Code 验证通过。' -ForegroundColor Green }
        else { Write-Host '  Claude Code 存在缺失，建议运行 update.ps1。' -ForegroundColor Yellow }
    }
    Write-Host ''
}

# ─── 总结 ────────────────────────────────────────────
if (-not $hasCodex -and -not $hasClaudeCode) {
    Write-Host '未检测到已安装的 MCP 客户端。请运行 install.ps1。' -ForegroundColor Yellow
} else {
    Write-Host '验证完成。' -ForegroundColor Green
}
