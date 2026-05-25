<#
.SYNOPSIS
  法律断言全量验证引擎 — 四仓提取→联网核验→交互确认→自动更新
.DESCRIPTION
  每月对全部文件中的法律技能/法律观点/法律表述进行联网验证。
  发现与预设不一致时，弹出交互对话框由用户确认后更新。
.EXAMPLE
  .\law-verify.ps1 -AllRepos -Interactive    # 全仓交互验证
  .\law-verify.ps1 -AllRepos -Online         # 联网验证 + 交互确认
  .\law-verify.ps1 -AllRepos -AutoApply      # 自动应用已知修正
  .\law-verify.ps1 -AllRepos -DryRun         # 仅扫描不修改
#>

param(
    [string]$CNRoot = "$PSScriptRoot\..",       # CN 主仓库
    [string]$JDPRoot = "D:\Codex-Legal-CN-Judgment-Predictor",
    [string]$MCPRoot = "$env:TEMP\mcp-hub",
    [string]$ALNRoot = "$env:TEMP\align-framework",
    [string]$OutputDir = "skills\references\verify",
    [switch]$AllRepos,
    [switch]$Interactive,
    [switch]$Online,
    [switch]$AutoApply,
    [switch]$DryRun
)

$ErrorActionPreference = "Continue"
$script:RepoRoot = (Resolve-Path $CNRoot).Path
$script:OutputRoot = Join-Path $script:RepoRoot $OutputDir
if (-not (Test-Path $script:OutputRoot)) { New-Item -ItemType Directory -Path $script:OutputRoot -Force | Out-Null }

# ─── 常量 ──────────────────────────────────────
$script:ISSUE_FILE = Join-Path $script:OutputRoot "law-discrepancies.md"
$script:CONFIRMED_FILE = Join-Path $script:OutputRoot "law-confirmed.json"
$script:REFERENCE_FILE = Join-Path $script:OutputRoot "law-reference-db.json"

$TODAY = Get-Date -Format 'yyyy-MM-dd'
$NOW = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'

# ══════════════════════════════════════════════
# 阶段 1: 全仓文件收集
# ══════════════════════════════════════════════

function Get-AllRepos {
    $repos = @(@{ Name="CN"; Path=$script:RepoRoot })
    if ($AllRepos) {
        if (Test-Path $JDPRoot) { $repos += @{ Name="JDP"; Path=(Resolve-Path $JDPRoot).Path } }
        if (Test-Path $MCPRoot) { $repos += @{ Name="MCP"; Path=(Resolve-Path $MCPRoot).Path } }
        if (Test-Path $ALNRoot) { $repos += @{ Name="ALN"; Path=(Resolve-Path $ALNRoot).Path } }
    }
    return $repos
}

