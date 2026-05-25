<!--
version: 2.9.0
module: litigation-legal
status: active
-->

> 来源: laubeing-droid/PRC-US-Legal-Semantic-Alignment-Framework
> 许可: Apache 2.0

## 2.10 （九）刑事诉讼法编

美国以对抗制（Adversarial System）和辩诉交易（Plea Bargaining）为核心；中国以职权主义+认罪认罚从宽制度为核心，不承认辩诉交易。

| 英文术语 | 功能对应译法 | 对应类型 | 强度 | 对应法条 | 风险标签 |
| :--- | :--- | :--- | :--- | :--- | :--- |
| criminal procedure | 刑事诉讼程序 | 完全对应 | ★★★★★ | 《中华人民共和国刑事诉讼法》 | |
| arrest | 逮捕/拘留 | 部分对应 | ★★★★ | 《中华人民共和国刑事诉讼法》第81、82条 | |
| indictment | 起诉书 | 功能对应 | ★★★★ | 《中华人民共和国刑事诉讼法》第186条 | |
| **plea bargaining** | ⭐ 认罪认罚从宽制度 | 功能替代 | ★★★ | 《中华人民共和国刑事诉讼法》第15条 | ⚠ 高风险误译 ★ 中国特色制度 严禁译为"辩诉交易" |
| **Miranda rights** | **无对应制度** | 无对应制度 | ★ | N/A | ❌ 无对应制度 中国法无米兰达规则 |
| **right to silence** | **无对应制度** | 无对应制度 | ★ | N/A | ❌ 无对应制度 犯罪嫌疑人有"如实回答"义务（《中华人民共和国刑事诉讼法》第120条） |
| **hearsay rule** | **无对应制度** | 无对应制度 | ★ | N/A | ❌ 无对应制度 无完整传闻证据排除规则 |
| **fruit of poisonous tree** | **无对应制度** | 无对应制度 | ★ | N/A | ❌ 无对应制度 非法证据排除范围有限 |
| **jury trial** | **人民陪审员制度** | 功能替代 | ★★ | 《中华人民共和国人民陪审员法》 | ※ 重要法系差异 人民陪审员与法官共同审理 |
| double jeopardy | 一事不再理/禁止双重危险 | 部分对应 | ★★★ | 《中华人民共和国刑事诉讼法》第10条 | ※ 重要法系差异 允许特定情形再审 |
| bail | 取保候审 | 部分对应 | ★★★ | 《中华人民共和国刑事诉讼法》第67条 | |
| habeas corpus | 人身保护令/羁押必要性审查 | 功能替代 | ★★★ | 《中华人民共和国刑事诉讼法》第95条 | ※ 重要法系差异 |
| expert witness | 鉴定人 | 功能对应 | ★★★★ | 《中华人民共和国刑事诉讼法》第146条 | 由专门机关指派或聘请 |

### 比较法警示框

**PLEA BARGAINING —— 绝对阻断**

美国辩诉交易允许检察官与被告人就罪名、罪数和量刑进行协商。中国**不承认辩诉交易**。认罪认罚从宽制度是检察机关提出量刑建议，法院进行实质审查后决定是否采纳，不涉及罪名协商。

**MIRANDA RIGHTS / RIGHT TO SILENCE —— 绝对阻断**

《中华人民共和国刑事诉讼法》第120条规定犯罪嫌疑人对侦查人员的提问"应当如实回答"，不存在沉默权。严禁AI在境内刑事案件输出中引用米兰达规则或暗示当事人享有沉默权。

**涉外律师实务话术**：
- "China has a 'guilty plea and punishment acceptance'（认罪认罚从宽）system, which is distinct from plea bargaining. No charge bargaining is permitted."
- "There is no Miranda-style warning requirement under PRC criminal procedure law."

---


## 香港法桥梁（刑事诉讼领域）

| 英文术语 | 香港中文 | 内地中文 | 风险等级 |
|---|---|---|---|
| jury trial | 陪审团审讯 | 人民陪审员 | **❌** 制度本质不同 |
| plea bargaining | 认罪协商 | 认罪认罚从宽 | **❌** 绝对阻断 |
| Miranda rights | 米兰达警告 | 无对应 | **❌** 绝对阻断 |
| habeas corpus | 人身保护令 | 无对应 | **❌** 绝对阻断 |
| contempt of court | 藐视法庭 | 妨害司法 | **⚠** 制度本质不同 |

## §4.3 强制免责

> "本回复基于自动化技术咨询，不构成正式法律意见。本AI系统仅为辅助工作工具，所有最终方案必须经由具备中华人民共和国执业资格的律师独立判断并签署。"