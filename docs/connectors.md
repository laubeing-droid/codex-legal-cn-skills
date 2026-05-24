# MCP 连接器

MCP 连接器由独立仓库 [Codex-Claude-legal-cn-mcp-hub](https://github.com/laubeing-droid/Codex-Claude-legal-cn-mcp-hub) 管理。
本仓库的 `install.ps1` 和 `update.ps1` 自动克隆并调用其安装脚本。

## 配置凭证

编辑 `~/.codex/config.toml`，替换对应 API Key：

```toml
[mcp_servers.chineselaw]
command = "npx"
args = ["-y", "@pkulaw/mcp-cli"]
env = { CHINESELAW_API_KEY = "你的密钥" }

[mcp_servers.feishu]
command = "npx"
args = ["-y", "@yuri2/feishu-mcp"]
env = { FEISHU_APP_ID = "...", FEISHU_APP_SECRET = "..." }
```

## 安全

API 密钥通过 `config.toml` 或环境变量注入，**切勿提交到 Git**。
