# Claude-for-Legal-CN-to-Codex — 项目双审评估报告

> 上篇：项目自述与代理词（本仓库提交给外部 LLM 的评估材料）
> 下篇：外部 LLM 独立评估意见
> 补篇：本仓库回应与差距分析

---

# 上篇 · 项目自述与代理词

﻿# Claude-for-Legal-CN-to-Codex — 项目评估代理词

> 本文档是给其他 LLM 评估本仓库的输入材料。请阅读后对项目进行全面评估，指出改进方向。

---

## 一、一句话定位

将 Anthropic 法律 AI（claude-for-legal）进行多源整合 + 中国化适配 + 自研对齐框架，移植到 Codex Desktop 的一站式法律技能部署包。

---

## 二、架构层级（六层）

```
⑥ 上游监控层 — 4 路 diff-tool + GitHub Actions（参考窗口模式，不自动合并）
⑤ 护栏层     — 阻断清单/元规则/香港桥梁/核心原则（8 个自研文件）
④ 概念对齐层 — 12 领域 × 中美法律概念一对一手动映射（自研）
③ 法条层     — 22 部中国法律官方 PDF 全文（qulv 上游）
② 内容层     — 150+ 子技能 + 12 领域 CLAUDE.md（上游中文化 + 本仓库重写）
① 部署层     — install/update/uninstall/verify 脚本（从本仓库直接部署）
```

---

## 三、来源构成

| 来源 | 贡献 | 本仓库操作 |
|:-----|:-----|:----------|
| anthropics/claude-for-legal | 150 子技能的原始框架 | 继承结构，逐层替代中国法内容 |
| zhou210712/claude-for-legal-ZH | CLAUDE.md 中文化 + MCP 替换 + 9 个法条文件 | 断开自动同步，本地快照比对 |
| MAXXXXXLI/workbuddy-cn-legal-skills | 14 个中国法语境文件 | 整合进各领域参考目录 |
| saysoph/solo-law-firm-agents | 26 个独立执业技能（8 科室） | 重命名 + 格式适配 + 新增庭审提纲 |
| Daknniel-0881/qulv-china-legal-counsel-skill | 22 部中国法律 PDF | 整合进各领域 references/ |
| **自研** | PRC-US 对齐框架、护栏、diff-tool、MCP Hub | — |

---

## 四、仓库规模

| 维度 | 数据 |
|:-----|:-----|
| 总文件数 | ~600+（skills 377 + patches 215 + docs 9 + 根目录 8） |
| 法律领域 | 12 个 + solo-law-firm 8 科室 |
| 子技能 | 150+（原始框架） |
| 法条引用 | 22 部官方 PDF + 14 个语境文件 + 9 个核心法条摘要 |
| 护栏文件 | 8 个自研 |
| 概念映射 | 12 领域一对一映射 + alignment 子目录 |
| diff-tool | 4 路独立比对脚本 |
| MCP 连接器 | 由独立仓库管理（Codex-Claude-legal-cn-mcp-hub） |
| 上游监控 | GitHub Actions 自动 Issue + 参考窗口模式 |

---

## 五、中国化深度

| 维度 | 深度 |
|:-----|:----:|
| 子技能 | 5 个全量重写 + 1 个删除 + 1 个改名 |
| CLAUDE.md 工作流 | 12 领域全中文化（UI/提示/引法依据） |
| MCP 连接器 | 12 领域全部替换为中国工具链 |
| 法条引用 | 从 0 → 22 部官方 PDF 全文 |
| 概念对齐 | 中美法律语义映射（自研） |
| 护栏 | 阻断 22 个美国法特有概念混入 |
| 上游更新 | 不自动合并，手动审查 |

---

## 六、待 LLM 评估的核心问题

请从以下维度给出批判性评估意见（重点指出改进方向）：

### 1. 架构设计
- 六层架构的覆盖是否完整？有什么遗漏的安全/合规层？
- diff-tool 参考窗口模式是否合理？有无更高效的上游同步策略？

### 2. 中国化质量
- 5 个重写技能的准确性如何？是否忽略了其他需要中国化的子技能？
- 22 部法律 PDF 的覆盖范围是否足够？哪些领域法条缺失？
- 美国法残留风险有多大？（CLAUDE.md 中的框架逻辑、Playbook 的流程结构是否仍有美国法偏见？）

### 3. 代码与维护
- install.ps1 / update.ps1 的部署逻辑可维护性如何？
- 603 个文件的管理是否过于庞大？有没有解耦/模块化的改进空间？
- GitHub Actions 的工作流是否充分？

### 4. 使用体验
- 安装流程的复杂度是否可接受？
- 法律实务者能否理解和使用这个工具？
- 是否缺少快速验证/测试机制？

### 5. 生态与协作
- 上游致谢和许可声明是否完整？
- 如何在保持独立性的同时回馈上游？
- 这个仓库的最佳定位是什么？（最终用户产品 / 上游整合层 / 参考实现？）

