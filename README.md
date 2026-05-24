# Claude for Legal CN to Codex

**将 Anthropic 美国法律 AI 全面中国化的 Codex 技能包。**

覆盖商事合同、诉讼仲裁、劳动用工、数据合规、知识产权等 12 个法律领域 + 独立执业技能集。
从法条引用到工作流指令、从 MCP 连接到护栏阻断，逐层替换为适配中国法律体系的内容。

---

> **免责**：所有 AI 输出均为律师辅助草稿，不构成正式法律意见，需经执业律师审查。

---

## 📊 适配成果一览

| 适配维度 | 做了什么 | 规模 |
|:---------|:---------|:----:|
| **法条引用** | 22 部中国法律官方 PDF 全文入库（qulv），替代美国法/摘要式法条 | 涵盖民法典、公司法、劳动法等核心法域 |
| **子技能重写** | 5 个美国法子技能删除/改名/重写为中国版 | 证据保全、调查取证、司法协查、律师函 |
| **工作流中文化** | 12 个领域 CLAUDE.md 全量中文化（标题/提示/冷启动/审批矩阵） | UI 中文 + 法律依据替换 |
| **PRC-US 概念对齐** | 12 个领域的中美法律概念映射 + 8 个护栏文件 | 含阻断清单、元规则、香港普通法桥梁 |
| **MCP 连接器替换** | 12 个领域将美国法律工具（Ironclad/DocuSign/iManage 等）全部替换为中国生态 | e签宝、法大大、飞书、元典、北大法宝 |
| **MAXXXXXLI 语境补充** | 14 个中国法语境文件覆盖 12 个领域 | 每领域一段法源背景提示 |
| **技能总数** | 150+ 法律子技能 + 27 个独立执业技能 | 适配后全部可在中国法场景使用 |

---

## 安装

```powershell
git clone https://github.com/laubeing-droid/Claude-for-Legal-CN-to-Codex.git
cd Claude-for-Legal-CN-to-Codex
.\install.ps1
```

重启 Codex Desktop 即可使用。

---

## 仓库结构

```
Claude-for-Legal-CN-to-Codex/
├── skills/                          ← 核心内容（全部已中国化）
│   ├── commercial-legal/            ← 商事合同（12 子技能）
│   ├── litigation-legal/            ← 诉讼仲裁（含3个中国版技能）
│   ├── employment-legal/            ← 劳动用工
│   ├── privacy-legal/               ← 数据合规（中国三法）
│   ├── corporate-legal/             ← 公司交易（适配新公司法）
│   ├── ip-legal/                    ← 知识产权（含律师函生成）
│   ├── product-legal/               ← 产品合规
│   ├── regulatory-legal/            ← 监管合规
│   ├── ai-governance-legal/         ← AI 治理（适配中国AI法规）
│   ├── law-student/                 ← 法学院
│   ├── legal-clinic/                ← 法律援助
│   ├── legal-builder-hub/           ← 技能构建器
│   ├── solo-law-firm/               ← 独立执业（8科室27技能）
│   ├── knowledge-base/              ← qulv 22部官方PDF
│   └── references/                  ← 中国法护栏
│
├── patches/                         ← 上游快照 + 比对层
│   ├── workflows/                   ← 中文化 CLAUDE.md 快照
│   ├── connectors/                  ← 中国MCP连接器快照
│   ├── references/                  ← 语境 + 对齐
│   ├── guards/                      ← 护栏文件
│   └── sub-skills/                  ← 子技能快照
│
├── install.ps1 / update.ps1         ← 部署脚本
├── patches/diff-tool-zhou.ps1       ← 上游变更检测（含-Diff行级比对）
├── patches/diff-tool-max.ps1        ← MAXXXXXLI 上游检测
├── patches/diff-tool-solo.ps1       ← saysoph 上游检测
└── .github/workflows/               ← 上游监控 Actions
```

---

## 中国化深度对比

### 法条引用层

| 原版（Anthropic 美国法） | 本仓库（中国法） |
|:------------------------|:----------------|
| U.S.C. / C.F.R. / 各州法典 | 民法典、公司法、劳动法、个人信息保护法等 22 部 PDF |
| IRS Tax Code / SEC Rules | 最高院司法解释、行政法规 |
| DMCA / CCPA / COPPA | PIPA、DSL、CSL（中国数据三法） |
| Delaware General Corporation Law | 中国公司法（2024 修订） |

### 工作流指令层

| 原版 | 本仓库 |
|:-----|:------|
| "File a motion" | "提交诉讼文书" |
| "Discovery request" | "调查取证申请" |
| "Legal hold notice" | "证据保全通知" |
| "Cease and desist letter" | "律师函" |
| "Deposition prep" | "庭审询问准备" |

### 工具连接层

| 原版 | 本仓库替换为 |
|:-----|:------------|
| Ironclad（合同管理） | e签宝 |
| DocuSign（电子签名） | 法大大 |
| iManage（文档管理） | 飞书 |
| TopCounsel（律所推荐） | 元典法律检索 |
| Westlaw / LexisNexis | 北大法宝 |

---

## 上游监控（参考窗口）

上游更新了不再自动同步 → 通过 Issues 通知，手动决定是否合并：

| 上游 | 工具 |
|:----|:-----|
| zhou210712/claude-for-legal-ZH | `diff-tool-zhou.ps1`（174 文件比对） |
| MAXXXXXLI/workbuddy-cn-legal-skills | `diff-tool-max.ps1` |
| saysoph/solo-law-firm-agents | `diff-tool-solo.ps1` |
| 自研 PRC-US 对齐框架 | `diff-tool-align.ps1` |

---

## 依赖

- **Codex Desktop**（运行环境）
- **Codex-Claude-legal-cn-mcp-hub**（MCP 连接器独立仓库）
- 上游仓库仅作参考，不作运行依赖
