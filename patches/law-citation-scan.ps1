<#
.SYNOPSIS
  法条引用全量扫描器 — 扫描仓库中所有文件的法条引用，构建引用索引
#>

param(
    [string]$RepoRoot = $PSScriptRoot,
    [string]$OutputFile = ""
)

$RepoRoot = (Resolve-Path $RepoRoot).Path
if (-not $OutputFile) { $OutputFile = "skills\references\law-citation-index.json" }
if ([System.IO.Path]::IsPathRooted($OutputFile)) {
    $OutPath = $OutputFile
} else {
    $OutPath = Join-Path $RepoRoot $OutputFile

# ─── 法名归一化 ──────────────────────────────────────
$NormPath = Join-Path $RepoRoot "skills\references\law-name-normalize.json"
$normalize = @{}
if (Test-Path $NormPath) {
    $normData = Get-Content $NormPath -Raw -Encoding UTF8 | ConvertFrom-Json
    foreach ($prop in $normData.PSObject.Properties) {
        if (-not $prop.Name.StartsWith('_')) { $normalize[$prop.Name] = $prop.Value }
    }
}
}

Write-Host "=== 法条引用全量扫描 ===" -ForegroundColor Cyan
Write-Host "扫描路径: $RepoRoot"

$patterns = @(
    @{ Regex = '《([^》]{2,30})》第([零一二三四五六七八九十百千\d]+)条(?:第([零一二三四五六七八九十\d]+)款)?(?:第[（(]([^）)]+)[）)])?项?'; Type = 'article' }
    @{ Regex = '(?:根据|依据|按照|适用|依照)\s*([^\s，。,\.]{2,20}(?:法|条例|规定|解释|办法|通知|意见|公告|决定|命令))\s*第([零一二三四五六七八九十百千\d]+)条'; Type = 'article_ref' }
    @{ Regex = '(最高人民法院关于[^第]{2,50})'; Type = 'interpretation' }
)

$index = @{
    generated = (Get-Date -Format 'yyyy-MM-ddTHH:mm:ss')
    repo_root = $RepoRoot
    total_citations = 0
    by_law = @{}
    by_file = @{}
    citations = @()
}

$files = Get-ChildItem -Recurse -File -Path $RepoRoot | Where-Object {
    $_.Extension -in @('.md','.yaml','.yml','.json','.ps1') -and
    $_.Directory.Name -ne '.git' -and
    $_.Name -notin @('law-citation-index.json','law-versions.json')
}

$totalCitations = 0

foreach ($f in $files) {
    $relPath = $f.FullName.Replace($RepoRoot, '').TrimStart('\').Replace('\', '/')
    $content = Get-Content $f.FullName -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
    if (-not $content) { continue }

    $fileCitations = @()

    foreach ($p in $patterns) {
        $ms = [regex]::Matches($content, $p.Regex)
        foreach ($m in $ms) {
            $lawName = $m.Groups[1].Value.Trim()
            if ($normalize.ContainsKey($lawName)) { $lawName = $normalize[$lawName] }
            $article = $m.Groups[2].Value
            $paragraph = if ($m.Groups.Count -gt 3) { $m.Groups[3].Value } else { '' }
            $item = if ($m.Groups.Count -gt 4) { $m.Groups[4].Value } else { '' }

            $canon = "《${lawName}》第${article}条"
            if ($paragraph) { $canon += "第${paragraph}款" }
            if ($item) { $canon += "第（${item}）项" }

            $beforeMatch = $content.Substring(0, $m.Index)
            $lineNum = ($beforeMatch -split "`n").Count

            $cit = [PSCustomObject]@{
                file = $relPath
                line = $lineNum
                law = $lawName
                article = $article
                paragraph = $paragraph
                item = $item
                canonical = $canon
                type = $p.Type
                raw = $m.Value.Substring(0, [Math]::Min(80, $m.Value.Length))
            }

            $fileCitations += $cit
            $totalCitations++
        }
    }

    if ($fileCitations.Count -gt 0) {
        $index.by_file[$relPath] = $fileCitations.Count
        $index.citations += $fileCitations
    }
}

# Group by law
$index.citations | Group-Object -Property law | ForEach-Object {
    $index.by_law[$_.Name] = @{
        count = $_.Count
        articles = ($_.Group | Select-Object -ExpandProperty article -Unique | Sort-Object)
    }
}

$index.total_citations = $totalCitations
$index | ConvertTo-Json -Depth 4 | Set-Content $OutPath -Encoding UTF8

Write-Host "扫描完成！" -ForegroundColor Green
Write-Host "  文件数: $($files.Count)"
Write-Host "  含引用的文件: $($index.by_file.Count)"
Write-Host "  总引用数: $totalCitations"
Write-Host "  涉及法律: $($index.by_law.Count) 部"
Write-Host "  索引文件: $OutPath" -ForegroundColor Cyan
