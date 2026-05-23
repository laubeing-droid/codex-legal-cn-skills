# 快速入门

60 秒完成安装并开始使用法律技能。

## 安装

```powershell
git clone https://github.com/laubeing-droid/codex-legal-cn-skills.git
cd codex-legal-cn-skills
.\install.ps1
```

安装过程会自动克隆 MCP 连接器配置（codex-legal-mcp-connectors）并写入配置。

## 验证

```powershell
.\verify.ps1
```

## 配置 MCP（可选但推荐）

运行 `.\mcp-connectors\update.ps1` 验证凭证状态。

如需手动替换凭证：
- **chineselaw**：注册 https://open.chineselaw.com → 编辑 `~/.codex/config.toml` 替换 `CHINESELAW_API_KEY`
- **北大法宝**：注册 https://mcp.pkulaw.com → 编辑配置替换 `YOUR_ACCESS_TOKEN`

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
- **引用标注[需验证]？** 运行 `.\mcp-connectors\update.ps1` 查看 MCP 状态
- **如何更新？** 运行 `.\update.ps1`
- **如何卸载？** 运行 `.\uninstall.ps1`

详细说明见 docs/usage-guide.md。
