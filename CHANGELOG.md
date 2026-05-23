# 更新日志

## [1.2.0] - 2026-05-23

### 修复
- 彻底修正 MCP 连接器架构：不再向 .mcp.json 注入配置
- 改为写入 ~/.codex/config.toml 的 [mcp_servers] 段（Codex Desktop 正确格式）
- 根技能 SKILL.md：增加 MCP 配置检查流程说明

### 新增
- chineselaw-mcp（元典智库）：33 个工具（法规 5 + 案例 4 + 企业 24）
- 北大法宝 10 个 MCP 服务的完整 TOML 配置
- install.ps1 智能追加：不删除不覆盖已有配置，只添加缺失条目
- update.ps1 MCP 状态检查：运行后检测各连接器的配置和启用状态

### 文档
- connectors.md：重写为 config.toml 格式，增加 chineselaw 工具列表
- usage-guide.md：MCP 配置步骤更新为 config.toml 操作
- troubleshooting.md：增加 MCP 相关排查项

## [1.1.0] - 2026-05-23

### 新增
- MCP 连接器：chineselaw + 北大法宝

## [1.0.1] - 2026-05-23

### 修复
- install.ps1 根技能目录 Bug
- update.ps1 转义错误
- SKILL.md 格式统一

### 新增
- uninstall.ps1, verify.ps1, .gitattributes

## [1.0.0] - 2026-05-23

### 新增
- 13 个 Codex 技能，自动路由 + 自动更新，全套中文文档