<#
.SYNOPSIS
  中国法适配对抗测试运行器
.DESCRIPTION
  读取 benchmark/adversarial-tests.md 中的对抗测试用例，逐条输出测试提示。
  支持手动模式和全量自动模式。

.PARAMETER All
  全量模式：一次性输出所有测试用例，带编号
.PARAMETER Interactive
  交互模式：逐条显示，按回车继续（默认）
#>

param(
    [switch]$All,
    [switch]$Interactive
)

$testFile = Join-Path $PSScriptRoot 'adversarial-tests.md'
if (-not (Test-Path $testFile)) {
    Write-Host "[!!] 找不到测试用例文件: $testFile" -ForegroundColor Red
    exit 1
}

Write-Host '========================================' -ForegroundColor Cyan
Write-Host '  中国法适配对抗测试集' -ForegroundColor Cyan
Write-Host '========================================' -ForegroundColor Cyan
Write-Host ''

# 从 Markdown 表格中提取测试用例
$content = Get-Content $testFile -Encoding UTF8 -Raw

# 简单解析：提取 | 数字 | "查询" | "预期" | "概念" | "程度" | 格式的行
$tests = @()
$inTable = $false
foreach ($line in Get-Content $testFile -Encoding UTF8) {
    if ($line -match '^\| \d+ \|') {
        $parts = $line.Split('|').Trim()
        if ($parts.Length -ge 6) {
            $tests += [PSCustomObject]@{
                Id = $parts[1]
                Query = $parts[2]
                Expected = $parts[3]
                Concept = $parts[4]
                Severity = $parts[5]
                Pass = $null
            }
        }
    }
}

Write-Host "共加载 $($tests.Count) 个对抗测试用例" -ForegroundColor Yellow
Write-Host ''

if ($All) {
    # 全量模式：列出所有用例
    Write-Host '--- 全量用例清单 ---' -ForegroundColor Cyan
    foreach ($t in $tests) {
        $sevColor = if ($t.Severity -match '高') { 'Red' } elseif ($t.Severity -match '中') { 'Yellow' } else { 'Green' }
        Write-Host "[#$($t.Id)] $($t.Query)" -ForegroundColor $sevColor
        Write-Host "      预期: $($t.Expected)"
        Write-Host "      概念: $($t.Concept)"
        Write-Host ''
    }
    Write-Host '--- 用例结束 ---' -ForegroundColor Cyan
    Write-Host ''
    Write-Host '在 Codex Desktop 中逐条输入以上查询进行测试。'
    Write-Host '通过后标记为 PASS，失败标记为 FAIL。'
} else {
    # 默认交互模式
    Write-Host '交互模式：逐条显示测试用例。按 Enter 查看下一条。' -ForegroundColor Yellow
    Write-Host '在 Codex Desktop 中输入查询，观察护栏是否触发。' -ForegroundColor Yellow
    Write-Host ''
    
    $passed = 0
    $failed = 0
    foreach ($t in $tests) {
        $sevColor = if ($t.Severity -match '高') { 'Red' } elseif ($t.Severity -match '中') { 'Yellow' } else { 'Green' }
        
        Write-Host "========== 测试 #$($t.Id) ==========" -ForegroundColor Cyan
        Write-Host "查询:     " -NoNewline; Write-Host $t.Query -ForegroundColor $sevColor
        Write-Host "预期行为: $($t.Expected)" -ForegroundColor Green
        Write-Host "阻断概念: $($t.Concept)"
        Write-Host "严重程度: $($t.Severity)" -ForegroundColor $sevColor
        Write-Host ''
        Write-Host '请在 Codex Desktop 中输入上述查询，然后回来报告结果。' -ForegroundColor Yellow
        Write-Host ''
        
        $result = Read-Host -Prompt '测试通过？(y=通过 / n=失败 / s=跳过)'
        switch ($result.ToLower()) {
            'y' { $t.Pass = $true; $passed++ }
            'n' { $t.Pass = $false; $failed++ }
            default { $t.Pass = $null }
        }
        Write-Host ''
    }
    
    # 汇总
    Write-Host '========================================' -ForegroundColor Cyan
    Write-Host '  测试完成' -ForegroundColor Cyan
    Write-Host '========================================' -ForegroundColor Cyan
    Write-Host "通过: $passed / 失败: $failed / 跳过: $($tests.Count - $passed - $failed)"
    if ($failed -gt 0) {
        Write-Host "存在未通过的测试用例，建议修复护栏层。" -ForegroundColor Red
        exit 1
    } elseif ($passed -eq $tests.Count) {
        Write-Host "全部通过！护栏层运作正常。" -ForegroundColor Green
    }
}

# 将测试结果写回 adversarial-tests.md
$newContent = @()
$inTable = $false
foreach ($line in Get-Content $testFile -Encoding UTF8) {
    if ($line -match '^\| \d+ \|') {
        $parts = $line.Split('|').Trim()
        $id = $parts[1]
        $test = $tests | Where-Object { $_.Id -eq $id }
        if ($test -and $test.Pass -ne $null) {
            $status = if ($test.Pass) { '✅ 通过' } else { '❌ 失败' }
            $line = $line -replace '\| \| \|$', "| $status | |"
        }
        $newContent += $line
    } else {
        $newContent += $line
    }
}
Set-Content -Path $testFile -Value $newContent -Encoding UTF8
