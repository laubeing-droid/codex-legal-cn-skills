# patches/ — 上游补丁统一目录

## 目录说明

| 路径 | 来源 | 文件数 |
|------|------|:------:|
| references/context/ | MAXXXXXLI 法源语境 | 14 |
| references/alignment/ | 自研框架·中美概念映射 | 12 |
| workflows/ | zhou210712 CLAUDE.md 快照 | 12 |
| connectors/ | zhou210712 MCP 配置快照 | 12 |
| guards/ | 自研框架·阻断/元规则 | 6 |
| sub-skills/ | zhou210712 子技能快照 | 150+ |
| metadata/ | 汇总 | 5 |

## 检查更新

| 命令 | 检查谁 | 跟踪数 |
|:-----|:-------|:------:|
| `.\patches\diff-tool-zhou.ps1` | zhou210712 | 24 主文件 + 150 子技能 |
| `.\patches\diff-tool-max.ps1` | MAXXXXXLI | 15 语境文件 + 子技能 |
| `.\patches\diff-tool-solo.ps1` | saysoph | 27 技能（中→英映射） |
| `.\patches\diff-tool-align.ps1` | 自研框架 | alignment + guards |

加 `-Diff` 看行级差异，加 `-Update` 更新快照。
