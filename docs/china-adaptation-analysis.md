# anthropics/claude-for-legal → zhou210712/claude-for-legal-ZH 中国化适配全量分析

> 分析日期：2026-05-24
> 对比对象：anthropics/claude-for-legal（美国法原版）vs zhou210712/claude-for-legal-ZH（中国法适配版）
> 本分析以 zhou210712/claude-for-legal-ZH 为分析对象

---

## 一、总体数据

| 维度 | anthropics | zhou210712 | 变化 |
|------|-----------|-----------|------|
| 技能领域数 | 12 | 12 | 相同 |
| 技能总数 | 150 | 150 | 相同 |
| 子技能目录 | 完全相同 | 完全相同 | 0 变 |
| agents | 按领域分布 | 与 anthropic 相同 | 0 变 |
| SKILL.md 总大小 | 2106 KB | 1486 KB | **缩减 29%** |
| CLAUDE.md 总行数 | 4180 行 | 3599 行 | **缩减 14%** |
| 自有 docs/ 网站 | ❌ | ✅ 17 张图片 + index.html | 新增 |
| 根目录 CLAUDE.md | ✅ 101 行 (开发者指南) | ❌ | 移除 |
| external_plugins/ | ✅ CoCounsel | ❌ | 移除 |
| .github/workflows | ✅ cla.yaml | ❌ | 移除 |

---

## 二、结构变化

### 2.1 移除项

- **根目录 CLAUDE.md** — anthropic 有 101 行的开发者指南（含 CI/验证/市场规范说明），zhou 彻底移除
- **external_plugins/cocounsel-legal** — Thompson Reuters 的 CoCounsel 插件（美国诉讼 AI 工具）
- **.github/workflows/cla.yaml** — 贡献者许可协议签名工作流

### 2.2 新增项

