param([switch]$Update, [switch]$Diff)

$ErrorActionPreference='Stop'
$RepoRoot=Split-Path -Parent $PSScriptRoot
$UpstreamUrl='https://github.com/saysoph/solo-law-firm-agents.git'
$UpstreamDir="$env:TEMP\solo-check"

# 科室映射（中文→英文）
$deptMap = @{
    '01-案件实务部' = '01-case-practice'
    '02-案件管理部' = '02-case-management'
    '03-客户关系部' = '03-client-relations'
    '04-尽职调查部' = '04-due-diligence'
    '05-市场拓展部' = '05-business-development'
    '06-财务行政部' = '06-finance-admin'
    '07-知识管理部' = '07-knowledge-management'
    '08-合规风险部' = '08-risk-compliance'
}

# 技能名映射（中文→英文）
$skillMap = @{
    '合同审查师' = 'contract-reviewer'
    '法律文书撰写师' = 'legal-document-drafter'
    '法律检索专家' = 'legal-research-expert'
    '证据分析师' = 'evidence-analyst'
    '诉讼策略师' = 'litigation-strategist'
    '庭审准备清单员' = 'trial-preparation-checker'
    '时效监控员' = 'deadline-monitor'
    '案件排期管家' = 'case-scheduler'
    '证据材料管理员' = ''  # 已合并
    '初次咨询接待' = 'initial-consultation'
    '客户沟通起草' = 'client-communication-drafter'
    '案件进展通报' = ''  # 已合并
    '满意度回访' = 'satisfaction-surveyor'
    '企业背调探员' = 'corporate-background-investigator'
    '股权穿透分析' = 'equity-penetration-analyst'
    '诉讼风险排查' = 'litigation-risk-scanner'
    '资产线索追踪' = 'asset-trace-investigator'
    'SEO优化师' = 'seo-optimizer'
    '公众号创作者' = 'wechat-article-creator'
    '小红书知乎科普' = 'social-media-legal-popularizer'
    '短视频策划' = 'short-video-planner'
    '利冲检索器' = 'conflict-checker'
    '利润核算师' = 'profit-accountant'
    '发票与催收' = 'invoice-collection-specialist'
    '收费策略顾问' = 'fee-strategy-consultant'
    '案例与模板重塑' = 'case-template-refiner'
    '法官偏好解析' = 'judge-preference-analyst'
    '法规动态监控' = 'regulatory-change-monitor'
}

Write-Host "=== saysoph/solo-law-firm-agents 上游检查 ===" -ForegroundColor Cyan

# 拉取上游
if (Test-Path "$UpstreamDir\.git") { Push-Location $UpstreamDir; git pull --ff-only 2>&1 | Out-Null; Pop-Location }
else { Push-Location $env:TEMP; $p=Start-Process -NoNewWindow -FilePath "git" -ArgumentList "clone --depth 1 $UpstreamUrl solo-check" -Wait -RedirectStandardError "$env:TEMP\git-err.log"; Pop-Location }
Push-Location $UpstreamDir; $c=git log -1 --format='%h'; $d=git log -1 --format='%ci'; Pop-Location
Write-Host "  $c $d"

$localSolo = "$RepoRoot\skills\solo-law-firm"
$changed=0; $ok=0; $newUp=0; $newLocal=0; $skipped=0

# 遍历上游每个技能
Write-Host "`n--- 技能比对 ---" -ForegroundColor Cyan
foreach ($cnDept in $deptMap.Keys | Sort-Object) {
    $enDept = $deptMap[$cnDept]
    # $upDeptDir = "$UpstreamDir\$cnDept" # 在 agents/ 子目录
    if (-not (Test-Path "$UpstreamDir\agents\$cnDept")) { continue }
    
    Get-ChildItem "$UpstreamDir\agents\$cnDept" -Directory -ErrorAction SilentlyContinue | ForEach-Object {
        $cnName = $_.Name
        $enName = if ($skillMap.ContainsKey($cnName)) { $skillMap[$cnName] } else { $cnName }
        
        if ($enName -eq '') { $skipped++; return }  # 已合并跳过
        
        $upSkill = "$($_.FullName)\SKILL.md"
        $localSkill = "$localSolo\$enDept\$enName\SKILL.md"
        
        if ((Test-Path $upSkill) -and (Test-Path $localSkill)) {
            $uh=(Get-FileHash $upSkill -Algorithm SHA256).Hash
            $lh=(Get-FileHash $localSkill -Algorithm SHA256).Hash
            if ($uh -ne $lh) {
                Write-Host "  [Δ] $enDept/$enName" -ForegroundColor Yellow
                $changed++
                if ($Diff) {
                    $diffLines = & git diff --no-index "$localSkill" "$upSkill" 2>&1
                    $diffLines | ForEach-Object { Write-Host "    $_" -ForegroundColor DarkGray }
                }
            } else { $ok++ }
        } elseif (Test-Path $upSkill) {
            Write-Host "  [+] $enDept/$enName — 上游新增" -ForegroundColor Magenta
            $newUp++
        }
    }
}

# 本地独有（上游没有的）
Write-Host "`n--- 本地独有 ---" -ForegroundColor Cyan
for ($d=1; $d -le 8; $d++) {
    $enDept = "{0:D2}-$(@('case-practice','case-management','client-relations','due-diligence','business-development','finance-admin','knowledge-management','risk-compliance')[$d-1])"
    $localDeptDir = "$localSolo\$enDept"
    if (-not (Test-Path $localDeptDir)) { continue }
    Get-ChildItem $localDeptDir -Directory -ErrorAction SilentlyContinue | ForEach-Object {
        $enName = $_.Name
        # 反向找中文名
        $cnName = $skillMap.GetEnumerator() | Where-Object { $_.Value -eq $enName } | ForEach-Object { $_.Key }
        # 检查上游有没有
        $cnDept = $deptMap.GetEnumerator() | Where-Object { $_.Value -eq $enDept } | ForEach-Object { $_.Key }
        $upExists = $cnDept -and (Test-Path "$UpstreamDir\$cnDept\$cnName") -or $cnDept -and (Test-Path "$UpstreamDir\$cnDept\$enName")
        if (-not $upExists) {
            Write-Host "  [本地独有] $enDept/$enName" -ForegroundColor Cyan
            $newLocal++
        }
    }
}

# 汇总
Write-Host "`n$ok 未变, $changed 已变更, $newUp 上游新增, $newLocal 本地独有, $skipped 已合并跳过"
if ($changed -eq 0 -and $newUp -eq 0) { Write-Host "上游无更新。" -ForegroundColor Green }

# -Update：将上游新技能复制到本地（标记为待审查）
if ($Update) {
    Write-Host "`n--- 更新说明 ---" -ForegroundColor Cyan
    Write-Host "solo-law-firm 已断开上游，-Update 仅检查不更新文件。"
    Write-Host "如需手动合并，请查看 [Δ] 标记的技能后自行决定。"
}

Remove-Item -Recurse -Force $UpstreamDir -ErrorAction SilentlyContinue




