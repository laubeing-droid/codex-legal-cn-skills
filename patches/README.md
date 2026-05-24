# patches/ — 上游补丁统一目录

## 

本仓库同时跟踪 4 个上游，需要一个统一目录存放快照。

| 路径 | 来源 | 文件数 | 用途 |
|:-----|:-----|:-----:|:-----|
| references/context/ | MAXXXXXLI | 14 | 中国法语境背景提示 |
| references/alignment/ | **自研** | 12 | 中美法律概念映射（本仓库独有） |
| workflows/ | zhou210712 | 12 | 中文化 CLAUDE.md 快照 |
| connectors/ | zhou210712 | 12 | 中国 MCP 连接器快照 |
| guards/ | **自研** | 6 | 阻断/元规则/香港桥梁（本仓库独有） |
| sub-skills/ | zhou210712 | 150+ | 子技能原版快照 |
| metadata/ | 汇总 | 5 | marketplace/NOTICE |

## 4 路 diff-tool

本仓库跟踪 4 个上游，各配有独立 diff-tool：

| 命令 | 检查谁 | 跟踪数 |
|:-----|:-------|:------:|
| `.\patches\diff-tool-zhou.ps1` | zhou210712 | 24 主文件 + 150 子技能 |
| `.\patches\diff-tool-max.ps1` | MAXXXXXLI | 15 语境文件 + 子技能 |
| `.\patches\diff-tool-solo.ps1` | saysoph | 27 技能（中→英映射） |
| `.\patches\diff-tool-align.ps1` | 自研框架 | alignment + guards |

加 `-Diff` 看行级差异，加 `-Update` 更新快照。

