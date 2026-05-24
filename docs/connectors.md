# MCP 连接器

## 适配成果

本仓库将 anthropic 原版的 12 个美国法律工具连接器全部替换为中国法律生态工具：

| 原版（美国） | 替换为（中国） | 用途 |
|:------------|:--------------|:-----|
| Ironclad | e签宝 | 电子合同管理 |
| DocuSign | 法大大 | 电子签名 |
| iManage | 飞书 | 文档协作 |
| TopCounsel | 元典 | 法律法规检索 |
| Westlaw/LexisNexis | 北大法宝 | 法条+案例检索 |
| USPTO API | 国家知识产权局 | 商标专利查询 |
| PACER | 中国裁判文书网 | 案例检索 |
| Slack | 飞书消息 | 团队协作 |
| Google Drive | 飞书云文档 | 文件存储 |

## 管理方式

MCP 连接器由独立仓库 [Codex-Claude-legal-cn-mcp-hub](https://github.com/laubeing-droid/Codex-Claude-legal-cn-mcp-hub) 管理。

`install.ps1` 和 `update.ps1` 自动克隆并部署，配置凭证后即可使用：

```powershell
# 编辑 ~/.codex/config.toml
[mcp_servers.chineselaw]
command = "npx"
args = ["-y", "@pkulaw/mcp-cli"]
env = { CHINESELAW_API_KEY = "你的密钥" }
```

> **安全**：API 密钥通过 `config.toml` 注入，不提交到 Git。