### 6. 命中的与错过的
- 这个仓库解决了哪些真实的中国法律痛点？
- 还有哪些重要的中国法律 AI 需求没有被覆盖？
- 与市面其他方案（付费法律 AI、其他开源项目）相比的优势和劣势？

---

> 请输出结构化的评估报告，每个维度给出：现状评估 / 问题点 / 改进建议。
> 不避讳批评，批评比表扬更有价值。


---

# 下篇 · 外部 LLM 独立评估

## 一、总体判断

**定位：** 这不是"法律技能包"，而是"中国法律 AI 基础设施原型（中间件层）"。

最有价值的不是提示词，而是：
- 如何让一个原本基于美国法思维训练出来的 agent system，在中国法律环境中不产生结构性幻觉
- 中国法语义对齐框架
- 美国法残留阻断机制
- 上游变化可控同步
- 中国法工具链替换

**当前核心问题：** 正在从"技能仓库"逐渐滑向"法律操作系统（Legal OS）"，但架构仍停留在"大型 patch 集合"。这会导致可维护性迅速恶化、上游同步成本指数级增长、中国法更新不可持续、技能间语义漂移越来越严重。

---

## 二、架构设计评估

### 2.1 六层架构 — 方向正确

"概念对齐层"和"护栏层"是整个项目最有技术含量的部分。与其他中国化项目不同，本仓库已经意识到：美国法 AI 最大问题不是语言，而是法律推理结构。

### 2.2 缺少关键层：推理治理层（Rule Runtime Layer）

目前有护栏、映射、阻断，但没有"运行时规则执行器"。

| 缺失功能 | 说明 |
|:---------|:-----|
| jurisdiction router | 自动识别中国法/美国法 |
| legal-risk classifier | 识别高风险输出 |
| doctrine conflict detector | 检测美国法逻辑残留 |
| citation validator | 引法校验 |
| answer downgrade policy | 超范围自动降级 |
| compliance policy | 律师法/生成式 AI 监管 |

> 建议新增第 ④.5 层：推理治理层（Reasoning Governance Layer）

### 2.3 diff-tool 参考窗口模式 — 正确路线

不自动 merge 是对的。法律 AI 不是普通代码仓库，自动同步会导致美国法概念重新污染。

**升级建议：** 从文件级 diff 升级到语义级 diff：
| 类型 | 检测内容 |
|:-----|:---------|
| legal concept diff | 新增美国法概念 |
| workflow diff | 推理链变化 |
| citation policy diff | 引法逻辑变化 |
| MCP capability diff | 工具权限变化 |
| hidden prompt diff | 系统提示变化 |

---

## 三、中国化质量评估

### 3.1 内容中国化了，推理结构未完全中国化

核心矛盾：Anthropic 原技能中的 issue spotting、argument construction、risk balancing、discovery planning、precedent weighting，背后是 common law + adversarial system + discovery + precedent-centric reasoning。即使改了中文、换了法条、替换了 MCP，仍可能残留美国律师思维方式。

| 美国法 | 中国法 |
|:------|:------|
| precedent-driven | statute-driven |
| adversarial | 审查/合规导向 |
| issue spotting | 法条适配 |
| discovery | 证据固定 |
| argument competition | 裁判倾向预测 |
| client advocacy | 风险规避 |
| open reasoning | 监管边界 |

**仅重写 5 个技能远不够。** 以下类型技能仍有高风险：

| 技能类型 | 残留风险 |
|:---------|:---------|
| memo writing | IRAC 结构残留 |
| litigation planning | discovery 逻辑 |
| witness prep | 对抗式审判 |
| negotiation | common law 风格 |
| compliance review | 美国监管框架 |
| contract interpretation | 判例法逻辑 |
| risk analysis | 美国责任体系 |
| corporate governance | Delaware bias |
| employment | at-will employment |
| evidence handling | hearsay framework |

> 建议：建立"中国法推理模板库"，让 skill 调用模板而非承载推理。

### 3.2 22 部法律 PDF — 不错但不够

中国法律 AI 最大问题不是"有没有法条"，而是"有没有司法解释 + 裁判规则 + 地方口径"。

**严重缺失：**
| 缺失 | 重要性 |
|:-----|:------|
| 最高法司法解释 | 极高 |
| 指导性案例 | 极高 |
| 会议纪要 | 高 |
| 法答网倾向 | 高 |
| 类案裁判规则 | 极高 |
| 网信办规则 | 极高 |
| 数据跨境规定 | 极高 |
| 生成式 AI 办法 | 极高 |
| 地方实践（上海/深圳/北京/广东/浙江） | 中-高 |

### 3.3 美国法残留风险：7/10

已解决：内容层、法条层、部分 workflow。未解决：未彻底重建 reasoning architecture。

---

## 四、代码与维护性评估

