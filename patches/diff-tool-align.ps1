param([switch]$Update)
$ErrorActionPreference='Stop'
$RepoRoot=Split-Path -Parent $PSScriptRoot
$UpstreamDir="$env:TEMP\align-check"
Write-Host "=== 法律对齐框架 检查 ===" -ForegroundColor Cyan
$up="$RepoRoot/../PRC-US-Legal-Semantic-Alignment-Framework/PRC-US-Legal-Semantic-Alignment-Framework.md"
$pa="$RepoRoot/patches/full/PRC-US-Legal-Semantic-Alignment-Framework.md"
if ((Test-Path $up) -and (Test-Path $pa)) {
  $uh=(Get-FileHash $up -Algorithm SHA256).Hash; $ph=(Get-FileHash $pa -Algorithm SHA256).Hash
  if ($uh -ne $ph) { Write-Host "  [Δ] 框架有更新！" -ForegroundColor Yellow }
  else { Write-Host "  [✓] 框架无变化" -ForegroundColor Green; exit }
} else { Write-Host "  [?] 文件缺失" -ForegroundColor Red }
if ($Update) {
  Copy-Item $up $pa -Force
  Write-Host "  原文件已更新。domain 拆分文件需人工同步。" -ForegroundColor Yellow
}
