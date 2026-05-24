# 技能对照索引

本文档对照 [claude-for-legal-CN](https://github.com/zhou210712/claude-for-legal-ZH) 领域技能与 [solo-law-firm-agents](https://github.com/saysoph/solo-law-firm-agents) 执业技能，帮助快速定位适用技能。

> 🆕 **本仓库自研技能**以 🆕 标记，这些技能在上游 saysoph/solo-law-firm-agents 中不存在，由本仓库独立研发补全。

## 一、两套体系定位

| 体系 | 来源 | 技能数 | 架构 | 适用场景 |
|------|------|:------:|------|------|
| **claude-for-legal-CN** | zhou210712 上游 | 12 领域 / 150+ 子技能 | 薄入口 + CLAUDE.md 工作流 + references 法条库 | 各法律领域的专业分析、审查、起草 |
| **solo-law-firm-agents** | saysoph 上游（修改版 + 自研） | 27 独立技能 / 8 部门 | 自包含厚 SKILL.md + 模板 + 禁止项 | 独立执业律师的端到端业务运营 |

## 二、按场景选择技能

### 诉讼仲裁

| 你的需求 | claude-for-legal-CN | solo-law-firm |
|------|------|------|
| 法条检索、请求权基础 | `litigation-legal` | `legal-research-expert` |
| 证据分析、质证意见 | `litigation-legal` | `evidence-analyst` |
| 策略设计、攻防方案 | `litigation-legal` | `litigation-strategist` |
| 起诉状/答辩状起草 | `litigation-legal` | `legal-document-drafter` |
| 🆕 开庭提纲自动生成 | — | `trial-outline-generator` |
| 庭前准备核查 | — | `trial-preparation-checker` |
| 案件排期管理 | — | `case-scheduler` |
| 诉讼时效监控 | — | `deadline-monitor` |
| 法官裁判偏好分析 | — | `judge-preference-analyst` |

### 商事合同

| 你的需求 | claude-for-legal-CN | solo-law-firm |
|------|------|------|
| 合同审查（通用） | `commercial-legal` | `contract-reviewer` |
| 交易文件起草 | `commercial-legal` | `legal-document-drafter` |
| 知识产权条款审查 | `ip-legal` | `contract-reviewer` |

### 公司/尽调

| 你的需求 | claude-for-legal-CN | solo-law-firm |
|------|------|------|
| 并购尽调 | `corporate-legal` | — |
| 企业工商背调 | — | `corporate-background-investigator` |
| 股权穿透分析 | — | `equity-penetration-analyst` |
| 涉诉风险排查 | — | `litigation-risk-scanner` |
| 可执行财产追踪 | — | `asset-trace-investigator` |

### 客户与经营（solo-law-firm 独有）

| 你的需求 | 技能 |
|------|------|
| 初次咨询接待、案情摘要 | `initial-consultation` |
| 客户沟通（含进展通报） | `client-communication-drafter` |
| 结案回访、二次转化 | `satisfaction-surveyor` |
| 利冲排查 | `conflict-checker` |
| 收费方案设计 | `fee-strategy-consultant` |
| 单案盈利分析 | `profit-accountant` |
| 账单与催收 | `invoice-collection-specialist` |

### 市场拓展（solo-law-firm 独有）

| 你的需求 | 技能 |
|------|------|
| SEO 关键词优化 | `seo-optimizer` |
| 公众号法律科普长文 | `wechat-article-creator` |
| 小红书/知乎图文笔记 | `social-media-legal-popularizer` |
| 抖音/视频号口播脚本 | `short-video-planner` |

### 知识管理

| 你的需求 | claude-for-legal-CN | solo-law-firm |
|------|------|------|
| 文书模板化/脱敏 | — | `case-template-refiner` |
| 法规变动监控 | — | `regulatory-change-monitor` |
| 监管合规跟踪 | `regulatory-legal` | — |

## 三、推荐组合使用

对于独立执业律师，建议两套体系协同：

```
接案阶段:
  solo-law-firm: initial-consultation → conflict-checker → fee-strategy-consultant

办案阶段:
  solo-law-firm: legal-research-expert → evidence-analyst → litigation-strategist
  claude-for-legal-CN: litigation-legal (补充法条库和 references)

庭前阶段:
  solo-law-firm: trial-outline-generator → trial-preparation-checker

文书阶段:
  solo-law-firm: legal-document-drafter
  claude-for-legal-CN: litigation-legal (补充 CLAUDE.md 工作流)

结案阶段:
  solo-law-firm: profit-accountant → satisfaction-surveyor → case-template-refiner

持续运营:
  solo-law-firm: seo-optimizer / wechat-article-creator / regulatory-change-monitor
```

## 四、技能总数

| 体系 | 入口技能 | 子技能/独立技能 | 合计 |
|------|:------:|:------:|:------:|
| claude-for-legal-CN | 13 (含根路由) | 150+ (上游) | 163+ |
| solo-law-firm（saysoph 原创） | 1 (solo-law-firm) | 26 (自包含) | 26 |
| 🆕 solo-law-firm（本仓库自研） | — | 1 (自包含) | 1 |
| **本仓库合计** | **14** | **177+** | **190+** |

## 五、本仓库自研技能清单

| 技能 | 部门 | 说明 | 填补的空白 |
|------|------|------|------|
| 🆕 `trial-outline-generator` | 02-案件管理部 | 五阶段流水线生成标准化开庭提纲，6 板块输出 | 补齐证据分析→庭前核查之间缺少的开庭发言准备环节 |
