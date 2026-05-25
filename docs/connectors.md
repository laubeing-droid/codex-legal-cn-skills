<!--
version: 2.9.0
module: docs
status: active
-->

# MCP 连接器

## 为什么单独搞一个仓库？

所有上游版本（zhou210712、gjhcsjamin）都把 MCP 配置硬编码在仓库里。  
你做了一个**关键决策**：把它拆成独立仓库 `Codex-Claude-legal-cn-mcp-hub`。

好处：
- 凭证信息不会混入主仓库
- MCP 更新不影响技能内容
- 其他人可以直接复用这套连接器配置

## 替换了什么

| 原版（美国工具） | 本仓库（中国工具） |
|:----------------|:-----------------|
| Ironclad | e签宝 |
| DocuSign | 法大大 |
| iManage | 飞书 |
| TopCounsel | 元典法律检索 |
| Westlaw/LexisNexis | 北大法宝 |
| USPTO API | 国家知识产权局 |
| PACER | 中国裁判文书网 |
| Slack | 飞书消息 |

## 使用

`install.ps1` 自动克隆 MCP Hub，编辑 `~/.codex/config.toml` 替换 API Key 即可。
