<#
.SYNOPSIS
  验证 Claude for Legal CN to Codex 的安装状态、护栏效果、文件完整性与 MCP 可达性
.DESCRIPTION
  默认：检查技能目录 + 护栏层 + 文件哈希 + MCP 连接器
  -Benchmark：加载对抗测试用例
  -Quick：仅快速检查技能根目录
.PARAMETER Benchmark
  运行中国法适配对抗测试
.PARAMETER Quick
  快速检查（仅技能根目录）
#>

param(
    [switch]$Benchmark,
    [switch]$Quick,
    [switch]$NoHash,
    [switch]$NoMcp
)

#Requires -Version 5.1

$SkillsDir = "$env:USERPROFILE\.codex\skills"
$RepoRoot = $PSScriptRoot

# ============================================================
# BENCHMARK 模式
# ============================================================
if ($Benchmark) {
    $benchScript = Join-Path $RepoRoot 'benchmark\run-benchmark.ps1'
    if (Test-Path $benchScript) {
        & $benchScript
        return
    } else {
        Write-Host "[!!] 找不到 benchmark 脚本" -ForegroundColor Red
        exit 1
    }
}

# ============================================================
# QUICK 模式
# ============================================================
if ($Quick) {
    Write-Host '=== 快速检查 ===' -ForegroundColor Cyan
    if (Test-Path $SkillsDir) {
        $count = (Get-ChildItem "$SkillsDir\*" -Directory).Count
        Write-Host "[OK] 技能根目录存在，已安装 $count 个技能目录" -ForegroundColor Green
    } else {
        Write-Host "[!!] 技能根目录不存在" -ForegroundColor Red
        exit 1
    }
    return
}

# ============================================================
# 1. 技能目录检查
# ============================================================
Write-Host '=== Claude for Legal CN to Codex 完整性验证 ===' -ForegroundColor Cyan
Write-Host ''

$domains = @(
    'claude-legal-cn',
    'commercial-legal','privacy-legal','product-legal','corporate-legal',
    'employment-legal','regulatory-legal','ai-governance-legal','litigation-legal',
    'law-student','legal-clinic','legal-builder-hub','ip-legal','solo-law-firm'
)

Write-Host '--- 技能目录 ---' -ForegroundColor Cyan
if (-not (Test-Path $SkillsDir)) {
    Write-Host "[!!] 技能根目录不存在，请运行 install.ps1" -ForegroundColor Red
    exit 1
}
Write-Host "[OK] 根目录: $SkillsDir" -ForegroundColor Green

$allOk = $true
foreach ($name in $domains) {
    $dir = "$SkillsDir\$name"
    $hasSkill = Test-Path "$dir\SKILL.md"
    $hasClaude = Test-Path "$dir\CLAUDE.md"
    if ($hasSkill -and $hasClaude) {
        Write-Host "  [OK] $name" -ForegroundColor Green
    } elseif ($hasSkill) {
        Write-Host "  [!]  $name (缺 CLAUDE.md)" -ForegroundColor Yellow ; $allOk = $false
    } else {
        Write-Host "  [!!] $name (缺失)" -ForegroundColor Red ; $allOk = $false
    }
}

# ============================================================
# 2. 护栏层检查
# ============================================================
Write-Host ''
Write-Host '--- 护栏层 ---' -ForegroundColor Cyan

$guardDir = "$RepoRoot\patches\guards"
$guardFiles = @('blocking-list.md','meta-rules.md','workflows.md','china-unique.md','hk-bridge.md','appendix.md')
$guardOk = $true
foreach ($gf in $guardFiles) {
    $gfPath = "$guardDir\$gf"
    if (Test-Path $gfPath) {
        Write-Host "  [OK] $gf" -ForegroundColor Green
    } else {
        Write-Host "  [!]  缺失: $gf" -ForegroundColor Yellow ; $guardOk = $false
    }
}

# 阻断条目数
$blockPath = "$RepoRoot\skills\references\22-blocked-concepts.md"
if (Test-Path $blockPath) {
    $count = (Select-String -Path $blockPath -Pattern '^\| \d+ \|' -Encoding UTF8).Count
    Write-Host "  [OK] 阻断清单: $count 条" -ForegroundColor Green
} else {
    Write-Host "  [!]  阻断清单缺失" -ForegroundColor Yellow
}

