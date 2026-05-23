# 更新日志

## [未发布]

## [2.5.0] - 2026-05-24
- 新增 solo-law-firm 独立执业技能集（26 个自包含技能，8 个部门）
  - 上游来源: saysoph/solo-law-firm-agents（修改版 v1.1.0）
  - 修改记录: 合并 2 项、重命名 2 项、部门调整 1 项、新增上下游协作引用 19 项
- 根路由 codex-claude-legal-cn 新增 solo-law-firm 关键词路由（7 条）
- install.ps1 / update.ps1 / verify.ps1 / uninstall.ps1 新增 solo-law-firm 支持
- upstream-monitor.yml 新增 saysoph/solo-law-firm-agents 上游监控
- upstream-monitor.yml 新增 sync-solo-law-firm 自动同步 PR job
  - 每周检测上游新技能，自动按部门合入并创建 PR
  - 已合并/重命名技能（4 个）跳过自动同步，需人工审核
- 新增 docs/skills-crosswalk.md 两套技能对照索引

## [2.4.0] - 2026-05-23
- 根技能重命名：codex-for-legal-cn -> codex-claude-legal-cn
- MCP 连接器仓库重命名：codex-legal-mcp-connectors -> Codex-Claude-legal-CN-mcp-connectors
- 更新全部脚本和文档中的引用

## [2.3.0] - 2026-05-23
- 全部 docs 从零重写（README/QUICKSTART/CHANGELOG + 6 篇文档）

## [2.2.1] - 2026-05-23
- 删除 .mcp.json 复制行（Claude Code 格式，Codex 不识别）

## [2.2.0] - 2026-05-23
- GitHub 仓库重命名为 Claude-for-Legal-CN-to-Codex
- 全部文档和脚本显示名称统一更新

## [2.1.0] - 2026-05-23
- update.ps1 5 步流程重构：MCP 委托给独立仓库

## [2.0.0] - 2026-05-23
- MCP 配置逻辑迁移到 codex-legal-mcp-connectors 独立仓库

## [1.4.0-1.0.0] - 2026-05-23
- MCP 集成、架构整改、文档体系搭建、初始发布
