---
name: claude-legal-cn
description: >
  中国法律工作总入口。自动识别律师工作场景并路由到对应领域技能。
  每次启用时自动检查上游更新，静默同步。
version: 2.9.0
module: claude-legal-cn
status: active
---

# claude-legal-cn

## 自动更新

每次执行法律任务前，检查本地上游仓库是否有更新并同步。

查找顺序：
1. ~/.codex/vendor/claude-for-legal-CN/（install.ps1 创建的缓存）
2. ../claude-for-legal-CN/（本仓库同级目录）

找到后执行 git pull，同步 CLAUDE.md 和 references 到 ~/.codex/skills/。
静默执行，不影响对话。

## 自动路由规则

当用户以 \@claude-legal-cn\ 触发或输入法律任务关键词时，按以下规则选择技能文件：

### 匹配后执行
1. 匹配关键词 -> 确定目标技能路径
2. 读取目标 SKILL.md（如为 claude-for-legal 域技能，还需读取同目录 CLAUDE.md 和 references/）
3. 按照目标技能的工作原则和输出格式执行任务

### claude-for-legal 路由表
| 关键词 | 加载路径 |
|---|---|
| 诉讼、仲裁、执行、保全、证据、代理词 | \~/.codex/skills/litigation-legal/\ |
| 合同审查、违约、补充协议、函件 | \~/.codex/skills/commercial-legal/\ |
| 公司、股权、投资、尽调、并购 | \~/.codex/skills/corporate-legal/\ |
| 劳动、社保、解除、竞业、规章制度 | \~/.codex/skills/employment-legal/\ |
| 隐私、个保法、数据、出境 | \~/.codex/skills/privacy-legal/\ |
| 产品上线、营销合规、广告法 | \~/.codex/skills/product-legal/\ |
| 监管、合规跟踪、政策变化 | \~/.codex/skills/regulatory-legal/\ |
| AI治理、算法、伦理审查 | \~/.codex/skills/ai-governance-legal/\ |
| 商标、专利、著作权、侵权 | \~/.codex/skills/ip-legal/\ |
| 法考、案例学习、法律学习 | \~/.codex/skills/law-student/\ |
| 法律诊所、法律援助 | \~/.codex/skills/legal-clinic/\ |
| 技能安装、技能管理 | \~/.codex/skills/legal-builder-hub/\ |