# ============================================================
# 3. 文件哈希校验
# ============================================================
if (-not $NoHash) {
    Write-Host ''
    Write-Host '--- 哈希校验 ---' -ForegroundColor Cyan

    # 关键文件列表
    $criticalFiles = @(
        'install.ps1','update.ps1','verify.ps1','uninstall.ps1','patches\overlay.yaml',
        'patches\guards\blocking-list.md',
        'patches\guards\meta-rules.md',
        'patches\guards\workflows.md',
        'skills\references\22-blocked-concepts.md',
        'skills\references\core-principles-guard.md',
        'patches\references\alignment'
    )

    # 从 git 获取已知哈希（无 git 时跳过对照）
    $hasGit = (git rev-parse --is-inside-work-tree 2>$null) -eq 'true'
    $hashIssues = 0

    foreach ($file in $criticalFiles) {
        $fullPath = Join-Path $RepoRoot $file
        
        # 如果是目录，检查目录内文件
        if (Test-Path -Path $fullPath -PathType Container) {
            $dirFiles = Get-ChildItem -Recurse -File $fullPath
            foreach ($df in $dirFiles) {
                $hash = (Get-FileHash -Path $df.FullName -Algorithm SHA256).Hash
                $relPath = $df.FullName.Replace($RepoRoot, '').TrimStart('\')
                if ($hasGit) {
                    $gitChanged = git diff --name-only HEAD -- $relPath 2>$null
                    if ($gitChanged) {
                        Write-Host "  [!]  已修改: $relPath" -ForegroundColor Yellow
                        $hashIssues++
                    } else {
                        Write-Host "  [OK] $($relPath.Substring(0, [Math]::Min(60,$relPath.Length)).PadRight(60)) $hash" -ForegroundColor Green
                    }
                } else {
                    Write-Host "  [OK] $($relPath.Substring(0, [Math]::Min(60,$relPath.Length)).PadRight(60)) $hash" -ForegroundColor Green
                }
            }
            continue
        }

        if (-not (Test-Path $fullPath)) {
            Write-Host "  [!!] 缺失: $file" -ForegroundColor Red
            $hashIssues++
            continue
        }

        $hash = (Get-FileHash -Path $fullPath -Algorithm SHA256).Hash
        if ($hasGit) {
            $gitChanged = git diff --name-only HEAD -- $file 2>$null
            if ($gitChanged) {
                Write-Host "  [!]  已修改: $($file.PadRight(60)) $hash" -ForegroundColor Yellow
                $hashIssues++
            } else {
                Write-Host "  [OK] $($file.PadRight(60)) $hash" -ForegroundColor Green
            }
        } else {
            Write-Host "  [OK] $($file.PadRight(60)) $hash" -ForegroundColor Green
        }
    }

    if ($hashIssues -gt 0) {
        Write-Host "  $hashIssues 个文件不符合预期 — 可能有未提交修改或文件损坏" -ForegroundColor Yellow
        $allOk = $false
    } elseif ($hasGit) {
        Write-Host "  [OK] 所有关键文件哈希一致（与 git HEAD 比对）" -ForegroundColor Green
    }
}

# ============================================================
# 4. MCP 可达性检查
# ============================================================
if (-not $NoMcp) {
    Write-Host ''
    Write-Host '--- MCP 可达性 ---' -ForegroundColor Cyan

    $mcpDir = "$RepoRoot\patches\connectors"
    if (-not (Test-Path $mcpDir)) {
        Write-Host "  [!]  MCP 配置目录不存在" -ForegroundColor Yellow
    } else {
        $mcpFiles = Get-ChildItem "$mcpDir" -Filter '*.mcp.json'
        $uniqueUrls = @{}
        foreach ($mf in $mcpFiles) {
            try {
                $json = Get-Content $mf.FullName -Encoding UTF8 -Raw | ConvertFrom-Json
                foreach ($server in $json.mcpServers.PSObject.Properties) {
                    $url = $server.Value.url
                    $title = $server.Value.title
                    if ($url -and -not $uniqueUrls.ContainsKey($url)) {
                        $uniqueUrls[$url] = $title
                    }
                }
            } catch {
                Write-Host "  [!!] JSON 解析失败: $($mf.Name)" -ForegroundColor Red
            }
        }

        Write-Host "  检测到 $($uniqueUrls.Count) 个 MCP 连接器"
        $mcpIssues = 0
        $mcpAuth = 0
        foreach ($url in $uniqueUrls.Keys) {
            $title = $uniqueUrls[$url]
            try {
                $response = Invoke-WebRequest -Uri $url -TimeoutSec 2 -Method Head -ErrorAction SilentlyContinue
                if ($response -and $response.StatusCode -lt 400) {
                    Write-Host "  [OK] $title" -ForegroundColor Green
                    Write-Host "       $url"
                } elseif ($response -and $response.StatusCode -eq 401) {
                    Write-Host "  [OK] $title (需认证 — 端点存在)" -ForegroundColor Green
                    Write-Host "       $url"
                    $mcpAuth++
                } elseif ($response -and $response.StatusCode -eq 403) {
                    Write-Host "  [OK] $title (需认证 — 端点存在)" -ForegroundColor Green
                    Write-Host "       $url"
                    $mcpAuth++
                } elseif ($response -and $response.StatusCode -eq 405) {
                    Write-Host "  [OK] $title (不支持 HEAD — 端点存在)" -ForegroundColor Green
                    Write-Host "       $url"
                } else {
                    Write-Host "  [!]  $title (HTTP $($response.StatusCode))" -ForegroundColor Yellow
                    Write-Host "       $url"
                    $mcpIssues++
                }
            } catch {
                # Some MCP don't support HEAD; try GET
                try {
                    $response = Invoke-WebRequest -Uri $url -TimeoutSec 2 -Method Get -ErrorAction SilentlyContinue
                    if ($response -and $response.StatusCode -lt 400) {
                        Write-Host "  [OK] $title" -ForegroundColor Green
                    } elseif ($response) {
                        Write-Host "  [OK] $title (需认证/配置 — 端点可达)" -ForegroundColor Green
                        $mcpAuth++
                    }
                    Write-Host "       $url"
                } catch {
                    $errMsg = $_.Exception.Message.Substring(0, [Math]::Min(60, $_.Exception.Message.Length))
                    if ($errMsg -match '401|403|Unauthorized') {
                        Write-Host "  [OK] $title (需认证 — 端点可达)" -ForegroundColor Green
                        Write-Host "       $url"
                        $mcpAuth++
                    } else {
                        Write-Host "  [!]  $title — 不可达" -ForegroundColor Yellow
                        Write-Host "       $url"
                        Write-Host "       $errMsg" -ForegroundColor DarkGray
                        $mcpIssues++
                    }
                }
            }
        }

        if ($mcpIssues -gt 0) {
            Write-Host "  $mcpIssues 个 MCP 连接器不可达 — 可能需要网络或 VPN" -ForegroundColor Yellow
        } elseif ($mcpAuth -gt 0) {
            Write-Host "  [OK] $($uniqueUrls.Count) 个端点可达 ($mcpAuth 个需认证令牌)" -ForegroundColor Green
        } else {
            Write-Host "  [OK] 所有 MCP 连接器可达" -ForegroundColor Green
        }
    }
}

# ============================================================
# 5. solo-law-firm 检查
# ============================================================
Write-Host ''
Write-Host '--- solo-law-firm 技能集 ---' -ForegroundColor Cyan
$soloBase = "$SkillsDir\solo-law-firm"
if (Test-Path $soloBase) {
    $soloSkills = Get-ChildItem -Recurse "$soloBase" -Filter 'SKILL.md'
    Write-Host "  [OK] $($soloSkills.Count) 个自包含技能" -ForegroundColor Green
} else {
    Write-Host "  [!]  目录不存在，请运行 install.ps1" -ForegroundColor Yellow
}

# ============================================================
# 总结
# ============================================================
Write-Host ''
Write-Host '========================================' -ForegroundColor Cyan
if ($allOk -and $guardOk) {
    Write-Host '  验证通过。' -ForegroundColor Green
    Write-Host ''
    Write-Host '  下一步可运行:' -ForegroundColor Cyan
    Write-Host '    .\verify.ps1 -Benchmark          # 中国法护栏对抗测试' -ForegroundColor White
} else {
    Write-Host '  存在问题，请检查以上标记项。' -ForegroundColor Yellow
}
Write-Host '========================================' -ForegroundColor Cyan