function Get-AllMDfiles($repos) {
    $allFiles = @()
    foreach ($repo in $repos) {
        $files = Get-ChildItem -Recurse -File -Path $repo.Path | Where-Object {
            $_.Extension -eq '.md' -and $_.Directory.Name -ne '.git'
        }
        foreach ($f in $files) {
            $allFiles += [PSCustomObject]@{
                repo = $repo.Name
                abspath = $f.FullName
                relpath = $f.FullName.Replace($repo.Path, '').TrimStart('\').Replace('\', '/')
                content = $null  # lazy load
            }
        }
    }
    return $allFiles
}

# ══════════════════════════════════════════════
# 阶段 2: 法律断言提取
# ══════════════════════════════════════════════

function Extract-Assertions($files) {
    $assertions = @()
    $totalFiles = $files.Count
    $i = 0

    # ─── 正则模式 ───
    $patterns = @(
        # A. 法条引用：《XX法》第X条
        @{ Name="citation"; Regex='《([^》]{2,30})》第([零一二三四五六七八九十百千\d]+)条(?:第([零一二三四五六七八九十\d]+)款)?(?:第[（(]([^）)]+)[）)])?项?' }
        # B. 法律观点陈述：根据/依据/按照 XX法
        @{ Name="viewpoint"; Regex='(?:根据|依据|按照|依照|适用|参照)\s*《?([^\s，。,\.]{2,25}(?:法|条例|规定|解释|办法|意见))》?\s*(?:第[零一二三四五六七八九十百千\d]+条)?\s*(?:[^，。]{5,80}(?:应当|不得|可以|必须|有权|禁止|允许|承担|享有|负有))' }
        # C. 法律原则声明
        @{ Name="principle"; Regex='(?:根据|依据|按照)\s*([^\s，。]{2,30}(?:原则|规则|制度))' }
        # D. 法律技能描述
        @{ Name="skill"; Regex='(?:技能|能力|功能|作用|用途)[：:]\s*([^。\n]{20,200})' }
        # E. 时效性敏感表述（如"现行""最新""202X年修订"）
        @{ Name="timeliness"; Regex='(?:现行|最新|生效|施行|修订|修正|公布|发布)\s*(?:于|日期|时间)?\s*[：:]?\s*(20\d{2}[年/-]\d{1,2}[月/-]\d{1,2}|20\d{2}[年/-]\d{1,2}|20\d{2})' }
        # F. 数字型法律阈值（违约金30%/竞业限制2年/N+1等）
        @{ Name="threshold"; Regex='(?:违约金.*?(?:30%|百分之三十)|竞业限制.*?(?:2年|两年)|N\+\d|2N|经济补偿.*?(?:3倍|三倍)|诉讼时效.*?(?:3年|三年)|除斥期间.*?(?:[123]\s*(?:年|个月)))' }
    )

    foreach ($f in $files) {
        $i++
        if ($i % 50 -eq 0) { Write-Host "  提取中: $i / $totalFiles" -ForegroundColor DarkGray }
        
        $content = Get-Content $f.abspath -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
        if (-not $content) { continue }
        $f.content = $content  # cache for later use

        foreach ($p in $patterns) {
            $matches = [regex]::Matches($content, $p.Regex)
            foreach ($m in $matches) {
                $raw = $m.Value.Substring(0, [Math]::Min(200, $m.Value.Length))
                $before = $content.Substring(0, $m.Index)
                $line = ($before -split "`n").Count
                
                # Build context (surrounding 2 lines)
                $lines = $content -split "`n"
                $ctxStart = [Math]::Max(0, $line - 3)
                $ctxEnd = [Math]::Min($lines.Count - 1, $line + 1)
                $context = ($lines[$ctxStart..$ctxEnd] -join "`n").Trim()

                $assertions += [PSCustomObject]@{
                    repo = $f.repo
                    file = $f.relpath
                    abspath = $f.abspath
                    line = $line
                    type = $p.Name
                    raw = $raw
                    context = $context
                    # Parsed fields
                    law = if ($m.Groups.Count -gt 1) { $m.Groups[1].Value } else { "" }
                    article = if ($m.Groups.Count -gt 2) { $m.Groups[2].Value } else { "" }
                    paragraph = if ($m.Groups.Count -gt 3) { $m.Groups[3].Value } else { "" }
                    item = if ($m.Groups.Count -gt 4) { $m.Groups[4].Value } else { "" }
                    # Status tracking
                    status = "pending"   # pending | verified_ok | discrepancy | confirmed | rejected
                    discrepancy = ""
                    verified_by = ""
                    confirmed_at = ""
                }
            }
        }
    }
    
    return $assertions
}

# ══════════════════════════════════════════════
# 阶段 3: 验证引擎
# ══════════════════════════════════════════════

function Invoke-Verification($assertions, $repos) {
    Write-Host "`n=== 验证引擎 ===" -ForegroundColor Cyan
    $discrepancies = @()
    
    # 3.1 加载已有确认记录
    $confirmed = @{}
    if (Test-Path $script:CONFIRMED_FILE) {
        $confData = Get-Content $script:CONFIRMED_FILE -Raw -Encoding UTF8 | ConvertFrom-Json
        foreach ($c in $confData.confirmed) { $confirmed[$c.hash] = $c }
    }

    # 3.2 加载归一化映射
    $normalize = @{}
    $normPath = Join-Path $script:RepoRoot "skills\references\law-name-normalize.json"
    if (Test-Path $normPath) {
        $nd = Get-Content $normPath -Raw -Encoding UTF8 | ConvertFrom-Json
        foreach ($p in $nd.PSObject.Properties) { if (-not $p.Name.StartsWith('_')) { $normalize[$p.Name] = $p.Value } }
    }

    # 3.3 加载版本映射（已知修订）
    $versionMap = @{}
    $mapPath = Join-Path $script:RepoRoot "skills\references\law-version-map.json"
    if (Test-Path $mapPath) {
        $vm = Get-Content $mapPath -Raw -Encoding UTF8 | ConvertFrom-Json
        foreach ($law in $vm.mappings.PSObject.Properties) {
            if ($law.Name.StartsWith('_')) { continue }
            $versionMap[$law.Name] = @{}
            foreach ($art in $law.Value.PSObject.Properties) {
                if (-not $art.Name.StartsWith('_')) { $versionMap[$law.Name][$art.Name] = $art.Value }
            }
        }
    }

    # 3.4 加载基准参照库
    $reference = @{}
    if (Test-Path $script:REFERENCE_FILE) {
        $refData = Get-Content $script:REFERENCE_FILE -Raw -Encoding UTF8 | ConvertFrom-Json
        $reference = $refData
    }

    # 3.5 逐条核验
    $total = $assertions.Count
    $checked = 0
    $discCount = 0
    
    foreach ($a in $assertions) {
        $checked++
        if ($checked % 100 -eq 0) { Write-Host "  核验中: $checked / $total (已发现 $discCount 处差异)" -ForegroundColor DarkGray }
        
        $hash = [Convert]::ToBase64String([Security.Cryptography.SHA256]::Create().ComputeHash([Text.Encoding]::UTF8.GetBytes($a.raw))).Substring(0, 16)
        
        # 跳过已确认的
        if ($confirmed.ContainsKey($hash)) {
            $a.status = "confirmed"
            $a.confirmed_at = $confirmed[$hash].date
            continue
        }
        
        # ─── 检查1: 法名规范化 ───
        if ($a.type -eq 'citation' -and $a.law -and $normalize.ContainsKey($a.law)) {
            $canonical = $normalize[$a.law]
            if ($a.law -ne $canonical) {
                $a.status = "discrepancy"
                $a.discrepancy = "法名简称应规范化: `"$($a.law)`" → `"$canonical`""
                $canonVal = $a.raw -replace [regex]::Escape($a.law), $canonical; $a.PSObject.Properties.Remove("suggested_fix"); $a | Add-Member -NotePropertyName "suggested_fix" -NotePropertyValue $canonVal -Force
                $discrepancies += $a
                $discCount++
                continue
            }
        }
        
        # ─── 检查2: 版本映射（已知法条号变更） ───
        if ($a.type -eq 'citation' -and $a.law -and $versionMap.ContainsKey($a.law)) {
            $mappings = $versionMap[$a.law]
            if ($mappings.ContainsKey($a.article)) {
                $newArt = $mappings[$a.article]
                $a.status = "discrepancy"
                $a.discrepancy = "法条号已变更: 《$($a.law)》第$($a.article)条 → 第${newArt}条"
                $fixVal = $a.raw -replace "第$($a.article)条", "第${newArt}条"; $a.PSObject.Properties.Remove("suggested_fix"); $a | Add-Member -NotePropertyName "suggested_fix" -NotePropertyValue $fixVal -Force
                $discrepancies += $a
                $discCount++
                continue
            }
        }
        
        # ─── 检查3: 时效性敏感表述 ───
        if ($a.type -eq 'timeliness') {
            # 提取日期并与当前法律状态对比
            $dateMatch = [regex]::Match($a.raw, '20(\d{2})[年/-](\d{1,2})')
            if ($dateMatch.Success) {
                $year = [int]("20" + $dateMatch.Groups[1].Value)
                # 标记超过2年的"现行""最新"表述需人工复核
                if ($year -lt 2024 -and $a.raw -match '(?:现行|最新)') {
                    $a.status = "discrepancy"
                    $a.discrepancy = "时效性存疑: $year 年的表述标注为`"现行/最新`"，建议复核是否有更新版本"
                    $discrepancies += $a
                    $discCount++
                    continue
                }
            }
        }
        
        # ─── 检查4: 基准参照库对比 ───
        if ($a.type -eq 'citation' -and $a.law -and $reference.ContainsKey($a.law)) {
            $refLaw = $reference[$a.law]
            if ($refLaw.PSObject.Properties.Name -contains $a.article) {
                # 有此条文的基准文本，后续可扩展逐字比对
                $a.status = "verified_ok"
                $a.verified_by = "reference_db"
                continue
            }
        }
        
        # ─── 联网验证（仅citations） ───
        if ($Online -and $a.type -eq 'citation' -and $a.law -and $a.article) {
            $result = Invoke-OnlineVerification -LawName $a.law -Article $a.article
            if ($result.status -eq "not_found") {
                $a.status = "discrepancy"
                $a.discrepancy = "联网验证未找到: 《$($a.law)》第$($a.article)条"
                $discrepancies += $a
                $discCount++
                continue
            }
            if ($result.status -eq "mismatch") {
                $a.status = "discrepancy"
                $a.discrepancy = "联网验证不一致: $($result.detail)"
                $discrepancies += $a
                $discCount++
                continue
            }
            $a.status = "verified_ok"
            $a.verified_by = "online"
            continue
        }
        
        # 无差异
        $a.status = "unverified"  # 未发现问题但无自动化手段验证
    }
    
    Write-Host "  核验完成: $checked/$total 条, 差异 $discCount 处" -ForegroundColor Yellow
    return $discrepancies, $assertions
}

# ══════════════════════════════════════════════
# 阶段 3.5: 联网验证（在线模式）
# ══════════════════════════════════════════════

function Invoke-OnlineVerification($LawName, $Article) {
    # 尝试使用 chineselaw-mcp 验证
    # 也尝试直接 HTTP 请求北大法宝 API
    $envKey = $env:CHINESELAW_API_KEY
    if (-not $envKey) { $envKey = $env:PKULAW_ACCESS_TOKEN }
    
    if (-not $envKey) {
        return @{ status="skipped"; detail="无 API Key（设置 CHINESELAW_API_KEY 环境变量启用联网验证）" }
    }
    
    try {
        # 尝试 chineselaw-mcp 的 API
        $body = @{ query = "《${LawName}》第${Article}条"; topK = 1 } | ConvertTo-Json
        $result = Invoke-RestMethod -Uri "https://open.chineselaw.com/api/law/search" `
            -Method Post -Body $body -ContentType "application/json" `
            -Headers @{ "Authorization" = "Bearer $envKey" } `
            -TimeoutSec 10 -ErrorAction Stop
        
        if ($result.data -and $result.data.Count -gt 0) {
            $item = $result.data[0]
            if ($item.title -match $LawName) {
                return @{ status="found"; detail=$item.title }
            }
        }
        return @{ status="not_found"; detail="联网搜索未匹配" }
    }
    catch {
        return @{ status="error"; detail=$_.Exception.Message }
    }
}

# ══════════════════════════════════════════════
# 阶段 4: 交互确认
# ══════════════════════════════════════════════

function Invoke-InteractiveReview($discrepancies) {
    if (-not $discrepancies -or $discrepancies.Count -eq 0) {
        Write-Host "`n无差异，跳过交互确认。" -ForegroundColor Green
        return @()
    }

    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "  交互确认 — $($discrepancies.Count) 处差异待处理" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  操作: [y]确认修改  [n]跳过  [s]全部跳过  [q]退出" -ForegroundColor Yellow
    Write-Host ""

    $confirmed = @()
    $skipAll = $false
    
    foreach ($disc in $discrepancies) {
        if ($skipAll) { break }
        
        # 显示差异
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
        Write-Host "  [$($disc.repo)] $($disc.file):$($disc.line)" -ForegroundColor White
        Write-Host "  类型: $($disc.type)" -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  原文: " -NoNewline
        Write-Host $disc.raw -ForegroundColor Red
        Write-Host ""
        Write-Host "  问题: $($disc.discrepancy)" -ForegroundColor Yellow
        if ($disc.suggested_fix) {
            Write-Host ""
            Write-Host "  建议: " -NoNewline
            Write-Host $disc.suggested_fix -ForegroundColor Green
        }
        Write-Host ""
        Write-Host "  上下文:" -ForegroundColor DarkGray
        Write-Host "  $($disc.context)" -ForegroundColor DarkGray
        Write-Host ""
        
        $choice = Read-Host "  [y/n/s/q]"
        
        switch ($choice.ToLower()) {
            'y' {
                $disc.status = "confirmed"
                $disc.confirmed_at = $TODAY
                $confirmed += $disc
                Write-Host "  ✓ 已确认" -ForegroundColor Green
            }
            's' {
                $skipAll = $true
                Write-Host "  ⏭ 跳过剩余全部" -ForegroundColor Yellow
            }
            'q' {
                Write-Host "  ⏹ 退出" -ForegroundColor Magenta
                break
            }
            default {
                Write-Host "  - 跳过" -ForegroundColor DarkGray
            }
        }
        Write-Host ""
    }
    
    return $confirmed
}

# ══════════════════════════════════════════════
# 阶段 5: 批量更新文件
# ══════════════════════════════════════════════

function Invoke-BatchUpdate($confirmed, $allFiles) {
    if (-not $confirmed -or $confirmed.Count -eq 0) {
        Write-Host "无确认项，跳过更新。" -ForegroundColor Yellow
        return 0
    }

    Write-Host "`n=== 批量更新 ===" -ForegroundColor Cyan
    
    # 按文件分组
    $byFile = $confirmed | Group-Object -Property abspath
    $updated = 0
    
    foreach ($group in $byFile) {
        $absPath = $group.Name
        if (-not (Test-Path $absPath)) {
            Write-Host "  跳过（不存在）: $absPath" -ForegroundColor DarkGray
            continue
        }
        
        $content = Get-Content $absPath -Raw -Encoding UTF8
        $modified = $false
        
        foreach ($disc in $group.Group) {
            if ($disc.suggested_fix -and $disc.raw) {
                # 精确替换
                $escapedOld = [regex]::Escape($disc.raw)
                if ($content -match $escapedOld) {
                    $content = $content -replace $escapedOld, $disc.suggested_fix
                    $modified = $true
                    $updated++
                    Write-Host "  ✓ $($disc.file):$($disc.line)" -ForegroundColor Green
                }
                else {
                    # 模糊匹配：尝试仅替换差异部分
                    Write-Host "  ⚠ 精确匹配失败，尝试模糊替换: $($disc.file):$($disc.line)" -ForegroundColor DarkYellow
                    # 对于法名规范化：替换法名
                    if ($disc.discrepancy -match '法名简称') {
                        $oldName = [regex]::Match($disc.discrepancy, '"([^"]+)"').Groups[1].Value
                        $newName = [regex]::Match($disc.discrepancy, '"([^"]+)"$').Groups[1].Value
                        if ($oldName -and $newName) {
                            $content = $content -replace [regex]::Escape($oldName), $newName
                            $modified = $true
                            $updated++
                        }
                    }
                }
            }
        }
        
        if ($modified) {
            $content | Set-Content $absPath -Encoding UTF8 -NoNewline
            Write-Host "  已保存: $($group.Group[0].file)" -ForegroundColor Cyan
        }
    }
    
    return $updated
}

# ══════════════════════════════════════════════
# 阶段 6: 保存确认记录
# ══════════════════════════════════════════════

function Save-ConfirmationRecord($confirmed) {
    $records = @()
    if (Test-Path $script:CONFIRMED_FILE) {
        $existing = Get-Content $script:CONFIRMED_FILE -Raw -Encoding UTF8 | ConvertFrom-Json
        if ($existing.confirmed) { $records = @($existing.confirmed) }
    }
    
    foreach ($c in $confirmed) {
        $hash = [Convert]::ToBase64String([Security.Cryptography.SHA256]::Create().ComputeHash([Text.Encoding]::UTF8.GetBytes($c.raw))).Substring(0, 16)
        $records += @{
            hash = $hash
            file = $c.file
            line = $c.line
            type = $c.type
            old = $c.raw
            new = $c.suggested_fix
            discrepancy = $c.discrepancy
            date = $c.confirmed_at
        }
    }
    
    @{ updated=$NOW; total=$records.Count; confirmed=$records } | ConvertTo-Json -Depth 4 | Set-Content $script:CONFIRMED_FILE -Encoding UTF8
    Write-Host "确认记录已保存: $script:CONFIRMED_FILE" -ForegroundColor Cyan
}

# ══════════════════════════════════════════════
# 阶段 7: 生成报告
# ══════════════════════════════════════════════

function New-VerificationReport($discrepancies, $allAssertions, $repos, $updated) {
    $byRepo = $allAssertions | Group-Object -Property repo
    $byType = $allAssertions | Group-Object -Property type
    $byStatus = $allAssertions | Group-Object -Property status
    
    $report = @"
# 法律断言全量验证报告

> 运行时间: $NOW
> 仓库: $(($repos | ForEach-Object { $_.Name }) -join ', ')
> 模式: $(if ($Online) { '联网验证' } else { '本地验证' })$(if ($DryRun) { ' (预览)' } elseif ($AutoApply) { ' (自动)' } else { ' (交互)' })

## 总览

| 指标 | 数值 |
|------|------|
| 扫描文件 | $($allAssertions | Select-Object -ExpandProperty file -Unique | Measure-Object | Select-Object -ExpandProperty Count) |
| 提取断言 | $($allAssertions.Count) |
| 差异发现 | $($discrepancies.Count) |
| 已确认修改 | $updated |

## 按仓库分布

| 仓库 | 文件数 | 断言数 | 差异数 |
|------|--------|--------|--------|
"@
    foreach ($r in $byRepo) {
        $discCount = ($discrepancies | Where-Object { $_.repo -eq $r.Name }).Count
        $fileCount = ($allAssertions | Where-Object { $_.repo -eq $r.Name } | Select-Object -ExpandProperty file -Unique).Count
        $report += "| $($r.Name) | $fileCount | $($r.Count) | $discCount |`n"
    }

    $report += @"

## 按类型分布

| 类型 | 数量 | 差异 |
|------|------|------|
"@
    foreach ($t in $byType) {
        $discCount = ($discrepancies | Where-Object { $_.type -eq $t.Name }).Count
        $report += "| $($t.Name) | $($t.Count) | $discCount |`n"
    }

    $report += @"

## 按状态分布

| 状态 | 数量 |
|------|------|
"@
    foreach ($s in $byStatus) {
        $report += "| $($s.Name) | $($s.Count) |`n"
    }

    if ($discrepancies.Count -gt 0) {
        $report += @"

## 差异详情

"@
        $discByRepo = $discrepancies | Group-Object -Property repo
        foreach ($rg in $discByRepo) {
            $report += "### $($rg.Name)`n`n"
            foreach ($d in $rg.Group) {
                $report += "- **$($d.file):$($d.line)** [$($d.type)]`n"
                $report += "  - 原文: ``$($d.raw)```n"
                $report += "  - 问题: $($d.discrepancy)`n"
                if ($d.suggested_fix) { $report += "  - 建议: ``$($d.suggested_fix)```n" }
                if ($d.status -eq 'confirmed') { $report += "  - 状态: ✓ 已确认 ($($d.confirmed_at))`n" }
                $report += "`n"
            }
        }
    }

    $report | Set-Content $script:ISSUE_FILE -Encoding UTF8
    Write-Host "报告已生成: $script:ISSUE_FILE" -ForegroundColor Cyan
    return $report
}

# ══════════════════════════════════════════════
# MAIN
# ══════════════════════════════════════════════

Write-Host "╔══════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  法律断言全量验证引擎 v1.0               ║" -ForegroundColor Cyan
Write-Host "║  四仓库提取 → 核验 → 交互确认 → 更新    ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

$repos = Get-AllRepos
Write-Host "仓库: $(($repos | ForEach-Object { "$($_.Name)($(Split-Path $_.Path -Leaf))" }) -join ' | ')" -ForegroundColor Yellow
Write-Host "模式: $(if ($Online) { '联网验证' } else { '本地验证' })$(if ($DryRun) { ' (预览)' } elseif ($AutoApply) { ' (自动)' } else { ' (交互)' })" -ForegroundColor Yellow
Write-Host ""

# [1/5] 收集文件
Write-Host "[1/5] 收集全仓 .md 文件..." -ForegroundColor Cyan
$allFiles = Get-AllMDfiles $repos
Write-Host "  共 $($allFiles.Count) 个文件" -ForegroundColor Green

# [2/5] 提取断言
Write-Host "`n[2/5] 提取法律断言..." -ForegroundColor Cyan
$assertions = Extract-Assertions $allFiles
Write-Host "  提取 $($assertions.Count) 条断言"
$byType = $assertions | Group-Object -Property type | ForEach-Object { "$($_.Name):$($_.Count)" }
Write-Host "  分布: $($byType -join ', ')" -ForegroundColor DarkGray

# [3/5] 核验
Write-Host "`n[3/5] 核验断言..."
$discrepancies, $assertions = Invoke-Verification $assertions $repos

# [4/5] 交互确认 / 自动应用
$confirmed = @()
if ($AutoApply) {
    Write-Host "`n[4/5] 自动应用已知修正..." -ForegroundColor Cyan
    $confirmed = $discrepancies | Where-Object { $_.suggested_fix }
    foreach ($c in $confirmed) { $c.status = "confirmed"; $c.confirmed_at = $TODAY }
}
elseif ($Interactive) {
    Write-Host "`n[4/5] 交互确认..."
    $confirmed = Invoke-InteractiveReview $discrepancies
}
elseif ($DryRun) {
    Write-Host "`n[4/5] 预览模式 — 跳过确认" -ForegroundColor Magenta
}

# [5/5] 更新文件
if (-not $DryRun -and $confirmed.Count -gt 0) {
    Write-Host "`n[5/5] 应用更新..."
    $updated = Invoke-BatchUpdate $confirmed $allFiles
    Save-ConfirmationRecord $confirmed
    Write-Host "  更新 $updated 处" -ForegroundColor Green
}
else {
    $updated = 0
    Write-Host "`n[5/5] 跳过更新" -ForegroundColor DarkGray
}

# 生成报告
New-VerificationReport $discrepancies $assertions $repos $updated

# 摘要
Write-Host "`n====== 验证摘要 ======" -ForegroundColor Cyan
Write-Host "  扫描: $($allFiles.Count) 文件 → $($assertions.Count) 断言"
Write-Host "  差异: $($discrepancies.Count) 处"
Write-Host "  更新: $updated 处"
Write-Host "  报告: $script:ISSUE_FILE" -ForegroundColor Yellow
Write-Host "  确认: $script:CONFIRMED_FILE" -ForegroundColor Yellow