- **docs/** — 完整的产品宣传网站（index.html + 17 张图片资源），用于展示插件的可视化界面
- **每个领域新增 references/ 目录**（共 9 个新增中国法引用文件）

### 2.3 保留项（未做任何修改）

- 12 个领域的**技能目录结构**（150 个子技能名称和目录完全一致）
- **agents/** 定义文件
- **managed-agent-cookbooks/** 目录结构
- **scripts/** 工具脚本
- **CONTRIBUTING.md**、**CODE_OF_CONDUCT.md**
- 通用 `references/company-profile-template.md`、`references/dashboard-template.md`

---

## 三、法律内容替换（核心差异）

### 3.1 新增中国法引用文件（9 个，anthropic 完全没有）

| 领域 | 新增文件 | 行数 | 覆盖内容 |
|------|---------|:----:|---------|
| **commercial-legal** | `contract-law-core.md` | 299 | 民法典合同编（要约承诺、格式条款、违约责任等） |
| **litigation-legal** | `civil-procedure-core.md` | 203 | 民事诉讼法（管辖、诉讼参与人、证据、保全、执行） |
| | `evidence-rules-core.md` | 292 | 民事诉讼证据规则（举证责任分配、三性审查、鉴定） |
| | `enforcement-core.md` | 305 | 强制执行程序（执行依据、执行措施、执行异议） |
| **employment-legal** | `labor-core-rules.md` | 519 | 劳动合同法（劳动关系认定、解除补偿、竞业限制） |
| **corporate-legal** | `company-law-2024-core.md` | 333 | 2024 年新公司法（限期认缴制、出资加速到期、董监高责任） |
| **ip-legal** | `ip-core-rules.md` | 238 | 商标法/专利法/著作权法（注册条件、侵权判定、保护期限） |
| **regulatory-legal** | `admin-law-core.md` | 360 | 行政许可/处罚/强制/复议/诉讼法 |
| **privacy-legal** | `pipil-core-provisions.md` | 266 | 个人信息保护法/数据安全法/网络安全法三法核心条款 |
| **ai-governance-legal** | `ai-governance-core.md` | 305 | 生成式 AI 管理办法/科技伦理审查办法/算法备案规定 |

**这 9 个文件是 zhou210712 最核心的中国化贡献。** 每个文件都包含法条原文、实务要点、案例索引，可被 AI 直接引用。文件格式统一，均以 `[法条原文]` `[本地知识库]` 标签标记来源。

### 3.2 currency-watch.md 重写（时效监测文件）

共 3 个领域有 `currency-watch.md`，其中 2 个相同，1 个完全不同：

| 领域 | anthropic | zhou210712 |
|------|-----------|-----------|
| privacy-legal | 相同 | 相同（通用内容，无需本地化） |
| product-legal | 相同 | 相同 |
| **ai-governance-legal** | **美国各州 AI 法**（Colorado/Texas/Nebraska...）<br>+ EU AI Act<br>+ US Federal (EEOC/FTC) | **中国 AI 法规**（生成式AI办法/算法推荐/深度合成）<br>+ 中国数据三法<br>+ EU AI Act（保留但缩略）<br>+ 新增"中国 AI 配套标准与指南"章节 |

### 3.3 CLAUDE.md 工作流指令修改

每个领域的 `CLAUDE.md` 都经过以下 4 类修改：

#### 类型 A：UI 文字中文化 ✅（有实际价值）

- 标题英译中：`# Commercial Contracts Practice Profile` → `# 商事合同实务画像`
- 冷启动提示：`"This plugin needs setup..."` → `"本插件需要进行初始设置..."`
- 段落注释：`"Shared company profile"` → `"共享公司画像"`
- 节标题：`## Who we are` → `## 我们是谁`

#### 类型 B：文案长度变化（有实际价值）

| 领域 | anthropic | zhou | 变化方向 |
|------|----------|------|---------|
| commercial-legal | 510 行 | 533 行 | +23 行 — 补充中国法内容 |
| employment-legal | 400 行 | 437 行 | +37 行 — 补充中国劳动法 |
| litigation-legal | 586 行 | 547 行 | -39 行 — 精简美国式流程 |
| corporate-legal | 479 行 | 407 行 | -72 行 |
| privacy-legal | 406 行 | 377 行 | -29 行 |
| ip-legal | 396 行 | 319 行 | -77 行 |
| product-legal | 363 行 | 317 行 | -46 行 |
| regulatory-legal | 356 行 | 260 行 | -96 行 |
| ai-governance-legal | 480 行 | 358 行 | -122 行 |

#### 类型 C：冷启动简介（cold-start-interview）大幅缩减 ⚠️

所有领域的 cold-start-interview 技能均大幅缩小：

| 领域 | anthropic | zhou | 缩减 |
|------|----------|------|:----:|
| commercial-legal | 48 KB | 9 KB | 81% |
| litigation-legal | 47 KB | 8 KB | 83% |
| corporate-legal | 41 KB | 37 KB | 10% |
| employment-legal | 31 KB | 16 KB | 48% |
| ai-governance-legal | 47 KB | 15 KB | 68% |
| law-student | 28 KB | 20 KB | 29% |

#### 类型 D：关键技能缩水 ⚠️

| 技能 | anthropic | zhou | 缩减 | 影响 |
|------|----------|------|:----:|------|
| claim-chart （诉请分析） | 40 KB | 11 KB | 73% | 精简了美国式诉请分析框架 |
| cease-desist （律师函） | 37 KB | 12 KB | 68% | 精简了美国式 cease & desist 模板 |
| takedown （通知-删除） | 31 KB | 8 KB | 74% | 适配中国《民法典》通知规则 |
| saas-msa-review （SaaS 审查） | 21 KB | 6 KB | 71% | 精简了美国 SaaS 特有条款 |
| demand-draft （律师函起草） | 25 KB | 6 KB | 76% | 大幅精简 |

---

## 四、MCP 连接器替换

### 4.1 完整替换清单

所有 12 个领域的 `.mcp.json` 均不同。以 commercial-legal 为例：

| anthropic（美国生态） | zhou210712（中国生态） |
|---------------------|----------------------|
| Ironclad（合同管理） | **e签宝**（电子签名） |
| DocuSign（电子签名） | **法大大**（电子签名） |
| iManage（文档管理） | **飞书**（协作） |
| TopCounsel（外律推荐） | **元典/yuandian**（中国法检索） |
| Definely（合同分析） | —（未替换） |
| Slack | Slack（保留） |
| Google Drive | Google Drive（保留） |

### 4.2 CONNECTORS.md 完整重写

从英文的 "How to add connectors to US legal tools" 改为中文的 "如何提交中国法律连接器"，推荐的中国法律数据源包括：

- 元典（法律法规与案例检索）
- 北大法宝
- 威科先行
- 国家知识产权局
- 中国政府网法律法规数据库
- 聚法案例

---

## 五、marketplace.json 元数据替换

| 维度 | anthropic | zhou210712 |
|------|-----------|-----------|
| 市场名 | `claude-for-legal` | `claude-for-legal-zh` |
| 所有者 | Anthropic | **陈石 律师** |
| displayName | 英文（e.g. "Commercial Legal"） | ❌ 移除 displayName |
| 描述 | 英文（美国法语境） | **中文 + 明确标注中国法适配** |
| $schema | ✅ 有 schema 引用 | ❌ 移除 schema |

每条描述的翻译都附加了中国法律依据：

- commercial-legal 描述追加：`适配中国民法典合同编及商事实践`
- privacy-legal 描述追加：`适配个人信息保护法、数据安全法、网络安全法`
- corporate-legal 描述追加：`适配中国公司法、证券法`
- 依次类推全部 12 个领域

---

## 六、内容未覆盖的领域

### 6.1 哪些 SKILL.md 保留了英文原文？

少量技能文件仍保留英文指令，未做中文化。这些主要是技术/通用技能：

| 技能 | 原因 |
|------|------|
| customize | 配置引导，通用 |
| auto-updater | 纯技术操作 |
| matter-workspace | 工作空间管理，通用 |

### 6.2 哪些内容未被中国法替换？

- 工作流框架（Playbook 结构、Escalation 流程、House style）保留原英文框架
- 但新增了中国法引用作为底层数据源

---

## 七、总结

### 适配深度评级

| 适配层次 | 深度 | 说明 |
|---------|:----:|------|
| 法条引用 | ⭐⭐⭐ | 9 个中国法文件，覆盖民法典/公司法/劳动法等核心法律 |
| MCP 连接器 | ⭐⭐⭐ | 全部替换为中国法律数据源和办公工具 |
| 元数据 | ⭐⭐⭐ | marketplace 描述全部中文化并标注法律依据 |
| UI 界面 | ⭐⭐ | 标题/提示/注释中文化，但深层框架保留英文 |
| SKILL 内容 | ⭐⭐ | 部分技能大幅精简，但工作逻辑框架保留原结构 |
| AI 治理 | ⭐ | currency-watch 重写为中国 AI 法规，但工作流保持原框架 |

### 核心结论

1. **最大的贡献：9 个中国法 references 文件**。这是 zhou210712 最具价值的部分，为 AI 提供了可直接引用的中国法原文和实务要点。

2. **工作流框架未改动**。审查流程、升级机制、质量检查等"怎么做"的部分保留了 anthropic 的框架，只替换了"依据什么"的法律内容。

3. **技能内容整体缩减 29%**。cold-start interview 大幅缩小，部分技能（claim-chart, cease-desist）精简超过 70%。部分缩减是合理的（去掉美国特有内容），但部分可能丢失了有价值的质量控制细节。



