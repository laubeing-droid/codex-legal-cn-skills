<!--
version: 2.9.0
module: commercial-legal
status: active
-->

> 来源: laubeing-droid/PRC-US-Legal-Semantic-Alignment-Framework
> 许可: Apache 2.0

## 2.4 （三）民法·合同编

美国合同法以对价（consideration）为成立要件，以UCC为商事交易核心法典；中国合同法以《中华人民共和国民法典》合同编为统一规范，不以对价为成立要件。

### 术语与制度映射表

| 英文术语 | 功能对应译法 | 对应类型 | 强度 | 对应法条 | 风险标签 |
| :--- | :--- | :--- | :--- | :--- | :--- |
| contract | 合同 | 完全对应 | ★★★★★ | 《中华人民共和国民法典》第464条 | |
| offer | 要约 | 完全对应 | ★★★★★ | 《中华人民共和国民法典》第472条 | |
| acceptance | 承诺 | 完全对应 | ★★★★★ | 《中华人民共和国民法典》第479条 | |
| consideration | 无对应制度 | 无对应制度 | ★ | N/A | ❌ 无对应制度 中国合同成立不要求对价 |
| promissory estoppel | 诚实信用原则/缔约过失责任 | 功能对应 | ★★★ | 《中华人民共和国民法典》第7条、第500条 | ⚠ 高风险误译 中国法无独立promissory estoppel诉由 |
| statute of frauds | 书面形式要求 | 部分对应 | ★★ | 《中华人民共和国民法典》第469条 | ※ 重要法系差异 中国无独立防止欺诈法 |
| liquidated damages | 违约金 | 部分对应 | ★★★★ | 《中华人民共和国民法典》第585条 | ※ 重要法系差异 违约金以补偿性为原则，超实际损失30%可调减 |
| material breach | 根本违约/导致合同目的不能实现 | 部分对应 | ★★★★ | 《中华人民共和国民法典》第563条第1款第4项 | 触发法定解除权的核心条件 |
| cure period / right to cure | 催告后的合理期限 | 程序近似 | ★★★★ | 《中华人民共和国民法典》第563条第1款第3项 | 必须履行催告程序，不可自动解约 |
| adhesion contract | 格式合同 | 完全对应 | ★★★★★ | 《中华人民共和国民法典》第496条 | 提供方须履行提示说明义务 |
| assignment | 债权转让 | 完全对应 | ★★★★★ | 《中华人民共和国民法典》第545条 | 须通知债务人 |
| delegation | 债务转移 | 部分对应 | ★★★★ | 《中华人民共和国民法典》第551条 | 须经债权人同意 |
| novation | 债务更新/债的更改 | 功能对应 | ★★★ | 《中华人民共和国民法典》第543条 | 中国法未单独设立novation章节 |
| force majeure | 不可抗力 | 完全对应 | ★★★★★ | 《中华人民共和国民法典》第180条、第563条 | |
| termination for convenience | 意定任意解除权 | 功能替代 | ★★★ | 《中华人民共和国民法典》第465、565条 | ⚠ 高风险误译 长期排他合同任意解除可能构成恶意违约 |
| deed | 契据/经公证的单方承诺 | 功能替代 | ★★ | 《中华人民共和国民法典》第658条 | ⚠ 高风险误译 普通法Deed不可撤销；中国法下可能定性为可撤销赠与 |

### 比较法警示框

**AT-WILL EMPLOYMENT —— 绝对阻断**

在美国劳工法中，"At-Will Employment"意味着雇主或雇员可在无任何理由的情况下随时解除劳动关系。中国实行严格的**法定解雇制**（《中华人民共和国劳动合同法》第36、39、40、41条），用人单位必须具备法定实体事由并履行法定程序，否则构成**违法解除**，面临支付双倍经济补偿金（2N）或强制恢复劳动关系的法律后果。

**AI训练约束**：若输入"At-Will"，必须阻断生成任何允许中国用人单位随意解雇的条款，并强制替换为：
> "中国劳动法体系以'法定解雇限制'为核心，用人单位单方解除劳动合同需同时满足实体事由与程序要求。"

**Nominal Consideration（象征性对价）——穿透审查**

美式合同常以" and other valuable consideration"满足对价要件。逆向映射至中国法时，AI应穿透审查其实质法律关系：若实质为无偿，适用赠与或不当得利规则；若为隐蔽交易，依据《中华人民共和国民法典》第146条判定"通谋虚假意思表示无效"。

### 涉外律师实务话术

- "China does not require consideration for contract formation. A contract is formed upon offer and acceptance under the PRC Civil Code."
- "Chinese liquidated damages are compensatory in nature. Courts may adjust amounts exceeding 30% of actual loss."
- "Even if Cure Period is specified in the contract, non-breaching party must still fulfill the statutory notice（催告）procedure before terminating for delayed performance."

---


## 香港法桥梁（合同领域）

| 英文术语 | 香港中文 | 内地中文 | 风险等级 |
|---|---|---|---|
| consideration | 约因/代价 | 无对应 | **❌** 绝对阻断 |
| estoppel | 不容反悔 | 禁止反言 | **⚠** 概念差异 |
| specific performance | 强制履行 | 继续履行 | **⚠** 香港为衡平法裁量救济 |
| deed | 契据 | 无对应 | **⚠** 不得直译 |

## 域专属阻断规则

以下概念在中国合同法律体系下无对应制度，AI输出中须阻断：
- consideration（对价）→ ❌ 整行删除
- promissory estoppel → ❌ 整行删除
- statute of frauds → ❌ 整行删除
- parol evidence rule → ❌ 整行删除

## §4.3 强制免责

> "本回复基于自动化技术咨询，不构成正式法律意见。本AI系统仅为辅助工作工具，所有最终方案必须经由具备中华人民共和国执业资格的律师独立判断并签署。"