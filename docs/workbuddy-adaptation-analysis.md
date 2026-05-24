# MAXXXXXLI/workbuddy-cn-legal-skills → anthropics/claude-for-legal 对比分析

> 分析日期：2026-05-24
> 对比对象：anthropics/claude-for-legal（美国法原版）vs MAXXXXXLI/workbuddy-cn-legal-skills（WorkBuddy 中国法版）

---

## 一、结论先行

**MAXXXXXLI 做的不是"改写"而是"包裹"——在 anthropic 原版内容外面套了一层中国语境壳。**

| 对比项 | 说明 |
|--------|------|
| 平台 | **WorkBuddy（豆包）**——不是 Claude Code，不是 Codex |
| 格式 | 151 个 ZIP 压缩包，每个是一个独立可导入 skill |
| 文件数 | 151 ZIP × 2-5 个文件 = ~500+ 文件（压缩包内） |
| 总大小 | ~4 MB（ZIP 压缩后）|
| 上游 | 直接来自 anthropics/claude-for-legal |
| 中国化方式 | **叠加式适配**——保留英文原文，在前面加中文语境说明 |

---

## 二、仓库结构

```
workbuddy-cn-legal-skills/
├── README.md                使用说明（中文，3022 字节）
├── LICENSE                  Apache 2.0（保留原版）
├── NOTICE                   改编来源说明（1241 字节）
├── docs/images/import-flow/ 导入教程截图（2 张 PNG）
└── 可导入技能包/             151 个 ZIP 技能包
    ├── 商事合同法务-保密协议审查.zip
    ├── 商事合同法务-供应商合同审查.zip
    ├── 争议解决法务-事实时间线.zip
    ├── ...（共 151 个）
```

---

## 三、151 个技能分类

| 类别（中文） | 对应 anthropic 领域 | 技能数 |
|-------------|-------------------|:-------:|
| **商事合同法务** | commercial-legal | 12 |
| **争议解决法务** | litigation-legal | 19 |
| **劳动用工法务** | employment-legal | 20 |
| **数据合规与个人信息保护** | privacy-legal | 9 |
| **公司与交易法务** | corporate-legal | 13 |
| **知识产权法务** | ip-legal | 12 |
| **产品合规法务** | product-legal | 7 |
| **监管合规法务** | regulatory-legal | 9 |
| **人工智能治理法务** | ai-governance-legal | 10 |
| **技能治理中心** | legal-builder-hub | 10 |
| **法律诊所－法律援助** | legal-clinic | 16 |
| **中国法学习** | law-student | 13 |
| **中国法律检索** | —（新增） | 1 |
| **合计** | **12 领域 → 13 类别** | **151** |

新增 1 个中国特有类别：**中国法律检索**（anthropic 没有的独立技能）

---

## 四、中国化适配的 6 层工作

### 4.1 平台迁移（最底层）

| 原（anthropic/Claude Code） | 现（MAXXXXXLI/WorkBuddy） |
|---------------------------|--------------------------|
| `~/.claude/plugins/config/...` | `~/.workbuddy/skills/config/...` |
| Claude Code 插件市场格式 | WorkBuddy ZIP 导入格式 |
| `name: nda-review`（英文标识） | `name: "商事合同法务-保密协议审查"`（中文命名） |
| 每个领域一个 plugin | 每个技能一个独立 ZIP |

### 4.2 中文重命名

所有技能文件名从英文改为中文，格式为 `{领域}-{技能名}.zip`：

| 原英文名（anthropic） | 中文名（MAXXXXXLI） |
|---------------------|-------------------|
| commercial-legal/nda-review | 商事合同法务-保密协议审查 |
| litigation-legal/chronology | 争议解决法务-事实时间线 |
| employment-legal/worker-classification | 劳动用工法务-劳动关系－用工形态识别 |
| privacy-legal/pia | 数据合规与个人信息保护-个人信息保护影响评估 |
| corporate-legal/entity-compliance | 公司与交易法务-主体合规 |

### 4.3 添加中国语境覆盖层（核心贡献）

每个 SKILL.md 头部都有一段**WorkBuddy 中国语境适配**区块：

```
## WorkBuddy 中国语境适配（优先）

本 skill 已转换为 WorkBuddy 中国语境版本。当前模块：**商事合同法务**；
当前技能：**保密协议审查**。

在执行下方原流程前，先读取并遵守：
- `references/china-context.md`（本模块中国语境规则）
- `references/china-legal-context.md`（全局中国法律语境总则）

除非用户明确指定其他法域，默认适用**中国大陆**。
下方原文中的美国州法、Delaware、ABA、CourtListener、Westlaw、DMCA、
deposition、subpoena、attorney work product 等内容均视为原模板遗留项。
```

同时 CLAUDE.md 头部也有类似的**WorkBuddy 中国语境总则**区块。

### 4.4 新增 2 个中国语境参考文件

**（1）`references/china-legal-context.md`（全局，5.5 KB）**

