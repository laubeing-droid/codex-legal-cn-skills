<#
.SYNOPSIS
  一键安装 Claude for Legal CN to Codex
.DESCRIPTION
  自动安装必需依赖（core-codices + alignment-framework + mcp-hub），
  可选安装 judgment-predictor，然后部署技能到 ~/.codex/skills/。
#>
#Requires -Version 5.1

$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$SkillsDir = "$env:USERPROFILE\.codex\skills"
$ParentDir = Split-Path -Parent $RepoRoot

Write-Host "=== Claude for Legal CN to Codex 安装 ===" -ForegroundColor Green
Write-Host ""

# =========================================================
# [0] 必需依赖 — 自动安装，无需确认
# =========================================================
Write-Host "[0] 安装必需依赖..." -ForegroundColor Yellow

function Install-Required {
    param($Name, $RepoUrl, $DirName)
    $targetPath = Join-Path $ParentDir $DirName
    if (Test-Path $targetPath) {
        Write-Host "  [OK] $Name 已存在: $targetPath" -ForegroundColor Green
        return
    }
    Write-Host "  [安装] $Name -> $targetPath" -ForegroundColor Yellow
    Push-Location $ParentDir
    git clone --depth 1 $RepoUrl $DirName 2>&1 | Out-Null
    Pop-Location
    Write-Host "  [OK] $Name 安装完成" -ForegroundColor Green
}

# 三项必需
Install-Required -Name "core-codices (162部法律全文JSON)" `
    -RepoUrl "https://github.com/laubeing-droid/codex-claude-legal-cn-core-codices.git" `
    -DirName "codex-claude-legal-cn-core-codices"

Install-Required -Name "PRC-US-Legal-Semantic-Alignment-Framework (中美法律对齐)" `
    -RepoUrl "https://github.com/laubeing-droid/PRC-US-Legal-Semantic-Alignment-Framework.git" `
    -DirName "PRC-US-Legal-Semantic-Alignment-Framework"

Install-Required -Name "codex-claude-legal-cn-mcp-hub (MCP连接器)" `
    -RepoUrl "https://github.com/laubeing-droid/codex-claude-legal-cn-mcp-hub.git" `
    -DirName "codex-claude-legal-cn-mcp-hub"

# =========================================================
# [0b] 可选 — judgment-predictor
# =========================================================
Write-Host ""
$judgmentDir = Join-Path $ParentDir "Codex-Legal-CN-Judgment-Predictor"
if (Test-Path $judgmentDir) {
    Write-Host "  [OK] judgment-predictor 已存在" -ForegroundColor Green
} else {
    $choice = Read-Host "  安装 judgment-predictor (AI裁判预测)？[Y/n]"
    if ($choice -eq '' -or $choice -eq 'y' -or $choice -eq 'Y') {
        Write-Host "  [安装] judgment-predictor -> $judgmentDir" -ForegroundColor Yellow
        Push-Location $ParentDir
        git clone --depth 1 https://github.com/laubeing-droid/Codex-Legal-CN-Judgment-Predictor.git Codex-Legal-CN-Judgment-Predictor 2>&1 | Out-Null
        Pop-Location
        Write-Host "  [OK] judgment-predictor 安装完成" -ForegroundColor Green
    } else {
        Write-Host "  [跳过] judgment-predictor" -ForegroundColor DarkGray
    }
}

Write-Host ""

# =========================================================
# [1/3] 安装技能
# =========================================================
Write-Host "[1/3] 安装技能..." -ForegroundColor Yellow

$domains = @("commercial-legal","privacy-legal","product-legal","corporate-legal",
    "employment-legal","regulatory-legal","ai-governance-legal","litigation-legal",
    "law-student","legal-clinic","legal-builder-hub","ip-legal","solo-law-firm")

foreach ($name in $domains) {
    $src = "$RepoRoot\skills\$name"
    $tgt = "$SkillsDir\$name"
    if (-not (Test-Path $src)) { Write-Host "  [跳过] $name"; continue }
    $null = New-Item -ItemType Directory -Force $tgt
    if (Test-Path "$src\SKILL.md") { Copy-Item "$src\SKILL.md" "$tgt\SKILL.md" -Force }
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
}

$rootTgt = "$SkillsDir\claude-legal-cn"
$null = New-Item -ItemType Directory -Force $rootTgt
Copy-Item "$RepoRoot\skills\claude-legal-cn\SKILL.md" "$rootTgt\SKILL.md" -Force
Write-Host "  技能安装完成"

# solo-law-firm
$soloSrc = "$RepoRoot\skills\solo-law-firm"
if (Test-Path $soloSrc) {
    foreach ($dept in Get-ChildItem -Directory $soloSrc) {
        foreach ($skill in Get-ChildItem -Directory $dept.FullName) {
            $tgtDir = "$SkillsDir\solo-law-firm\$($dept.Name)\$($skill.Name)"
            $null = New-Item -ItemType Directory -Force $tgtDir
            Copy-Item "$($skill.FullName)\SKILL.md" "$tgtDir\SKILL.md" -Force
        }
    }
    Write-Host "  solo-law-firm 技能安装完成"
}

# =========================================================
# [2/3] MCP 连接器安装
# =========================================================
Write-Host "[2/3] 安装 MCP 连接器..." -ForegroundColor Yellow
$McpDir = Join-Path $ParentDir "codex-claude-legal-cn-mcp-hub"
if (Test-Path "$McpDir\install.ps1") {
    Write-Host "  运行 MCP 连接器安装..."
    & "$McpDir\install.ps1"
} else {
    Write-Host "  [警告] MCP 连接器未找到: $McpDir" -ForegroundColor Red
}

# =========================================================
# [3/3] 环境配置
# =========================================================
Write-Host "[3/3] 配置环境..." -ForegroundColor Yellow
$policy = Get-ExecutionPolicy -Scope CurrentUser 2>$null
if ($policy -eq "Restricted") {
    Set-ExecutionPolicy -Scope CurrentUser -RemoteSigned -Force
    Write-Host "  执行策略已设为 RemoteSigned"
} else {
    Write-Host "  执行策略正常"
}

# =========================================================
# 验证
# =========================================================
$missing = @()
foreach ($name in $domains) {
    if (Test-Path "$RepoRoot\skills\$name" -and -not (Test-Path "$SkillsDir\$name\SKILL.md")) {
        $missing += $name
    }
}
if (-not (Test-Path "$SkillsDir\claude-legal-cn\SKILL.md")) { $missing += "claude-legal-cn" }

if ($missing.Count -eq 0) {
    Write-Host "  OK: 所有技能部署完整" -ForegroundColor Green
} else {
    Write-Host "  缺失: $($missing -join ", ")" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  安装完成！重启 Codex Desktop 使技能生效。" -ForegroundColor Green
Write-Host ""
Write-Host "  已安装:" -ForegroundColor Cyan
Write-Host "    [必需] codex-claude-legal-cn-core-codices    — 162部法律全文JSON" -ForegroundColor White
Write-Host "    [必需] PRC-US-Legal-Semantic-Alignment-Framework — 中美法律语义对齐" -ForegroundColor White
Write-Host "    [必需] codex-claude-legal-cn-mcp-hub          — MCP连接器" -ForegroundColor White
if (Test-Path $judgmentDir) {
    Write-Host "    [可选] Codex-Legal-CN-Judgment-Predictor     — AI裁判预测" -ForegroundColor White
}
Write-Host "========================================" -ForegroundColor Green
