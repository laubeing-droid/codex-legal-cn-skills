param([switch]$Update)
$ErrorActionPreference='Stop'
$RepoRoot=Split-Path -Parent $PSScriptRoot
$PatchDir="$RepoRoot/patches"
Write-Host "=== 法律对齐框架 检查 ===" -ForegroundColor Cyan
$fw="$RepoRoot/../PRC-US-Legal-Semantic-Alignment-Framework/PRC-US-Legal-Semantic-Alignment-Framework.md"
$pa="$PatchDir/full/PRC-US-Legal-Semantic-Alignment-Framework.md"
if ((Test-Path $fw) -and (Test-Path $pa)) {
  $uh=(Get-FileHash $fw -Algorithm SHA256).Hash; $ph=(Get-FileHash $pa -Algorithm SHA256).Hash
  if ($uh -ne $ph) { Write-Host "  [Δ] 框架有更新！" -ForegroundColor Yellow }
  else { Write-Host "  [✓] 框架无变化" -ForegroundColor Green; exit }
} else { Write-Host "  [?] 文件缺失" -ForegroundColor Red; exit }

if (-not $Update) { exit }

# Update full original
Copy-Item $fw $pa -Force
Write-Host "  原文件已更新。"

# === Auto-split ===
Write-Host "  自动拆分..."
$lines = Get-Content $fw -Encoding UTF8

# Guards (6 files)
$lines[0..16] -join "`r`n" | Out-File "$PatchDir/guards/meta-rules.md" -Encoding UTF8
$lines[31..262] -join "`r`n" | Out-File "$PatchDir/guards/meta-rules.md" -Encoding UTF8 -Append
$lines[822..884] -join "`r`n" | Out-File "$PatchDir/guards/hk-bridge.md" -Encoding UTF8
$lines[885..932] -join "`r`n" | Out-File "$PatchDir/guards/workflows.md" -Encoding UTF8
$lines[933..961] -join "`r`n" | Out-File "$PatchDir/guards/blocking-list.md" -Encoding UTF8
$lines[962..994] -join "`r`n" | Out-File "$PatchDir/guards/china-unique.md" -Encoding UTF8
$lines[995..1094] -join "`r`n" | Out-File "$PatchDir/guards/appendix.md" -Encoding UTF8
Write-Host "    guards/ 6 文件 ✅"

# Domain alignment (9 domain-specific + 3 general)
$sections = @(
  @{File="commercial-legal.md"; Lines=306..378}
  @{File="litigation-legal.md"; Lines=466..540}
  @{File="employment-legal.md"; Lines=659..681}
  @{File="corporate-legal.md"; Lines=541..575,682..698,811..821}
  @{File="privacy-legal.md"; Lines=594..615}
  @{File="ip-legal.md"; Lines=616..658}
  @{File="product-legal.md"; Lines=379..397,441..465}
  @{File="regulatory-legal.md"; Lines=576..593,699..821}
  @{File="ai-governance-legal.md"; Lines=770..810}
)

$domainMap = @{
  'commercial-legal'  = '商事合同'
  'litigation-legal'  = '诉讼仲裁'
  'employment-legal'  = '劳动用工'
  'corporate-legal'   = '公司与交易'
  'privacy-legal'     = '数据合规'
  'ip-legal'          = '知识产权'
  'product-legal'     = '产品合规'
  'regulatory-legal'  = '监管合规'
  'ai-governance-legal' = 'AI治理'
}

foreach ($s in $sections) {
  $title = $domainMap[$s.File -replace '\.md$','']
  @"
# $title 领域 - 中美法律概念对齐
## 加载范围（自动同步）

---

"@ | Out-File "$PatchDir/references/alignment/$($s.File)" -Encoding UTF8
  $lines[$s.Lines] -join "`r`n" | Out-File "$PatchDir/references/alignment/$($s.File)" -Encoding UTF8 -Append
}

# 3 general domains
$general = @"
# 通用领域 - 中美法律概念对齐
## 说明
法学生学习、法律援助、技能治理中心——加载全局规则即可。
---
"@
foreach ($d in @('law-student','legal-clinic','legal-builder-hub')) {
  $general | Out-File "$PatchDir/references/alignment/$d.md" -Encoding UTF8
}

Write-Host "    references/alignment/ 12 文件 ✅"
Write-Host "快照已更新，已完成自动拆分。" -ForegroundColor Green