对所有 151 个技能通用，包含：
- 优先规则（默认中国大陆法域）
- **法源和引用层级表**（最实用部分）

| 类型 | 首选来源 |
|------|---------|
| 法律 | 全国人大/中国人大网 |
| 行政法规 | 中国政府网、国务院公报 |
| 部门规章 | CAC、SAMR、MIIT 等主管部门 |
| 司法解释 | 最高人民法院、最高人民检察院 |
| 裁判文书 | 人民法院案例库、裁判文书网 |
| 标准 | 全国标准信息公共服务平台 |
| 实务数据库 | 北大法宝、威科先行、律商联讯 |

- **官方基准链接**：民法典、公司法2024、个保法、数安法、网安法、数据跨境规定、生成式AI办法、算法推荐规定、深度合成规定、广告法、商标法、专利法——共 13 个官方链接

**（2）`references/china-context.md`（模块级，0.8-1 KB）**

每个领域一个，领域特定的中国法提示：
- 商事合同法务：民法典合同编、格式条款、电子签名
- 争议解决法务：管辖/仲裁条款、诉讼时效、请求权基础、调查令
- 劳动用工法务：劳动合同法、劳动关系三要素
- ……

### 4.5 保留原文 + 覆盖策略

这是 MAXXXXXLI 与 zhou210712 最大的区别：

| 做法 | zhou210712 | MAXXXXXLI |
|------|-----------|----------|
| 对原文 | **直接改写** CLAUDE.md | **保留不动**，在前面加覆盖层 |
| 英文内容 | 删除或替换为中国法 | 标注为"原模板遗留项" |
| 原文质量 | 随改写可能丢失控制细节 | 原文完整保留 |
| 中国法内容 | 9 个深度引用文件（民法典逐条） | 2 个参考文件（总则+通用性指引） |

### 4.6 风险提示增强

每份输出前置风险声明：

> 输出为法务/律师审阅草稿，不构成最终法律意见。正式发送、提交、签署或采纳前需由执业律师或法务负责人确认。
>
> 不能确认现行有效时标注 `[需核验]`，并给出应核验的官方来源。

---

## 五、与 zhou210712 / gjhcsjamin 对比

| 维度 | zhou210712 | gjhcsjamin | MAXXXXXLI |
|------|-----------|-----------|-----------|
| 目标平台 | Claude Code | Codex Desktop | **WorkBuddy（豆包）** |
| 适配深度 | **深** — 改写 CLAUDE.md + 11 个法条文件 | **浅** — 薄入口，委托上游 | **中** — 原文保留 + 中国语境覆盖层 |
| 中国法引用 | 11 个深度文件（逐条原文） | 无 | 2 个总则文件（法源指引） |
| 技能数量 | 12 领域 / 150 子技能 | 12 入口模板 | **151 个独立 ZIP** |
| 工作流保留 | 改写框架 | 完全委托 | **原文完整保留** |
| 技术门槛 | 需 Claude Code | 需 Codex | **零门槛，上传即用** |
| 许可证 | Apache 2.0 | Apache 2.0 | Apache 2.0 + NOTICE |

---

## 六、独有特点

### 6.1 唯一做了"中国法律检索"独立技能

其他所有版本（anthropic、zhou、gjhcsjamin）都没有独立的"法律检索"技能。MAXXXXXLI 新增了：
- `中国法律检索-中国法律深度检索.zip`（8 KB）

### 6.2 唯一跨平台到豆包

MAXXXXXLI 是唯一一个把 anthropic 的法律工作流带到**非 Claude/Codex 生态**的版本。WorkBuddy 是字节跳动的豆包工作台。

### 6.3 唯一按技能粒度打包

每个技能一个 ZIP，独立导入、独立使用。相比 anthropic 的 12 个 plugin（每个含多个技能），MAXXXXXLI 的 151 个 ZIP 粒度更细。

### 6.4 保留了完整的原文质量

由于采用"原文保留 + 覆盖层"策略，所有 anthropic 原版的工作流细节、审查标准的质量控制内容都完整保留，不会出现 zhou210712 那种 cold-start 缩短 80% 导致细节丢失的问题。

---

## 七、对本仓库的参考价值

### 可借鉴的

| 做法 | 说明 |
|------|------|
| **中国语境覆盖层模式** | 在原文前加声明而非直接改写，保留原文完整性 |
| **china-legal-context.md 法源指引表** | 官方来源汇总（全国人大、中国政府网、北大法宝等） |
| **风险提示标准化** | `[需核验]` 标签 + 核验来源说明 |
| **中文命名规范** | `领域-技能名` 格式清晰 |

### 不需要模仿的

| 做法 | 理由 |
|------|------|
| WorkBuddy 格式 | 你的目标是 Codex，不是豆包 |
| 保留完整英文原文 | 你的用户是中国律师，不需要看英文流程 |
| 151 个独立 ZIP | Codex 的 SKILL.md 聚合粒度更适合场景路由 |