### solo-law-firm 路由表（自包含技能，无需 CLAUDE.md）
| 关键词 | 部门 | 加载路径（示例） |
|---|---|---|
| 合同审查 | 01-case-practice | \~/.codex/skills/solo-law-firm/01-case-practice/contract-reviewer/SKILL.md\ |
| 法律检索、法条、请求权 | 01-case-practice | \~/.codex/skills/solo-law-firm/01-case-practice/legal-research-expert/SKILL.md\ |
| 诉讼策略、攻防、起诉 | 01-case-practice | \~/.codex/skills/solo-law-firm/01-case-practice/litigation-strategist/SKILL.md\ |
| 文书、起诉状、答辩状 | 01-case-practice | \~/.codex/skills/solo-law-firm/01-case-practice/legal-document-drafter/SKILL.md\ |
| 证据、质证、证据链 | 01-case-practice | \~/.codex/skills/solo-law-firm/01-case-practice/evidence-analyst/SKILL.md\ |
| 排期、开庭、庭前 | 02-case-management | \~/.codex/skills/solo-law-firm/02-case-management/trial-preparation-checker/SKILL.md\
| 开庭提纲、庭审提纲、庭前准备 | 02-case-management | \~/.codex/skills/solo-law-firm/02-case-management/trial-outline-generator/SKILL.md\ |
| 时效、诉讼时效 | 02-case-management | \~/.codex/skills/solo-law-firm/02-case-management/deadline-monitor/SKILL.md\ |
| 案件排期、日程 | 02-case-management | \~/.codex/skills/solo-law-firm/02-case-management/case-scheduler/SKILL.md\ |
| 初次咨询、接案、案情 | 03-client-relations | \~/.codex/skills/solo-law-firm/03-client-relations/initial-consultation/SKILL.md\ |
| 客户沟通、进展通报、风险告知 | 03-client-relations | \~/.codex/skills/solo-law-firm/03-client-relations/client-communication-drafter/SKILL.md\ |
| 回访、满意度、二次转化 | 03-client-relations | \~/.codex/skills/solo-law-firm/03-client-relations/satisfaction-surveyor/SKILL.md\ |
| 企业背调、工商、信用 | 04-due-diligence | \~/.codex/skills/solo-law-firm/04-due-diligence/corporate-background-investigator/SKILL.md\ |
| 股权穿透、股权结构 | 04-due-diligence | \~/.codex/skills/solo-law-firm/04-due-diligence/equity-penetration-analyst/SKILL.md\ |
| 诉讼风险、涉诉、被告记录 | 04-due-diligence | \~/.codex/skills/solo-law-firm/04-due-diligence/litigation-risk-scanner/SKILL.md\ |
| 资产线索、财产保全、可执行 | 04-due-diligence | \~/.codex/skills/solo-law-firm/04-due-diligence/asset-trace-investigator/SKILL.md\ |
| SEO、搜索优化、关键词 | 05-business-development | \~/.codex/skills/solo-law-firm/05-business-development/seo-optimizer/SKILL.md\ |
| 公众号、法律科普长文 | 05-business-development | \~/.codex/skills/solo-law-firm/05-business-development/wechat-article-creator/SKILL.md\ |
| 小红书、知乎、图文科普 | 05-business-development | \~/.codex/skills/solo-law-firm/05-business-development/social-media-legal-popularizer/SKILL.md\ |
| 短视频、抖音、口播 | 05-business-development | \~/.codex/skills/solo-law-firm/05-business-development/short-video-planner/SKILL.md\ |
| 收费、报价、律师费 | 06-finance-admin | \~/.codex/skills/solo-law-firm/06-finance-admin/fee-strategy-consultant/SKILL.md\ |
| 利润、ROI、时薪、赚钱 | 06-finance-admin | \~/.codex/skills/solo-law-firm/06-finance-admin/profit-accountant/SKILL.md\ |
| 催收、账单、发票、欠款 | 06-finance-admin | \~/.codex/skills/solo-law-firm/06-finance-admin/invoice-collection-specialist/SKILL.md\ |
| 模板、脱敏、文书模板化 | 07-knowledge-management | \~/.codex/skills/solo-law-firm/07-knowledge-management/case-template-refiner/SKILL.md\ |
| 法官偏好、法官画像、裁判风格 | 07-knowledge-management | \~/.codex/skills/solo-law-firm/07-knowledge-management/judge-preference-analyst/SKILL.md\ |
| 法规动态、法规监控、新法 | 07-knowledge-management | \~/.codex/skills/solo-law-firm/07-knowledge-management/regulatory-change-monitor/SKILL.md\ |
| 利冲、利益冲突 | 08-risk-compliance | \~/.codex/skills/solo-law-firm/08-risk-compliance/conflict-checker/SKILL.md\ |

### 路由优先级
1. 精确匹配：关键词直接命中特定技能 -> 加载该技能
2. 模糊匹配：关键词命中多个技能 -> 加载最相关的前 2 个，让用户确认
3. 无匹配：默认加载根技能上下文，询问用户需求

## Rule Runtime（强制执行 — 最高优先级）

本节的规则优先于所有领域技能指令，不可被覆盖。

### 推理链锁定
- 任务开始后，必须从目标领域加载 `references/reasoning-template-zh.md`
- 禁止使用 IRAC（Issue-Rule-Application-Conclusion）结构
- 民商事领域：强制使用请求权基础分析法
- 行政法规领域：强制使用行政行为合法性审查框架
- 推理链一经加载，不得降级为通用推理模式

