<#
.SYNOPSIS
  法条引用批量更新器 — 法律修订后自动更新仓库中所有法条引用
.DESCRIPTION
  读取 law-citation-index.json + law-version-map.json
  批量替换受影响文件中的法条引用，生成变更报告
.EXAMPLE
  .\law-citation-update.ps1 -DryRun   # 预览变更
  .\law-citation-update.ps1           # 执行更新
#>

param(
    [string]$RepoRoot = $PSScriptRoot,
    [string]$IndexFile = "skills\references\law-citation-index.json",
    [string]$MapFile = "skills\references\law-version-map.json",
    [string]$ReportFile = "skills\references\law-update-report.md",
    [switch]$DryRun
)

$RepoRoot = (Resolve-Path $RepoRoot).Path
$IndexPath = if ([IO.Path]::IsPathRooted($IndexFile)) { $IndexFile } else { Join-Path $RepoRoot $IndexFile }
$MapPath = if ([IO.Path]::IsPathRooted($MapFile)) { $MapFile } else { Join-Path $RepoRoot $MapFile }
$ReportPath = if ([IO.Path]::IsPathRooted($ReportFile)) { $ReportFile } else { Join-Path $RepoRoot $ReportFile }

# ─── 1. 检查前置文件 ───
if (-not (Test-Path $IndexPath)) {
    Write-Host "错误: 索引文件不存在，请先运行 law-citation-scan.ps1" -ForegroundColor Red; exit 1
}
if (-not (Test-Path $MapPath)) {
    Write-Host "信息: 映射文件不存在，创建空白模板 $MapPath" -ForegroundColor Yellow
    @"
{
  "_comment": "法条版本映射表。当法律修订致条号变化时，在此填入新旧条号对照。",
  "_example": {
    "中华人民共和国公司法": {
      "_effective": "2024-07-01",
      "_note": "2024新公司法条号变更",
      "16": "15",
      "旧条号": "新条号"
    }
  },
  "mappings": {}
}
"@.Trim() | Set-Content $MapPath -Encoding UTF8
}

# ─── 2. 加载数据 ───
Write-Host "=== 法条引用批量更新器 ===" -ForegroundColor Cyan
$index = Get-Content $IndexPath -Raw -Encoding UTF8 | ConvertFrom-Json
$mapData = Get-Content $MapPath -Raw -Encoding UTF8 | ConvertFrom-Json
$mappings = $mapData.mappings

if (-not $mappings -or $mappings.PSObject.Properties.Count -eq 0) {
    Write-Host "映射表为空，无需更新。请在 $MapPath 中填入映射规则。" -ForegroundColor Yellow
    exit 0
}

# ─── 3. 分析受影响文件 ───
$changes = @()
$filesToUpdate = @{}
$totalReplacements = 0

foreach ($law in $mappings.PSObject.Properties) {
    $lawName = $law.Name
    $lawMappings = $law.Value
    
    # Find all citations to this law
    $lawCitations = $index.citations | Where-Object { $_.law -eq $lawName }
    
    foreach ($oldArt in $lawMappings.PSObject.Properties) {
        if ($oldArt.Name.StartsWith('_')) { continue }  # skip meta keys
        
        $newArt = $oldArt.Value
        $affected = $lawCitations | Where-Object { $_.article -eq $oldArt.Name }
        
        foreach ($cit in $affected) {
            $file = $cit.file
            if (-not $filesToUpdate.ContainsKey($file)) { $filesToUpdate[$file] = @() }
            
            $change = @{
                file = $file
                line = $cit.line
                old_ref = $cit.canonical
                new_ref = $cit.canonical -replace "第$($oldArt.Name)条", "第${newArt}条"
                law = $lawName
                old_article = $oldArt.Name
                new_article = $newArt
            }
            $filesToUpdate[$file] += $change
            $changes += $change
            $totalReplacements++
        }
    }
}

Write-Host "分析完成：$($filesToUpdate.Count) 个文件，$totalReplacements 处引用需更新" -ForegroundColor Yellow

if ($totalReplacements -eq 0) {
    Write-Host "无需更新。" -ForegroundColor Green; exit 0
}

