# 快速入门

60 秒完成安装并开始使用法律技能。

## 安装

```powershell
git clone https://github.com/laubeing-droid/codex-legal-cn-skills.git
cd codex-legal-cn-skills
.\install.ps1
```

安装过程会自动克隆 MCP 连接器配置（codex-legal-mcp-connectors）并写入 config.toml。

## 验证

```powershell
.\verify.ps1
```

## 配置 MCP（可选但推荐）

安装脚本会在安装时提示输入 API Key / Access Token。如留空，之后手动配置：

1. 编辑 `~/.codex/config.toml`，替换 `CHINESELAW_API_KEY` 和 `YOUR_ACCESS_TOKEN`
2. 运行 `.\update.ps1` 验证凭证状态（自动调用 mcp-connectors 仓库的脚本）
3. 重启 Codex Desktop

**chineselaw（推荐）**：注册 https://open.chineselaw.com → 获取 API Key
**北大法宝**：注册 https://mcp.pkulaw.com → 获取 Access Token

详细指南见 [MCP 连接器仓库](https://github.com/laubeing-droid/codex-legal-mcp-connectors)。

## 开始使用

重启 Codex Desktop，直接输入：

```
帮我审查这份 SaaS 服务协议
分析一下这个案件的管辖权
评估个人信息保护合规风险
```

系统自动识别并调用对应技能。

## 常见问题

- **技能没生效？** 重启 Codex Desktop
- **引用标注[需验证]？** 运行 `.\update.ps1` 查看 MCP 连接器状态
- **如何更新？** 运行 `.\update.ps1`（同步技能 + 委托 MCP 连接器更新）
- **MCP 连接器问题？** 直接运行 `.\mcp-connectors\update.ps1` 获取详细诊断
- **如何卸载？** 运行 `.\uninstall.ps1`

详细说明见 docs/usage-guide.md。
