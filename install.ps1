<#
.SYNOPSIS
  一键安装 Codex 中国法律技能包
.DESCRIPTION
  1. 克隆上游法律内容 (SH88-source/claude-for-legal-CN)
  2. 安装 SKILL.md 包装层到 ~/.codex/skills/
  3. 设置 git 目录联接便于自动更新
#>

$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$SkillsDir = "$env:USERPROFILE\.codex\skills"
$VendorDir = "$env:USERPROFILE\.codex\vendor"

# 自动推断上游路径
# 优先：本仓库的同级目录
$ParentDir = Split-Path -Parent $RepoRoot
$UpstreamSource = Join-Path $ParentDir 'claude-for-legal-CN'
if (-not (Test-Path "$UpstreamSource\README.md")) {
    # 备选：用户文档目录
    $UpstreamSource = "$env:USERPROFILE\Documents\codex-legal\claude-for-legal-CN"
}
$UpstreamLink = "$VendorDir\claude-for-legal-ZH"
$GitUrl = 'https://github.com/SH88-source/claude-for-legal-CN.git'

Write-Host '=== Codex 中国法律技能包 安装 ===' -ForegroundColor Green
Write-Host ''

Write-Host '[1/4] 检查上游法律内容...' -ForegroundColor Yellow
if (-not (Test-Path "$UpstreamSource\README.md")) {
    $cloneDir = Join-Path $ParentDir 'claude-for-legal-CN'
    $null = New-Item -ItemType Directory -Force (Split-Path -Parent $cloneDir)
    Write-Host "  正在克隆上游: $GitUrl"
    Push-Location (Split-Path -Parent $cloneDir)
    git clone $GitUrl claude-for-legal-CN 2>&1 | Out-Null
    Pop-Location
    $UpstreamSource = $cloneDir
    Write-Host '  上游内容已克隆'
} else {
    Write-Host "  上游内容已就绪: $UpstreamSource"
}

Write-Host '[2/4] 设置内容链接...' -ForegroundColor Yellow
$null = New-Item -ItemType Directory -Force $VendorDir
if (Test-Path $UpstreamLink) {
    Remove-Item $UpstreamLink -Force -Recurse -ErrorAction SilentlyContinue
}
$null = New-Item -ItemType Junction -Path $UpstreamLink -Target $UpstreamSource -Force
Write-Host "  目录联接: $UpstreamLink -> $UpstreamSource"

Write-Host '[3/4] 安装技能包装层...' -ForegroundColor Yellow
$domains = @('commercial-legal','privacy-legal','product-legal','corporate-legal',
    'employment-legal','regulatory-legal','ai-governance-legal','litigation-legal',
    'law-student','legal-clinic','legal-builder-hub','ip-legal')
foreach ($name in $domains) {
    $srcSkill = "$RepoRoot\skills\$name\SKILL.md"
    $tgtDir = "$SkillsDir\$name"
    if (Test-Path $srcSkill) {
        $null = New-Item -ItemType Directory -Force $tgtDir
        Copy-Item $srcSkill "$tgtDir\SKILL.md" -Force
    }
    $upstreamModule = "$UpstreamSource\$name"
    if (Test-Path "$upstreamModule\CLAUDE.md") { Copy-Item "$upstreamModule\CLAUDE.md" "$tgtDir\CLAUDE.md" -Force }
    if (Test-Path "$upstreamModule\README.md") { Copy-Item "$upstreamModule\README.md" "$tgtDir\README.md" -Force }
    if (Test-Path "$upstreamModule\.mcp.json") { Copy-Item "$upstreamModule\.mcp.json" "$tgtDir\.mcp.json" -Force }
    if (Test-Path "$upstreamModule\references") {
        $null = New-Item -ItemType Directory -Force "$tgtDir\references"
        Get-ChildItem "$upstreamModule\references\*" -File | ForEach-Object { Copy-Item $_.FullName "$tgtDir\references\" -Force }
    }
    if (Test-Path "$upstreamModule\skills") {
        Get-ChildItem "$upstreamModule\skills" -Directory | ForEach-Object {
            $subTgt = "$tgtDir\skills\$($_.Name)"
            $null = New-Item -ItemType Directory -Force $subTgt
            if (Test-Path "$($_.FullName)\SKILL.md") { Copy-Item "$($_.FullName)\SKILL.md" "$subTgt\SKILL.md" -Force }
        }
    }
    if (Test-Path "$upstreamModule\agents") {
        $null = New-Item -ItemType Directory -Force "$tgtDir\agents"
        Get-ChildItem "$upstreamModule\agents\*" -File | ForEach-Object { Copy-Item $_.FullName "$tgtDir\agents\" -Force }
    }
}
# 根技能
Copy-Item "$RepoRoot\skills\codex-for-legal-cn\SKILL.md" "$SkillsDir\codex-for-legal-cn\SKILL.md" -Force
Write-Host '  技能安装完成'

Write-Host '[4/4] 检查运行环境...' -ForegroundColor Yellow
$policy = Get-ExecutionPolicy -Scope CurrentUser 2>$null
if ($policy -eq 'Restricted') {
    Set-ExecutionPolicy -Scope CurrentUser -RemoteSigned -Force
    Write-Host '  执行策略已设为 RemoteSigned'
}
Write-Host ''
Write-Host ' 安装完成！请重启 Codex 终端使技能生效。' -ForegroundColor Green
Write-Host '  之后每次使用法律技能时会自动更新。'
