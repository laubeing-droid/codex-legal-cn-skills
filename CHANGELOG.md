# 鏇存柊鏃ュ織

## [鏈彂甯僝

## [2.5.0] - 2026-05-24
- 鏂板 solo-law-firm 鐙珛鎵т笟鎶€鑳介泦锛?6 涓嚜鍖呭惈鎶€鑳斤紝8 涓儴闂級
  - 涓婃父鏉ユ簮: saysoph/solo-law-firm-agents锛堜慨鏀圭増 v1.1.0锛?  - 淇敼璁板綍: 鍚堝苟 2 椤广€侀噸鍛藉悕 2 椤广€侀儴闂ㄨ皟鏁?1 椤广€佹柊澧炰笂涓嬫父鍗忎綔寮曠敤 19 椤?- 鏍硅矾鐢?claude-legal-cn 鏂板 solo-law-firm 鍏抽敭璇嶈矾鐢憋紙7 鏉★級
- install.ps1 / update.ps1 / verify.ps1 / uninstall.ps1 鏂板 solo-law-firm 鏀寔
- upstream-monitor.yml 鏂板 saysoph/solo-law-firm-agents 涓婃父鐩戞帶
- upstream-monitor.yml 鏂板 sync-solo-law-firm 鑷姩鍚屾 PR job
  - 姣忓懆妫€娴嬩笂娓告柊鎶€鑳斤紝鑷姩鎸夐儴闂ㄥ悎鍏ュ苟鍒涘缓 PR
  - 宸插悎骞?閲嶅懡鍚嶆妧鑳斤紙4 涓級璺宠繃鑷姩鍚屾锛岄渶浜哄伐瀹℃牳
- 鏂板 docs/skills-crosswalk.md 涓ゅ鎶€鑳藉鐓х储寮?
## [2.4.0] - 2026-05-23
- 鏍规妧鑳介噸鍛藉悕锛歝odex-for-legal-cn -> claude-legal-cn
- MCP 杩炴帴鍣ㄤ粨搴撻噸鍛藉悕锛歝odex-legal-mcp-connectors -> Codex-Claude-legal-cn-mcp-hub
- 鏇存柊鍏ㄩ儴鑴氭湰鍜屾枃妗ｄ腑鐨勫紩鐢?
## [2.3.0] - 2026-05-23
- 鍏ㄩ儴 docs 浠庨浂閲嶅啓锛圧EADME/QUICKSTART/CHANGELOG + 6 绡囨枃妗ｏ級

## [2.2.1] - 2026-05-23
- 鍒犻櫎 .mcp.json 澶嶅埗琛岋紙Claude Code 鏍煎紡锛孋odex 涓嶈瘑鍒級

## [2.2.0] - 2026-05-23
- GitHub 浠撳簱閲嶅懡鍚嶄负 Claude-for-Legal-CN-to-Codex
- 鍏ㄩ儴鏂囨。鍜岃剼鏈樉绀哄悕绉扮粺涓€鏇存柊

## [2.1.0] - 2026-05-23
- update.ps1 5 姝ユ祦绋嬮噸鏋勶細MCP 濮旀墭缁欑嫭绔嬩粨搴?
## [2.0.0] - 2026-05-23
- MCP 閰嶇疆閫昏緫杩佺Щ鍒?codex-legal-mcp-connectors 鐙珛浠撳簱

## [1.4.0-1.0.0] - 2026-05-23
- MCP 闆嗘垚銆佹灦鏋勬暣鏀广€佹枃妗ｄ綋绯绘惌寤恒€佸垵濮嬪彂甯?

## [2.9.0] - 2026-05-25
### Rule Runtime
- claude-legal-cn/SKILL.md: Rule Runtime mandatory enforcement (reasoning lock + blocking filter + output self-check)

### Non-litigation Automation
- contract-review-checklist.md: 51-item checklist (commercial-legal)
- labor-compliance-sop.md: 46-item SOP (employment-legal)
- data-compliance-sop.md: 55-item SOP (privacy-legal)

### Tools
- gen-knowledge-index.ps1: auto-scan and regenerate MAPPING.md (22 laws)
- diff-tool-all.ps1: unified upstream check

### CI
- sync-aln-framework.yml: auto-sync from ALN Framework via repository_dispatch

### Docs
- README: add JDP to companion projects
- Fix UPSTREAM_DIFF_POLICY.md upstream list

## [2.8.1] - 2026-05-25
### Rule Runtime
- claude-legal-cn/SKILL.md new section: Rule Runtime (mandatory enforcement)
- Reasoning chain lock: force-load reasoning-template-zh.md, ban IRAC
- Blocking filter: scan 29-concept blocklist before every output
- Output self-check: append [Rule Runtime self-check] fold; all green before finish

### Tools
- New gen-knowledge-index.ps1: auto-scan skills/*/references/ and regenerate MAPPING.md
- New patches/diff-tool-all.ps1: unified check of all 4 upstreams

### Docs
- Update docs/UPSTREAM_DIFF_POLICY.md: remove non-existent qulv, add self-dev framework, mark solo disconnected
- Sync upstream-monitor.yml descriptions

### Fixes
- MAPPING.md: add 3 missing laws (Civil Code, Personal Info Export Contract, AI Content Label)
- Blocking list count unified to 29
## [2.8.0] - 2026-05-25
### 架构变更
- 断开 zhou210712 上游依赖，改为本地部署+参考窗口模式
- 断开 saysoph 上游自动同步，仅保留监控
- 断开 solo-law-firm 自动同步（GitHub Actions 去掉了 sync job）
- install/update/uninstall/verify 全部改从本仓库 skills/ 部署

### 中国化
- deposition-prep → 调查取证准备（完整重写）
- legal-hold → 证据保全与留存（完整重写）
- subpoena-triage → 司法协查响应（完整重写）
- cease-desist → 律师函生成（改名，内容已是中国法）
- privilege-log-review → 删除（中国无此制度）
- 同步更新所有跨文件命令引用（CLAUDE.md/README.md/SKILL.md）

### 工具增强
- diff-tool-zhou: 新增 150+ 子技能跟踪 + -Diff 行级差异 + -Update 快照
- diff-tool-max: 新增子技能提取 + -Diff + -Update
- 新增 diff-tool-solo: saysoph 上游比对（中文→英文名映射）
- install/update: solo-law-firm 独立部署逻辑（嵌套 8 科室结构）

### 清理
- 删除 patches/references/laws/（11 个旧法条文件，已被 qulv 替代）
- 删除 patches/full/（79 KB 完整框架，已拆分为 alignment + guards）
- 删除 docs/gjhcsjamin-adaptation-analysis.md（上游已移除）
- 移除 @pkulaw/mcp-cli 监控（属 MCP 仓库范畴）
- 全量重写 docs/ 文档体系（适配当前架构）
