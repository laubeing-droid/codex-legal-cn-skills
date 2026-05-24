# CREDITS — 致谢与来源说明

> 本仓库整合了 4 个上游项目的成果，并在此基础上做了**只有本仓库才有的增强**。
> 以下逐一注明来源、贡献范围、许可协议。

---

## 上游来源

### anthropics/claude-for-legal — 原始法律 AI 框架

- **仓库**：https://github.com/anthropics/claude-for-legal
- **作者**：Anthropic PBC
- **许可**：Apache License 2.0
- **贡献**：12 个法律领域 × 150+ 子技能的原始框架设计、工作流逻辑、技能目录结构
- **本仓库使用方式**：所有子技能的结构和流程框架继承自此（经 zhou210712 汉化后整合）
- **状态**：仅参考监控，不作运行依赖

### zhou210712/claude-for-legal-ZH — 中国汉化版（主要内容来源）

- **仓库**：https://github.com/zhou210712/claude-for-legal-ZH
- **作者**：陈石 律师
- **许可**：Apache License 2.0
- **贡献**：
  - 12 个领域 CLAUDE.md 中文化（UI 标题、提示文本）
  - 12 个领域 MCP 连接器替换为中国工具（e签宝、法大大、飞书等）
  - 9 个中国法引用文件（民法典、公司法、劳动法等核心条款摘要）
  - marketplace.json 元数据中文化
- **本仓库使用方式**：12 个法律领域的内容主体来源于此。`patches/workflows/` 和 `patches/connectors/` 存储其快照
- **本仓库超越的地方**：
  - 法条引用：zhou 用摘要 → 本仓库用官方 PDF 全文（qulv）
  - 子技能：zhou 只改注释 → 本仓库全量重写 5 个
  - 概念对齐：zhou 没做 → 本仓库自研 PRC-US 映射
  - 护栏：zhou 没做 → 本仓库自制 8 个护栏文件
- **状态**：已断开自动同步，`diff-tool-zhou.ps1` 跟踪参考

### MAXXXXXLI/workbuddy-cn-legal-skills — 中国法律语境文件

- **仓库**：https://github.com/MAXXXXXLI/workbuddy-cn-legal-skills
- **许可**：开源
- **贡献**：14 个中国法律语境文件（china-context-*.md），每领域一段法源背景提示
- **本仓库使用方式**：语境文件整合进 `patches/references/context/`，随部署安装到各领域
- **本仓库超越的地方**：MAXXXXXLI 只做外层包裹 → 本仓库将语境内容与自研对齐框架合并使用
- **状态**：已断开自动同步，`diff-tool-max.ps1` 跟踪参考

### saysoph/solo-law-firm-agents — 独立执业技能

- **仓库**：https://github.com/saysoph/solo-law-firm-agents
- **许可**：MIT
- **贡献**：26 个独立执业技能（8 科室），覆盖案件实务/管理/客户关系/尽调/市场/财务/知识管理/合规
- **本仓库使用方式**：技能经格式适配、中英名映射、合并优化后纳入 `skills/solo-law-firm/`
- **本仓库补充**：新增庭审提纲生成器（trial-outline-generator），补齐业务流程
- **状态**：已断开自动同步，`diff-tool-solo.ps1` 跟踪参考

---

## 自研内容（本仓库独有，不涉及上游）

以下内容完全由本仓库自行研发，上游没有任何一个版本拥有：

| 资产 | 说明 |
|:-----|:-----|
| **PRC-US 法律语义对齐框架** | 12 领域 × 中美法律概念一对一映射，配套 8 个护栏文件（阻断清单、元规则、香港桥梁等） |
| **qulv 知识库** | 22 部中国法律官方 PDF 全文入库（民法典 1062 条、公司法 248 条等），不是摘要，是官方原文 |
| **中国化子技能** | 调查取证准备、证据保全与留存、司法协查响应（全量重写）、律师函生成（改名）、privilege-log-review（删除） |
| **4 路 diff-tool 参考窗口架构** | 每路上游独立比对脚本，`-Diff` 行级差异，`-Update` 快照更新 |
| **MCP 连接器独立仓库** | 与技能内容解耦，独立管理凭证和更新，不混入主仓库 |
| **安装/更新脚本** | install.ps1 / update.ps1 / uninstall.ps1 / verify.ps1 — 全部从本仓库部署，不依赖上游 vendor |

---

## 许可

本仓库整体采用 **Apache License 2.0**（继承自上游 anthropics/claude-for-legal）。
各上游内容遵循其原始许可协议：
- anthropics/claude-for-legal → Apache 2.0
- zhou210712/claude-for-legal-ZH → Apache 2.0
- saysoph/solo-law-firm-agents → MIT
- MAXXXXXLI/workbuddy-cn-legal-skills → 开源

---

> 如本致谢遗漏了任何贡献者，请提交 Issue 告知。
