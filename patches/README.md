# patches/ — 上游补丁统一目录

## 目录说明

| 路径 | 来源 | 文件数 |
|------|------|:------:|
| references/laws/ | zhou210712 中国法引用 | 11 |
| references/context/ | MAXXXXXLI 法源语境 | 14 |
| references/alignment/ | 自研框架·中美概念映射 | 12 |
| workflows/ | zhou210712 中文化工作流 | 12 |
| connectors/ | zhou210712 MCP 配置 | 12 |
| guards/ | 自研框架·阻断/元规则 | 6 |
| metadata/ | 汇总 | 5 |
| full/ | 自研框架·原文 | 1 |

## 检查更新

| 命令 | 检查谁 |
|------|--------|
| .\patches\diff-tool-zhou.ps1 | zhou210712 上游 |
| .\patches\diff-tool-max.ps1 | MAXXXXXLI 上游 |
| .\patches\diff-tool-align.ps1 | 自研框架（已有 commit 钩子自动同步） |

确认后加 -Update 更新快照。