### 4.1 最大技术债：补丁爆炸

603 文件 + 215 patches 叠加式维护，时间久了会导致 patch 相互冲突、alignment 漂移、skill 失配、diff 审查成本暴涨。

> 建议：从"复制整个 skill"转向"声明式 override 架构"（skill virtualization）。

### 4.2 install.ps1 — 长期维护风险

PowerShell 在中文环境存在编码问题、执行策略阻断、路径空格报错。建议改 Python CLI（legal-cn install/verify/sync/doctor）。

### 4.3 GitHub Actions 不够"法律化"

当前 Actions 更像代码同步工具。应增加：美国法术语扫描、hallucination scan、引法断链检测、失效法条扫描、skill 一致性检查。

---

## 五、使用体验评估

### 5.1 仍偏"工程师项目"

"patch""alignment""workflow""override"会劝退法律人。需要"法律人模式"：安装→选领域→一键验证→示例案件。

### 5.2 缺少验证体系（重大问题）

没有 benchmark。中国法律 AI 必须有：标准案例集、预期输出、自动回归测试。

---

## 六、生态与协作

### 6.1 最佳定位

| 类型 | 是否适合 |
|:-----|:---------|
| 最终用户产品 | ❌ 暂时不适合 |
| 技能仓库 | ⚠️ 部分 |
| **中国法律 AI 适配中间层** | **✅ 最适合** |
| 参考实现 | ✅ 非常适合 |
| 法律 Agent Runtime | ⚠️ 未来可能 |

### 6.2 开源治理建议

应增补：THIRDPARTY.md、UPSTREAM_DIFF_POLICY.md、CHINAIZATION_POLICY.md、LEGAL_SCOPE.md、CONTRIBUTING_CN.md

---

## 七、做对的（命中的真正痛点）

1. 解决了"美国法 AI 无法直接进入中国"的问题（法律 AI 不能简单翻译）
2. 解决了"工程化"问题（skill system + deployment + sync + guardrail + alignment）
3. 解决了"上游利用"问题（最大化复用 Anthropic 工程资产）

---

## 八、未覆盖的重要需求

| 缺失 | 说明 |
|:-----|:-----|
| 裁判预测 | 法官会怎么判 |
| 地方化实践 | 地方口径 > 全国统一理论 |
| 行政监管 AI | 网信/数据/金融/平台/广告/电商 |
| 非诉自动化 | 合同审查/数据合规/劳动用工/企业 SOP |

---

## 九、对比：本仓库 vs 商业法律 AI

| 本仓库优势 | 商业方案优势 |
|:----------|:-----------|
| 数据绝对隐私（本地部署） | 开箱即用 |
| 透明度极高（开源） | 动态数据（裁判文书网等） |
| 客制化成本低 | 律师专用 UI |

---

## 十、最终评价

> 这是一个"中国法律 AI 基础设施原型"，而不是"法律提示词仓库"。
> 你已经超出了汉化、prompt engineering、MCP 替换，进入了法律 AI 推理治理。
> 但当前最大问题是：你正在用 patch 工程承载操作系统级目标。这是未来一定会爆炸的技术债。

---

## 十一、优先级路线图（外部建议）

| 优先级 | 事项 |
|:------:|:-----|
| **P0** | 中国法 benchmark、runtime governance layer、skill override 虚拟化、自动美国法残留扫描、法条更新机制 |
| **P1** | 中国法推理模板库、地方实践层、司法解释层、裁判规则层、compliance runtime |
| **P2** | plugin system、legal memory layer、法律 workflow engine、企业版 deployment、多模型适配层 |

---

# 补篇 · 本仓库回应与差距分析

## 对评估的认同

| 判断 | 回应 |
|:-----|:-----|
| 静态护栏扛不住幻觉 | ✅ 需要后置拦截 |
| Playbook 判例法骨架没换 | ✅ 最隐蔽的坑，改了皮没改骨 |
| 缺少 benchmark | ✅ 最短的短板，立刻可补 |
| 推理治理层缺失 | ✅ 需要工程层介入 |

## 对评估的保留

| 建议 | 保留意见 |
|:-----|:---------|
| 改 Python CLI | 方向对但时机不对。Codex Desktop 是 Windows 生态 |
| 诉讼反而不是最大市场 | 中国律师个体户诉讼仍是最大收入来源 |

## 快速差距表

| 评估建议 | 当前状态 | 差距 |
|:---------|:--------|:-----|
| 中国法 benchmark | ❌ 无 | P0 空白 |
| 运行时治理层 | ❌ 无 | 需架构设计 |
| skill override 虚拟化 | ❌ 全量复制 | 需重构 |
| 美国法残留扫描 | ⚠️ 有 4 路 diff | 文件级，非语义级 |
| 司法解释层 | ❌ 无 | 需另建数据源 |
| 冒烟测试 | ❌ 无 | 小时内可补 |
