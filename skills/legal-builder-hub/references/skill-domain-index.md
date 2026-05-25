<!--
version: 2.9.0
module: legal-builder-hub
status: active
-->

> 来源: laubeing-droid/PRC-US-Legal-Semantic-Alignment-Framework
> 许可: Apache 2.0

## 5.7 技能域-术语映射索引

以下索引供 Claude for Legal CN 按技能域按需加载，避免全量注入浪费上下文窗口。

### 加载规则

`	ext
IF 技能域 = X:
    LOAD 对应部门法编的术语映射表 + 该编的比较法警示框
    LOAD 元规则 Rule 1-6（全局规则，始终加载）
    SKIP 非相关编（不加载到该技能域的 System Prompt 中）
`

### 索引表

| Claude for Legal CN 技能域 | 对应部门法编 | 核心术语（阻断优先） | 必加载节 |
|---|---|---|---|
| **commercial-legal** | §2.4 合同编 + §2.3 物权编 | consideration❌, liquidated damages, material breach, force majeure, termination for convenience, deed, nominal consideration, novation | §2.4全文 + §1.6.2逆向映射 |
| **employment-legal** | §2.15 劳动法编 + §2.4 合同编(At-Will) | at-will employment❌, severance pay, wrongful termination, non-compete, RIF, workers compensation | §2.15全文 + §1.6.3跨境裁员阻断 |
| **litigation-legal** | §2.9 民诉编 + §2.10 刑诉编 | discovery❌, summary judgment❌, class action, res judicata, plea bargaining❌, Miranda rights❌, hearsay rule❌, jury trial | §2.9+§2.10全文 |
| **corporate-legal** | §2.11 公司法编 + §2.16 破产法编 | piercing veil, fiduciary duty, shadow director, Chapter 11 vs 重整, automatic stay, DIP | §2.11+§2.16全文 + §2.17.7(VIE) |
| **privacy-legal** | §2.13 数据合规编 | personal data, cross-border transfer, data localization, important/core data, 数据出境安全评估 | §2.13全文 + §1.6.4数据出境触发规则 |
| **ip-legal** | §2.14 知识产权编 | patent exhaustion, trade secret, patent, trademark, copyright | §2.14知识产权子编 |
| **product-legal** | §2.5 人格权编 + §2.8 侵权编 | right of publicity, right to voice, product liability, AI liability | §2.5+§2.8全文 |
| **regulatory-legal** | §2.12 行政法编 + §2.17 跨境前沿 | Chevron deference❌, administrative hearing, 行政公益诉讼, 制裁/反制裁, ESG强制披露 | §2.12+§2.17全文 |
| **ai-governance-legal** | §2.13 数据合规编 + §2.17.6 AI监管 | 算法备案, generative AI, deep synthesis, AI liability, AI training data | §2.17.6 + §2.5(声音权) |
| **tax-legal** | §2.14 税法编 | estate tax❌, gift tax❌, VAT, withholding tax, transfer pricing | §2.14税法子编 |
| **antitrust-legal** | §2.14 反垄断编 | monopoly, merger control, cartel, RPM | §2.14反垄断子编 |
| **fintech-legal** | §2.17.4 Web3 + §2.13 数据合规 | cryptocurrency❌, NFT/数字藏品, crypto mining❌, blockchain, data localization | §2.17.4 + §2.13 |
| **international-arbitration** | §2.4 合同编 + §3 香港桥梁 + §2.17.1 制裁 | novation, force majeure, jurisdiction, 制裁/反制裁 | §2.4+§3+§2.17.1 |

### 全局规则（所有技能域始终加载）

| 规则 | 内容 |
|---|---|
| Rule 1 | 禁止字面优先 |
| Rule 2 | 优先判断制度功能 |
| Rule 3 | 无对应制度时强制阻断 |
| Rule 4 | 中国特色制度必须显式标注 |
| Rule 5 | 法域切换时不得混同 |
| Rule 6 | 最严管辖规则 |
| §4.3 | 强制免责输出 |

---

## 参考法律依据
## 参考法律依据

- 《中华人民共和国民法典》（2021年1月1日施行）
- 《中华人民共和国公司法》（2024年7月1日修订施行）
- 《中华人民共和国民事诉讼法》（2024年修正）
- 《中华人民共和国刑事诉讼法》（2018年修正）
- 《中华人民共和国行政诉讼法》（2017年修正）
- 《中华人民共和国个人信息保护法》（2021年11月1日施行）
- 《中华人民共和国数据安全法》（2021年9月1日施行）
- 《中华人民共和国网络安全法》（2017年6月1日施行）
- 《中华人民共和国反垄断法》（2022年修正）
- 《中华人民共和国反不正当竞争法》（2019年修正）
- 《中华人民共和国企业破产法》（2007年6月1日施行）
- 《中华人民共和国劳动合同法》（2013年修正）
- 《中华人民共和国出口管制法》（2020年12月1日施行）
- 《中华人民共和国反外国制裁法》（2021年6月10日施行）
- 《中华人民共和国香港特别行政区基本法》
- 《生成式人工智能服务管理暂行办法》（2023年8月15日施行）
- 《电子版香港法律》(Hong Kong e-Legislation)
- 香港律政司《英汉法律词汇》
- 美国最高法院Loper Bright Enterprises v. Raimondo, 603 U.S. ___ (2024) — 以6:3推翻Chevron U.S.A., Inc. v. Natural Resources Defense Council, Inc., 467 U.S. 837 (1984)确立四十年的"Chevron两步法"司法谦抑原则，裁定《联邦行政程序法》(APA)要求法院对行政机关的法律解释行使独立判断，不再默认遵从行政解释。这意味着涉及美国行政监管术语（如CFR、agency interpretation）的AI映射须重新评估中国法下的审查标准差异。

---

> **定位说明**：本文档为比较法学研究参考资料，供AI法律工程化（System Prompt注入、RAG知识库构建、术语标准化）使用。不替代执业律师的专业判断。
>
> **核心方法**：以制度功能对应（functional equivalence）替代逐词直译，以中国部门法为组织骨架。

🏁 全文输出完毕
