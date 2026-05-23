<#
.SYNOPSIS
  手动更新 Codex 中国法律技能包
.DESCRIPTION
  从上游拉取最新内容，同步技能和 MCP 连接器配置到 ~/.codex/skills/。
  如安装了 @pkulaw/mcp-cli，自动验证北大法宝 MCP 服务状态。
#>

$ErrorActionPreference = 'Stop'
$SkillsDir = "$env:USERPROFILE\.codex\skills"
$UpstreamDir = "$env:USERPROFILE\.codex\vendor\claude-for-legal-CN"
$ConfigPath = "$env:USERPROFILE\.codex\config.toml"

$domains = @(
    'commercial-legal','privacy-legal','product-legal','corporate-legal',
    'employment-legal','regulatory-legal','ai-governance-legal','litigation-legal',
    'law-student','legal-clinic','legal-builder-hub','ip-legal'
)

Write-Host '=== 更新 Codex 中国法律技能 ===' -ForegroundColor Green

if (-not (Test-Path "$UpstreamDir\.git")) {
    Write-Host '[错误] 上游内容不存在。请先运行 install.ps1。' -ForegroundColor Red
    exit 1
}

# 更新上游
Push-Location $UpstreamDir
$result = git pull 2>&1
Pop-Location
Write-Host "  [上游] $($result -join '')"

# 同步技能
$count = 0
foreach ($name in $domains) {
    $src = "$UpstreamDir\$name"
    $tgt = "$SkillsDir\$name"
    if (-not (Test-Path $src)) { continue }
    if (-not (Test-Path $tgt)) { $null = New-Item -ItemType Directory -Force $tgt }
    Copy-Item "$src\CLAUDE.md" "$tgt\CLAUDE.md" -Force -ErrorAction SilentlyContinue
    Copy-Item "$src\README.md" "$tgt\README.md" -Force -ErrorAction SilentlyContinue
    if (Test-Path "$src\.mcp.json") { Copy-Item "$src\.mcp.json" "$tgt\.mcp.json" -Force -ErrorAction SilentlyContinue }
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
    $count++
}
Write-Host "  已更新 $count 个技能领域"

# 检查 MCP 配置状态
Write-Host ''
Write-Host '检查 MCP 连接器状态...' -ForegroundColor Yellow
if (Test-Path $ConfigPath) {
    $config = Get-Content $ConfigPath -Encoding UTF8 -Raw
    $checks = @{
        'chineselaw'           = 'mcp_servers.chineselaw'
        'pkulaw-law-search'    = 'mcp_servers.pkulaw-law-search'
        'pkulaw-case-keyword'  = 'mcp_servers.pkulaw-case-keyword'
    }
    $allOk = $true
    foreach ($name in $checks.Keys) {
        if ($config -match "(?ms)^\[$($checks[$name])\]") {
            if ($config -match "(?ms)^\[$($checks[$name])\].*?enabled\s*=\s*true") {
                Write-Host "  [OK] $name (config.toml)" -ForegroundColor Green
            } else {
                Write-Host "  [!]  $name (已配置但未启用)" -ForegroundColor Yellow
                $allOk = $false
            }
        } else {
            Write-Host "  [!!] $name (未配置)" -ForegroundColor Red
            $allOk = $false
        }
    }

    # 检测 @pkulaw/mcp-cli 并自动验证
    Write-Host ''
    $pkulawCli = Get-Command 'pkulaw-mcp' -ErrorAction SilentlyContinue
    if ($pkulawCli) {
        Write-Host '检测到 @pkulaw/mcp-cli，正在验证北大法宝服务状态...' -ForegroundColor Yellow
        try {
            $timeoutSec = 15
            $job = Start-Job -ScriptBlock { param($p) & $p update 2>&1 | Out-String }
            $job | Wait-Job -Timeout $timeoutSec | Out-Null
            if ($job.State -eq 'Completed') {
                $output = Receive-Job $job
                if ($output -match 'update completed|success|OK|成功') {
                    Write-Host "  [OK] 北大法宝 CLI 验证通过" -ForegroundColor Green
                } else {
                    Write-Host "  [!]  北大法宝 CLI 返回异常：" -ForegroundColor Yellow
                    $output.Trim() -split "`n" | ForEach-Object { Write-Host "    $_" }
                }
            } else {
                Stop-Job $job
                Write-Host "  [!]  北大法宝 CLI 超时（${timeoutSec}s），跳过" -ForegroundColor Yellow
            }
            Remove-Job $job -ErrorAction SilentlyContinue
        } catch {
            Write-Host "  [!]  北大法宝 CLI 验证出错: $_" -ForegroundColor Yellow
        }
    } else {
        Write-Host '未检测到 @pkulaw/mcp-cli（可选，用于调试验证）' -ForegroundColor DarkGray
        Write-Host '  安装: npm install -g @pkulaw/mcp-cli' -ForegroundColor DarkGray
    }
} else {
    Write-Host '  [!!] config.toml 不存在，请重新运行 install.ps1' -ForegroundColor Red
}

Write-Host ''
Write-Host '更新完成。重启 Codex Desktop 使新内容生效。' -ForegroundColor Green