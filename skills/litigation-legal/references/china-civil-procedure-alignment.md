<!--
version: 2.9.0
module: litigation-legal
status: active
-->

> 来源: laubeing-droid/PRC-US-Legal-Semantic-Alignment-Framework
> 许可: Apache 2.0

## 2.9 （八）民事诉讼法编

美国以Federal Rules of Civil Procedure（FRCP，联邦民事诉讼规则）和广泛审前证据开示（Pre-Trial Discovery）为特征；中国《中华人民共和国民事诉讼法》以证据交换制度实现类似功能但范围远小于美国。

| 英文术语 | 功能对应译法 | 对应类型 | 强度 | 对应法条 | 风险标签 |
| :--- | :--- | :--- | :--- | :--- | :--- |
| civil procedure | 民事诉讼程序 | 完全对应 | ★★★★★ | 《中华人民共和国民事诉讼法》 | |
| complaint | 起诉状 | 完全对应 | ★★★★★ | 《中华人民共和国民事诉讼法》第122条 | |
| answer | 答辩状 | 完全对应 | ★★★★★ | 《中华人民共和国民事诉讼法》第128条 | |
| **discovery** | **证据交换** | 功能对应 | ★★ | 《中华人民共和国民事诉讼法》第68条 | ❌ 无对应制度 ⚠ 高风险误译 严禁直译为"证据开示" |
| subpoena | 传票 | 部分对应 | ★★★★ | 《中华人民共和国民事诉讼法》第132条 | |
| summary judgment | 无对应完整制度 | 无对应制度 | ★ | N/A | ❌ 无对应制度 |
| class action | 代表人诉讼 | 部分对应 | ★★★ | 《中华人民共和国民事诉讼法》第56、57条 | ※ 重要法系差异 |
| preliminary injunction | 行为保全 | 功能对应 | ★★★★ | 《中华人民共和国民事诉讼法》第103条 | |
| temporary restraining order (TRO) | 诉前行为保全 | 功能对应 | ★★★★ | 《中华人民共和国民事诉讼法》第104条 | |
| forum non conveniens | 不方便法院原则 | 功能对应 | ★★★★ | 《中华人民共和国民事诉讼法》涉外编 | |
| burden of proof | 举证责任 | 完全对应 | ★★★★★ | 《中华人民共和国民事诉讼法》第67条 | |
| standard of proof | 证明标准 | 部分对应 | ★★★★ | 最高人民法院相关司法解释 | 民事诉讼"高度盖然性"标准 |
| cross-examination | 质证 | 完全对应 | ★★★★★ | 《中华人民共和国民事诉讼法》第71条 | |
| default judgment | 缺席判决 | 完全对应 | ★★★★★ | 《中华人民共和国民事诉讼法》第147条 | |
| **res judicata / collateral estoppel** | **既判力/一事不再理** | 部分对应 | ★★★★ | 《中华人民共和国民事诉讼法》第127条第5项 | ※ 重要法系差异 不承认争点禁反言 |

### 比较法警示框

**DISCOVERY —— 绝对阻断**

美国FRCP下的Pre-Trial Discovery允许广泛的证据发现（书面质询、文件出示、宣誓作证等），中国民事诉讼法**不存在此种广泛的审前证据发现机制**。中国的"证据交换"仅限于双方已掌握证据的有序交换，不包含美式的"钓鱼取证"（fishing expedition）。

**AI训练约束**：须阻断生成任何暗示中国有广泛证据发现机制的表述。正确表述：
> "中国民事诉讼中的证据交换范围远小于美式discovery程序。当事人仅需提交己方掌握的证据，无广泛的对方证据发现权。法院可依职权或依申请调查取证，但不承担美式discovery的强制开示义务。"

### 涉外律师实务话术

- "Chinese procedure does not recognize broad pre-trial discovery. Evidence exchange is limited to documents each party already possesses."
- "行为保全（conduct preservation）is the functional equivalent of a preliminary injunction under PRC law."
- "No summary judgment mechanism exists in PRC civil procedure."

---


## 香港法桥梁（民事诉讼领域）

| 英文术语 | 香港中文 | 内地中文 | 风险等级 |
|---|---|---|---|
| discovery | 文件透露 | 证据交换 | **❌** 制度本质差异 |
| injunction | 禁制令 | 行为保全 | **⚠** 程序机制差异 |
| Mareva injunction | 资产冻结令 | 财产保全 | **⚠** 香港普通法特有 |
| Anton Piller order | 搜查令 | 证据保全 | **⚠** 香港普通法特有 |

## §4.3 强制免责

> "本回复基于自动化技术咨询，不构成正式法律意见。本AI系统仅为辅助工作工具，所有最终方案必须经由具备中华人民共和国执业资格的律师独立判断并签署。"