# ─── 4. 预览或执行 ───
if ($DryRun) {
    Write-Host "`n=== [DRY RUN] 预览变更 ===" -ForegroundColor Magenta
    foreach ($ch in $changes) {
        Write-Host "  $($ch.file):$($ch.line)" -ForegroundColor DarkGray
        Write-Host "    - $($ch.old_ref)"
        Write-Host "    + $($ch.new_ref)" -ForegroundColor Green
    }
    Write-Host "`n共 $totalReplacements 处变更。去掉 -DryRun 执行。" -ForegroundColor Yellow
}
else {
    Write-Host "`n=== 执行更新 ===" -ForegroundColor Cyan
    
    # Group changes by file
    foreach ($fileEntry in $filesToUpdate.GetEnumerator()) {
        $relPath = $fileEntry.Key
        $absPath = Join-Path $RepoRoot $relPath
        
        if (-not (Test-Path $absPath)) {
            Write-Host "  跳过（文件不存在）: $relPath" -ForegroundColor DarkGray
            continue
        }
        
        $content = Get-Content $absPath -Raw -Encoding UTF8
        $fileModified = $false
        
        foreach ($ch in $fileEntry.Value) {
            # Replace exact citation in file
            $oldCanonical = $ch.old_ref
            $newCanonical = $ch.new_ref
            
            if ($content -match [regex]::Escape($oldCanonical)) {
                $content = $content -replace [regex]::Escape($oldCanonical), $newCanonical
                $fileModified = $true
            }
            else {
                # Try fuzzy match: "第X条" → "第Y条" within same law context
                $pattern = "(《" + [regex]::Escape($ch.law) + "》第)" + [regex]::Escape($ch.old_article) + "(条)"
                if ($content -match $pattern) {
                    $content = $content -replace $pattern, ('$1' + $ch.new_article + '$2')
                    $fileModified = $true
                }
                else {
                    Write-Host "  未匹配: $relPath — $oldCanonical" -ForegroundColor DarkYellow
                }
            }
        }
        
        if ($fileModified) {
            Set-Content $absPath -Value $content -Encoding UTF8 -NoNewline
            Write-Host "  已更新: $relPath" -ForegroundColor Green
        }
    }
    
    # ─── 5. 重新扫描 ───
    Write-Host "`n重新扫描，更新索引..." -ForegroundColor Cyan
    & "(Join-Path $RepoRoot "patches/law-citation-scan.ps1")" -RepoRoot $RepoRoot | Out-Null
    Write-Host "索引已更新。" -ForegroundColor Green
}

# ─── 6. 生成报告 ───
$reportContent = @"
# 法条引用批量更新报告

> 生成时间：$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
> 更新前索引：$IndexPath
> 映射来源：$MapPath
> 模式：$(if ($DryRun) { '预览 (Dry Run)' } else { '已执行' })

## 变更汇总

| 法律 | 旧条号 → 新条号 | 影响文件数 | 引用数 |
|------|----------------|------------|--------|
"@

foreach ($law in $mappings.PSObject.Properties) {
    foreach ($art in $law.Value.PSObject.Properties) {
        if ($art.Name.StartsWith('_')) { continue }
        $affectedFiles = ($changes | Where-Object { $_.law -eq $law.Name -and $_.old_article -eq $art.Name } | Select-Object -ExpandProperty file -Unique).Count
        $affectedCount = ($changes | Where-Object { $_.law -eq $law.Name -and $_.old_article -eq $art.Name }).Count
        $reportContent += "| $($law.Name) | $($art.Name) → $($art.Value) | $affectedFiles | $affectedCount |`n"
    }
}

$reportContent += @"

## 详情

"@

foreach ($ch in $changes) {
    $reportContent += "- ``$($ch.file)`` L$($ch.line): ``$($ch.old_ref)`` → ``$($ch.new_ref)```n"
}

$reportContent | Set-Content $ReportPath -Encoding UTF8
Write-Host "报告已生成: $ReportPath" -ForegroundColor Cyan

if (-not $DryRun) {
    Write-Host "`n更新完成！共 $totalReplacements 处引用已更新。" -ForegroundColor Green
    Write-Host "请运行 git diff 手动审核变更后提交。" -ForegroundColor Yellow
}