### 阻断概念实时过滤
- 输出前逐条扫描 29 项阻断清单（`patches/guards/blocking-list.md`）
- 命中 ❌ 标记的概念 → 立即替换为中国法等效制度或删除
- 命中"替换为"标记的概念 → 强制替换，不得保留原文
- 禁止引用 Delaware 公司法、美国州法、英国法、香港法等境外法域依据

### 输出自检（每次输出末尾强制执行）
在每次法律分析输出末尾，静默执行以下检查，发现违规则在输出末尾附加修正：

```
[Rule Runtime 自检]
✅ 推理链: 已使用 [请求权基础分析法/行政行为合法性审查/...] | ❌ 未使用指定推理链 → 立即重写
✅ 阻断概念: 未检出 | ❌ 检出 [概念名] → 已替换为 [中国法等效]
✅ 境外法域引用: 无 | ❌ 检出 [法域名] → 已删除
✅ 法条引用: [具体条目] | ❌ 笼统引用 → 已补充条目号
```

自检结果以折叠形式附加在输出末尾，用户可见。
如有任何 ❌ 项，必须修正后重新自检，直到全部 ✅ 才能结束任务。

## MCP 连接器

技能预配置了两个中国法律 MCP 连接器（在 ~/.codex/config.toml 的 [mcp_servers] 段）：

- **chineselaw（推荐）**：33 个工具，覆盖法规检索、案例检索、企业信息查询
- **北大法宝（备选）**：10 个专用 MCP 服务

使用法律检索任务时优先调用已配置的 MCP 连接器获取当前有效法条和案例。
如未找到已启用的 MCP 连接器，基于模型训练数据工作，引用标注 [需验证]。

## 工作流程

1. 执行自动更新
2. 判定任务是否属于法律工作流程
3. 检查 MCP 连接器状态（config.toml 的 [mcp_servers] 段）
4. 选择最匹配的领域模块
5. 读取该模块 SKILL.md + CLAUDE.md + references
6. **【强制执行】加载领域推理模板**：读取目标领域的 `references/reasoning-template-zh.md`，将其中定义的推理结构作为本次任务的唯一合法推理框架
7. **【强制执行】加载阻断清单**：读取 `patches/guards/blocking-list.md`，将 29 项阻断概念载入当前上下文，标记为禁止输出项
8. 如有可用 MCP 连接器，优先通过 MCP 检索当前有效法条和案例
9. 法规、案例须核验现行有效性

## 重要限制

- 所有输出均为律师审查草稿，不构成法律意见
- 引用法规须核验现行有效性
- 提交/发送前需经执业律师审核
## solo-law-firm 技能集（自包含）

本仓库同时内置了 [saysoph/solo-law-firm-agents](https://github.com/saysoph/solo-law-firm-agents) 的 26 个独立执业技能（修改版），覆盖 8 个部门。
这些技能是**自包含的厚 SKILL.md**，不依赖上游 CLAUDE.md，安装即用。

### solo-law-firm 部门
| 部门 | 技能数 | 核心职能 |
|------|:------:|------|
| 01-案件实务部 | 5 | 合同审查、法律检索、诉讼策略、文书撰写、证据分析 |
| 02-案件管理部 | 4 | 案件排期、时效监控、庭前准备 |
| 03-客户关系部 | 3 | 初次咨询、沟通起草（含进展通报）、满意度回访 |
| 04-尽职调查部 | 4 | 企业背调、股权穿透、诉讼风险排查、资产线索追踪 |
| 05-市场拓展部 | 4 | SEO优化、公众号、小红书/知乎、短视频策划 |
| 06-财务行政部 | 3 | 收费策略、利润核算、发票与催收 |
| 07-知识管理部 | 3 | 案例模板脱敏、法官偏好分析、法规动态监控 |
| 08-风控合规部 | 1 | 利益冲突排查 |

使用时直接触发对应关键词，或在对话中引用 `@solo-law-firm` 访问全部技能。
