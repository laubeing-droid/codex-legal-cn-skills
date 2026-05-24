# patches/ — 上游补丁统一目录

## 目录说明

| 路径 | 来源 | 文件数 | 说明 |
|:-----|:-----|:-----:|:-----|
| references/context/ | MAXXXXXLI | 14 | 中国法语境背景提示 |
| references/alignment/ | 自研框架 | 12 | 中美法律概念映射 |
| workflows/ | zhou210712 | 12 | 中文化 CLAUDE.md 快照 |
| connectors/ | zhou210712 | 12 | 中国 MCP 连接器快照 |
| guards/ | 自研框架 | 6 | 阻断/元规则/香港桥梁 |
| sub-skills/ | zhou210712 | 150+ | 子技能原版快照 |
| metadata/ | 汇总 | 5 | marketplace/NOTICE/说明 |

## 更新检测

```powershell
# zhou210712 上游（24 主文件 + 150 子技能）
.\patches\diff-tool-zhou.ps1              # 哈希比对
.\patches\diff-tool-zhou.ps1 -Diff        # 行级差异
.\patches\diff-tool-zhou.ps1 -Update      # 更新快照

# MAXXXXXLI 上游（15 语境文件 + 子技能）
.\patches\diff-tool-max.ps1

# saysoph 上游（27 技能）
.\patches\diff-tool-solo.ps1

# 自研框架（alignment + guards）
.\patches\diff-tool-align.ps1
```

## sub-skills/ 说明

`sub-skills/` 存储的是 zhou210712 上游的子技能**原版快照**（来自上游，非本地版本）。
diff-tool 通过比对上游最新代码 vs 快照，告诉你上游改了哪些文件。
