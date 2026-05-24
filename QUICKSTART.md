# 快速入门

60 秒完成安装，立即使用中国法律 AI 技能。

## 安装

```powershell
git clone https://github.com/laubeing-droid/Claude-for-Legal-CN-to-Codex.git
cd Claude-for-Legal-CN-to-Codex
.\install.ps1
```


安装过程自动完成：
- 从本仓库部署 13 个技能领域到 `~/.codex/skills/`
- 克隆 MCP 连接器仓库并写入 `~/.codex/config.toml`

## 验证

```powershell
.\verify.ps1
```

应显示全部 13 个技能均为 [OK]。

## 配置 MCP（可选但推荐）

安装后编辑 `~/.codex/config.toml`，替换凭证：

- **chineselaw（推荐）**：注册 https://open.chineselaw.com → 获取 API Key，替换 `CHINESELAW_API_KEY`
- **北大法宝**：注册 https://mcp.pkulaw.com → 获取 Access Token，替换所有 `YOUR_ACCESS_TOKEN`

详细指南见 [MCP 连接器仓库](https://github.com/laubeing-droid/Codex-Claude-legal-CN-mcp-connectors)。

## 使用

重启 Codex Desktop，直接输入：

```
帮我审查这份 SaaS 服务协议
分析一下这个案件的管辖权
评估个人信息保护合规风险
```

系统自动识别并调用对应技能。

## 常见问题

| 问题 | 解决 |
|------|------|
| 技能没生效？ | 重启 Codex Desktop |
| 引用标注[需验证]？ | MCP 未配置，运行 `.\update.ps1` 查看状态 |
| 如何更新？ | 运行 `.\update.ps1` |
| MCP 连接器问题？ | 运行 `.\mcp-connectors\update.ps1` |
| 如何卸载？ | 运行 `.\uninstall.ps1` |

详细说明见 [docs/usage-guide.md](docs/usage-guide.md)。
