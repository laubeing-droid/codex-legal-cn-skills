<!--
version: 2.9.0
module: root
status: active
-->

# CREDITS — 致谢

本仓库的诞生离不开以下开源项目的贡献。在此向每一位维护者致谢。

---

## 上游项目

### anthropics/claude-for-legal

| | |
|:-----|:-----|
| **作者** | Anthropic PBC |
| **仓库** | https://github.com/anthropics/claude-for-legal |
| **许可** | Apache License 2.0 |
| **贡献** | 12 个法律领域 × 150+ 子技能的原始框架设计、工作流逻辑和技能目录结构。本仓库所有法律领域的内容结构和流程框架均继承自该项目。 |

### zhou210712/claude-for-legal-ZH

| | |
|:-----|:-----|
| **作者** | 陈石 律师 |
| **仓库** | https://github.com/zhou210712/claude-for-legal-ZH |
| **许可** | Apache License 2.0 |
| **贡献** | 12 个领域 CLAUDE.md 的中文化、MCP 连接器替换为中国法律生态工具、中国法引用文件（民法典、公司法、劳动法等核心条款）。本仓库 12 个法律领域的内容主体来源于此。 |
| **本仓库引用** | `patches/workflows/`（CLAUDE.md 快照）、`patches/connectors/`（MCP 配置快照）、`patches/sub-skills/`（子技能快照） |

### MAXXXXXLI/workbuddy-cn-legal-skills

| | |
|:-----|:-----|
| **作者** | MAXXXXXLI |
| **仓库** | https://github.com/MAXXXXXLI/workbuddy-cn-legal-skills |
| **许可** | 开源 |
| **贡献** | 14 个中国法律语境文件（`china-context-*.md`），为每个法律领域提供中国法背景提示。本仓库将其整合进 `patches/references/context/` 并随部署安装到各领域。 |
| **本仓库引用** | `patches/references/context/` |

### saysoph/solo-law-firm-agents

| | |
|:-----|:-----|
| **作者** | saysoph |
| **仓库** | https://github.com/saysoph/solo-law-firm-agents |
| **许可** | MIT |
| **贡献** | 26 个独立执业技能（8 个科室），覆盖案件实务、案件管理、客户关系、尽职调查、市场拓展、财务行政、知识管理、合规风控。本仓库在此基础上新增了庭审提纲生成器。 |
| **本仓库引用** | `skills/solo-law-firm/`（经格式适配和技能名映射后纳入） |

### Daknniel-0881/qulv-china-legal-counsel-skill

| | |
|:-----|:-----|
| **作者** | Daknniel-0881 |
| **仓库** | https://github.com/Daknniel-0881/qulv-china-legal-counsel-skill |
| **许可** | 开源 |
| **贡献** | 22 部中国法律官方 PDF/文本，覆盖民法典、公司法、劳动法、知识产权法、数据法、AI 治理等全部法律领域。本仓库 `skills/*/references/` 目录下 24 个法条全文和实务指引文件来源于此。 |
| **本仓库引用** | `skills/*/references/`（24 个法条全文和实务文件） |

---

## 自研内容（不涉及上游）

以下内容由本仓库自行研发：

- **PRC-US 法律语义对齐框架** — 12 个领域 × 中美法律概念一对一映射 + 配套护栏文件
- **中国化子技能** — 调查取证准备、证据保全与留存、司法协查响应、律师函生成（全量重写）
- **4 路 diff-tool 参考窗口架构** — 各上游独立比对脚本
- **MCP 连接器独立仓库** — 与技能内容解耦管理

---

## 许可

本仓库整体采用 **Apache License 2.0**（继承自上游）。
各上游内容遵循其原始许可协议：
- anthropics/claude-for-legal → Apache 2.0
- zhou210712/claude-for-legal-ZH → Apache 2.0
- saysoph/solo-law-firm-agents → MIT
- Daknniel-0881/qulv-china-legal-counsel-skill → 开源

> 如本致谢遗漏了任何贡献者，请提交 Issue 告知。
