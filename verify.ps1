<#
.SYNOPSIS
  验证 Claude for Legal CN to Codex的安装状态
.DESCRIPTION
  检查每个技能目录的关键文件是否存在，列出缺失项。
#>

#Requires -Version 5.1

$SkillsDir = "$env:USERPROFILE\.codex\skills"
$VendorDir = "$env:USERPROFILE\.codex\vendor"
$UpstreamDir = "$VendorDir\claude-for-legal-CN"

$domains = @(
    'claude-legal-cn',
    'commercial-legal','privacy-legal','product-legal','corporate-legal',
    'employment-legal','regulatory-legal','ai-governance-legal','litigation-legal',
    'law-student','legal-clinic','legal-builder-hub','ip-legal','solo-law-firm'
)

Write-Host '=== Claude for Legal CN to Codex 安装验证 ===' -ForegroundColor Cyan
Write-Host ''

# 检查根目录
if (Test-Path $SkillsDir) {
    Write-Host "[OK] 技能根目录: $SkillsDir" -ForegroundColor Green
} else {
    Write-Host "[!!] 技能根目录不存在，请运行 install.ps1" -ForegroundColor Red
    exit 1
}

# 检查每个技能
$allOk = $true
foreach ($name in $domains) {
    $dir = "$SkillsDir\$name"
    $skillFile = "$dir\SKILL.md"
    $hasSkill = Test-Path $skillFile
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

# 检查上游缓存
Write-Host ''
if (Test-Path "$UpstreamDir\.git") {
    Write-Host "[OK] 上游缓存: $UpstreamDir" -ForegroundColor Green
} else {
    Write-Host "[!]  上游缓存不存在（运行 install.ps1 后会自动克隆）" -ForegroundColor Yellow
}


# solo-law-firm 技能集检查
Write-Host ''
Write-Host '--- solo-law-firm 技能集 ---' -ForegroundColor Cyan
$soloBase = "$SkillsDir\solo-law-firm"
if (Test-Path $soloBase) {
    $soloSkills = Get-ChildItem -Recurse "$soloBase" -Filter 'SKILL.md'
    Write-Host "  [OK] solo-law-firm: $($soloSkills.Count) 个自包含技能" -ForegroundColor Green
} else {
    Write-Host "  [!]  solo-law-firm 目录不存在，请运行 install.ps1" -ForegroundColor Yellow
}

# 总结
Write-Host ''
if ($allOk) {
    Write-Host '验证通过。所有技能安装正常。' -ForegroundColor Green
} else {
    Write-Host '存在缺失文件，建议重新运行 install.ps1。' -ForegroundColor Yellow
}
