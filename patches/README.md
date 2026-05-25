<!--
version: 2.9.0
module: patches
status: active
-->

# patches/ 目录说明

> 本目录存放本仓库对上游内容的增量修改（Overlay）。

---

## 核心文件：overlay.yaml

**`overlay.yaml`** 是本仓库的"修改清单"——声明我们对 5 路上游的每一处改动。

不改原文件，不替代码，只做描述。将来如需编译式部署，这就是输入源。

### 格式约定

| 符号 | 含义 |
|:----:|:-----|
| `+` | 新增（上游没有） |
| `~` | 修改（上游有，本仓库改了） |
| `-` | 删除（上游有，本仓库删了） |

### 覆盖维度（8 大类）

| # | 维度 | 说明 |
|:-:|:-----|:-----|
| 1 | skills | 5 个子技能重写/删除 |
| 2 | guards | 6 个护栏文件 + 12 领域注入 |
| 3 | alignment | 12 领域中美概念映射 |
| 4 | references | 法条引用替换（qulv） |
| 5 | connectors | MCP 美国工具→中国工具 |
| 6 | deployment | install/update/verify 改写 |
| 7 | monitoring | 4 路 diff-tool 参考窗口 |
| 8 | self_developed | 不来自上游的独有资产 |

---

## 子目录说明

| 目录 | 内容 | 与 overlay.yaml 对应 |
|:-----|:-----|:--------------------|
| `workflows/` | 12 个领域的 CLAUDE.md（含护栏注入） | §2 guards |
| `connectors/` | 12 个领域的 .mcp.json（中国工具链） | §5 connectors |
| `guards/` | 6 个护栏文件 | §2 guards |
| `references/alignment/` | 12 领域概念对齐文件 | §3 alignment |
| `references/context/` | 14 个中国法语境文件 | §4 references |
| `sub-skills/` | 上游子技能快照（供 diff-tool 比对） | §7 monitoring |
| `metadata/` | marketplace.json / manifest | §6 deployment |

---

## 为什么是"描述"不走"自动编译"？

当前 603 个文件叠加模式已经够复杂。在现有 install.ps1 能正常运行的情况下，强行改写为编译式部署的成本远大于收益。

`overlay.yaml` 是过渡方案：
- **现在**：提供"你到底改了什么"的一目了然总览
- **将来**：如果真要做编译式部署，本文件就是规则引擎的输入

---

## 查看修改总览

```powershell
# 阅读修改声明
code patches\overlay.yaml

# 运行完整性验证（含哈希+MCP）
.\verify.ps1

# 运行护栏对抗测试
.\verify.ps1 -Benchmark

# 检查某个上游的变更
.\patches\diff-tool-zhou.ps1
.\patches\diff-tool-zhou.ps1 -Diff
```
