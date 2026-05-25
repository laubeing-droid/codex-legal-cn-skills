> 来源: laubeing-droid/PRC-US-Legal-Semantic-Alignment-Framework
> 许可: Apache 2.0

## 5.1 22项高风险误译阻断清单

以下概念在中国法体系下**无对应制度**，AI输出中须阻断或功能替换：

| # | 概念 | 领域 | 处理方式 |
|---|---|---|---|
| 1 | consideration（对价） | 合同 | ❌ 整行删除 |
| 2 | promissory estoppel | 合同 | ❌ 整行删除 |
| 3 | statute of frauds | 合同 | ❌ 整行删除 |
| 4 | parol evidence rule | 合同 | ❌ 整行删除 |
| 5 | adverse possession | 物权 | ❌ 整行删除 |
| 6 | fee simple absolute | 物权 | ❌ 整行删除 |
| 7 | future interest | 物权 | ❌ 整行删除 |
| 8 | false light | 人格权 | 替换为"侵害名誉权" |
| 9 | right of publicity | 人格权 | 替换为"侵害肖像权/姓名权" |
| 10 | Miranda rights | 刑诉 | ❌ 整行删除 |
| 11 | hearsay rule | 刑诉 | ❌ 整行删除 |
| 12 | jury trial | 刑诉 | 替换为"人民陪审员" |
| 13 | fruit of poisonous tree | 刑诉 | ❌ 整行删除 |
| 14 | habeas corpus | 刑诉 | ❌ 整行删除 |
| 15 | Chevron deference（司法谦抑） | 行政法 | ❌ 整行删除（中国法院对行政行为合法性进行独立司法审查，不采纳行政机关法律解释优先原则） |
| 16 | sovereign/qualified immunity | 行政诉讼 | ❌ 整行删除 |
| 17 | summary judgment / consent decree | 行政诉讼 | ❌ 整行删除 |
| 18 | collateral estoppel | 行政诉讼 | ❌ 整行删除 |
| 19 | at-will employment | 劳动法 | ❌ 整行删除 |
| 20 | estate tax / gift tax | 继承/税法 | ❌ 整行删除 |
| 21 | plea bargaining | 刑诉 | 替换为"认罪认罚从宽" |
| 22 | discovery | 民诉 | 替换为"证据交换" |
| 23 | deposition（庭前宣誓证言） | 民诉 | 阻断 + 替换为调查取证准备（调查令/证据保全/质证） |
| 24 | privilege log / attorney-client privilege | 民诉 | 阻断，提示中国无此制度 |
| 25 | cease and desist（停止侵权函） | 知识产权 | 替换为律师函 |
| 26 | severance package（离职补偿方案） | 劳动法 | 替换为经济补偿金/离职补偿（劳动合同法第47条/第87条） |
| 27 | precedent-based reasoning（判例推理） | 通用 | 阻断，提示中国为成文法国家，判例仅具参考价值 |
| 28 | Delaware 公司法 / 美国州法引用 | 通用 | 阻断跨境法域引用，提示适用中国公司法 |
| 29 | layoff / RIF（裁员） | 劳动法 | 替换为中国经济性裁员程序（劳动合同法第41条） |



