# 更新日志
## [3.0.0] - 2026-05-23

### 泛化为多环境通用安装
- install.ps1: 重写为通用安装，自动检测 Codex/Claude Code/Claude Desktop
- install.ps1: Codex → ~/.codex/skills/, Claude Code → ~/.claude/rules/
- update.ps1: 全环境同步 + 委托 MCP 诊断
- verify.ps1: 全环境安装验证
- install.sh: 新增 macOS/Linux 通用安装脚本
- README.md: 更新多环境说明、脚本表
- closes #1 (交接文档: update.ps1 MCP委托泛化)


# 更新日志 ## [2.1.0] - 2026-05-23  ### MCP 连接器委托改造 - update.ps1: 步骤 3/4 从硬编码 MCP 检查改为委托 mcp-connectors 仓库 - README.md: 更新 MCP 相关描述，明确委托关系 - QUICKSTART.md: 更新 MCP 配置说明，新增 mcp-connectors 相关指引  fatal: not a git repository (or any of the parent directories): .git
