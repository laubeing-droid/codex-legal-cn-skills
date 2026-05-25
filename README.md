<!--
version: 2.13.0
module: root
status: active
-->

# Claude for Legal CN to Codex

将 Anthropic 法律 AI 整合中国化并移植到 Codex Desktop 的一站式技能部署包。

覆盖商事合同、诉讼仲裁、劳动用工、数据合规、知识产权等 12 个法律领域 + 独立执业技能集。从法条引用到工作流指令、从 MCP 连接到护栏阻断，逐层适配中国法律体系。

---

> 🔒 **数据安全**：输入真实案件材料前，请对敏感信息（当事人姓名/身份证号/财务数据/商业秘密）进行脱敏。本工具不对底层大模型 API 的数据留存政策负责。

> **免责**：所有 AI 输出均为律师辅助草稿，不构成正式法律意见，需经执业律师审查。

---


> **法条数据**: 法律全文 JSON 已独立为 [codex-claude-legal-cn-core-codices](https://github.com/laubeing-droid/codex-claude-legal-cn-core-codices)（162部，v0.2-beta），建议作为 submodule 引入。

## 安装

**Windows:**

```powershell
git clone https://github.com/laubeing-droid/Claude-for-Legal-CN-to-Codex.git
cd Claude-for-Legal-CN-to-Codex
.\install.ps1
```

**macOS / Linux:**
```bash
git clone https://github.com/laubeing-droid/Claude-for-Legal-CN-to-Codex.git
cd Claude-for-Legal-CN-to-Codex
bash install.sh
```

重启 Codex Desktop 即可使用。

---

## 功能全景

| 维度 | 说明 |
|:-----|:------|
| **法律领域** | 12 个（商事合同 / 诉讼仲裁 / 劳动用工 / 数据合规 / 公司交易 / 知识产权 / 产品合规 / 监管合规 / AI 治理 / 法学教育 / 法律援助 / 技能构建器） |
| **子技能** | 150+（审查合同、起草律师函、分析管辖权、评估合规风险等） |
| **独立执业技能** | 27 个（8 个科室：案件实务 / 案件管理 / 客户关系 / 尽职调查 / 市场拓展 / 财务行政 / 知识管理 / 合规风控） |
| **法条引用** | 162 部中国法律原文（截至 2026-05-25，含公司法2024修订。来源：中国法律官方文本） |
| **PRC-US 概念对齐** | 12 个领域的中美法律概念映射 + 8 个护栏文件 |
| **MCP 连接器** | 12 个领域的中国法律工具链，由独立仓库管理 |

---

## 适配内容

### 子技能中国化

5 个美国法子技能在中国法律体系下做了进一步适配：

| 原名 | 现名 | 适配方式 |
|:-----|:-----|:---------|
| deposition-prep | 调查取证准备 | 重写为调查令/证据保全/质证流程 |
| legal-hold | 证据保全与留存 | 重写为公证保全/诉前保全/电子数据固化 |
| subpoena-triage | 司法协查响应 | 重写为调查令/协查通知/监管调证响应 |
| cease-desist | 律师函生成 | 改名（内容已适配中国法） |
| privilege-log-review | 已删除 | 中国无此制度 |

### 工作流中文化

12 个领域的 CLAUDE.md 全部中文化，包括：
- UI 标题、提示文本、冷启动对话
- 审批矩阵、升级路径
- 法律依据引用替换为中国法

### MCP 连接器替换

| 原版（美国工具） | 替换为（中国工具） |
|:----------------|:-----------------|
| Ironclad | e签宝 |
| DocuSign | 法大大 |
| iManage | 飞书 |
| TopCounsel | 元典法律检索 |
| Westlaw / LexisNexis | 北大法宝 |

> ⚠️ 元典智库、北大法宝、飞书等商业平台需用户自行申请 API Key 或企业授权。具体配置见 MCP Hub 仓库。

MCP 连接器由独立仓库 [Codex-Claude-legal-cn-mcp-hub](https://github.com/laubeing-droid/Codex-Claude-legal-cn-mcp-hub) 管理。

---

## 上游来源

本仓库整合了以下开源项目的内容：

| 项目 | 贡献范围 |
|:-----|:---------|
| [anthropics/claude-for-legal](https://github.com/anthropics/claude-for-legal) | 150+ 子技能的原始框架设计 |
| [zhou210712/claude-for-legal-ZH](https://github.com/zhou210712/claude-for-legal-ZH) | 12 个领域 CLAUDE.md + MCP 连接器的中文化 |
| [MAXXXXXLI/workbuddy-cn-legal-skills](https://github.com/MAXXXXXLI/workbuddy-cn-legal-skills) | 14 个中国法语境文件 |
| [saysoph/solo-law-firm-agents](https://github.com/saysoph/solo-law-firm-agents) | 26 个独立执业技能（MIT） |

各上游已断开自动同步，通过 GitHub Actions + 4 路 diff-tool 监控变更（参考窗口模式）。
详细致谢见 [CREDITS.md](CREDITS.md)。

---

## 自研内容

以下内容由本仓库自行研发，不涉及上游：

- **PRC-US 法律语义对齐框架** — 12 个领域中美法律概念一对一映射 + 配套护栏
- **中国法律知识库**（上游：中国法律官方文本）— 162 部中国法律官方 PDF 全文
- **4 路 diff-tool 参考窗口架构** — zhou210712 / MAXXXXXLI / saysoph / 自研框架各一路独立比对
- **MCP 连接器独立仓库** — 与技能内容解耦管理

---

## 相关仓库

| 仓库 | 用途 |
|:-----|:-----|
| [Codex-Legal-CN-Judgment-Predictor](https://github.com/laubeing-droid/Codex-Legal-CN-Judgment-Predictor) | AI 裁判预测框架 |
| [PRC-US-Legal-Semantic-Alignment-Framework](https://github.com/laubeing-droid/PRC-US-Legal-Semantic-Alignment-Framework) | 自研中美概念对齐框架 |
| [Codex-Claude-legal-cn-mcp-hub](https://github.com/laubeing-droid/Codex-Claude-legal-cn-mcp-hub) | MCP 连接器独立管理 |

---

## 目录结构

```
Claude-for-Legal-CN-to-Codex/
├── .github/workflows/      # CI：法条新鲜度 / 补丁完整性 / 上游监控 / 美国法术语扫描
├── benchmark/               # 对抗测试用例 + 修复指南
├── docs/                    # 架构 / 中文化分析 / 评估报告 / 上游策略 / 使用指南
├── patches/                 # 补丁层（MCP 连接器 / 护栏 / 工作流 / 参照 / 子技能 / 4 路 diff-tool）
├── skills/                  # 12 领域技能 + 根技能 + 知识库 + 独立执业技能集
│   ├── ai-governance-legal/ # AI 治理
│   ├── commercial-legal/    # 商事合同
│   ├── corporate-legal/     # 公司交易
│   ├── employment-legal/    # 劳动用工
│   ├── ip-legal/            # 知识产权
│   ├── law-student/         # 法学教育
│   ├── legal-builder-hub/   # 技能构建器
│   ├── legal-clinic/        # 法律援助
│   ├── litigation-legal/    # 诉讼仲裁
│   ├── privacy-legal/       # 数据合规
│   ├── product-legal/       # 产品合规
│   ├── regulatory-legal/    # 监管合规
│   ├── knowledge-base/      # 法条知识库（162 部中国法律）
│   ├── references/          # 跨领域共用参照（护栏 / 语义树 / 司法解释）
│   └── solo-law-firm/       # 独立执业技能集（8 科室 27 技能）
├── install.sh / install.ps1 # 安装脚本（Windows + macOS/Linux）
├── update.sh / update.ps1   # 更新脚本
├── uninstall.sh / uninstall.ps1 # 卸载脚本
├── verify.ps1               # 安装完整性验证
├── gen-knowledge-index.ps1  # 法条知识库索引重建
├── QUICKSTART.md            # 快速入门
└── README.md
```
