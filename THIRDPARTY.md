# THIRDPARTY.md — 第三方内容声明

> 本文档列出本仓库中包含的所有第三方代码、文件和数据的来源、许可及引用位置。
> 这是法律合规文件，与 CREDITS.md（致谢信）互补。

---

## 一、anthropics/claude-for-legal

| 项目 | 详情 |
|:-----|:-----|
| **仓库** | https://github.com/anthropics/claude-for-legal |
| **版权方** | Anthropic PBC |
| **许可证** | Apache License 2.0 |
| **引用方式** | 继承目录结构与工作流逻辑，不直接包含原始文件 |
| **引用位置** | 全部 12 个领域目录结构和 SKILL.md 模板来源于此 |
| **合规状态** | ✅ Apache 2.0 兼容 |

---

## 二、zhou210712/claude-for-legal-ZH

| 项目 | 详情 |
|:-----|:-----|
| **仓库** | https://github.com/zhou210712/claude-for-legal-ZH |
| **作者** | 陈石 律师 |
| **许可证** | Apache License 2.0 |
| **引用方式** | 本地快照（非实时同步），通过 diff-tool 维护 |
| **引用位置** | |
| CLAUDE.md 中文化（12 领域） | `patches/workflows/` |
| MCP 连接器配置 | `patches/connectors/` |
| 子技能中文化 | `patches/sub-skills/` |
| 中国法引用文件（民法典/公司法/劳动法等） | `patches/references/` |
| **合规状态** | ✅ Apache 2.0 兼容 |

---

## 三、MAXXXXXLI/workbuddy-cn-legal-skills

| 项目 | 详情 |
|:-----|:-----|
| **仓库** | https://github.com/MAXXXXXLI/workbuddy-cn-legal-skills |
| **作者** | MAXXXXXLI |
| **许可证** | 开源（无显式许可证） |
| **引用方式** | 整合进各领域参考目录 |
| **引用位置** | `patches/references/context/`（14 个中国法语境文件） |
| **合规状态** | ⚠️ 无显式许可证 — 已联系作者确认 |

---

## 四、saysoph/solo-law-firm-agents

| 项目 | 详情 |
|:-----|:-----|
| **仓库** | https://github.com/saysoph/solo-law-firm-agents |
| **作者** | saysoph |
| **许可证** | MIT |
| **引用方式** | 格式适配 + 技能名映射后纳入 |
| **引用位置** | `skills/solo-law-firm/`（26 个技能 × 8 科室 + 本仓库新增庭审提纲） |
| **合规状态** | ✅ MIT 兼容 |

---

## 五、Daknniel-0881/qulv-china-legal-counsel-skill

| 项目 | 详情 |
|:-----|:-----|
| **仓库** | https://github.com/Daknniel-0881/qulv-china-legal-counsel-skill |
| **作者** | Daknniel-0881 |
| **许可证** | 开源（无显式许可证） |
| **引用方式** | 法条 PDF/文本整合 |
| **引用位置** | `skills/*/references/`（24 个法条全文和实务文件） |
| **合规状态** | ⚠️ 无显式许可证 — 已联系作者确认 |

---

## 六、本仓库自研内容（非第三方）

以下内容由本仓库独立开发，不属于任何上游：

| 内容 | 位置 |
|:-----|:-----|
| PRC-US 法律语义对齐框架（12 领域 × 一对一映射） | `patches/references/alignment/` |
| 护栏层（阻断清单/元规则/香港桥梁/核心原则） | `patches/guards/` |
| 4 路 diff-tool 参考窗口脚本 | `patches/diff-tool-*.ps1` |
| 5 个全量重写中国法子技能 | `skills/*/skills/` |
| MCP 连接器独立仓库 | https://github.com/laubeing-droid/Codex-Claude-legal-cn-mcp-hub |
| 概念阻断清单（22 条 → 29 条扩展） | `skills/references/22-blocked-concepts.md` |
| 12 领域推理模板（自研） | `patches/workflows/*/CLAUDE.md` 注入段落 |
| 声明式 override 配置 | `patches/overlay.yaml` |

---

## 七、许可证声明

本仓库整体采用 **Apache License 2.0**。

各第三方内容的原始许可证：
- anthropics/claude-for-legal → Apache 2.0
- zhou210712/claude-for-legal-ZH → Apache 2.0
- saysoph/solo-law-firm-agents → MIT
- MAXXXXXLI/workbuddy-cn-legal-skills → 开源（无显式）
- Daknniel-0881/qulv-china-legal-counsel-skill → 开源（无显式）

> 如本声明有遗漏或错误，请提交 Issue：https://github.com/laubeing-droid/Claude-for-Legal-CN-to-Codex/issues
