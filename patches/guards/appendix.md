<!--
version: 2.9.0
module: patches
status: active
-->


| 美国 | 中国 |
|---|---|
| U.S. Supreme Court | 最高人民法院 |
| Circuit Courts | 高级人民法院 |
| District Court | 中级/基层人民法院 |
| attorney | 律师 |
| district attorney | 检察官 |
| public defender | 法律援助律师 |

## 5.4 法律工具映射

| 美国 | 中国 |
|---|---|
| Westlaw | 北大法宝 |
| LexisNexis | 威科先行 |
| CourtListener | 中国裁判文书网 |

## 5.5 法律功能关系类型JSON数据字典

`json
{
  "relation_types": {
    "Equivalent": {"id": 1, "cn": "完全对应", "allow_direct_mapping": true},
    "PartialEquivalent": {"id": 2, "cn": "部分对应", "require_notes": true},
    "FunctionalEquivalent": {"id": 3, "cn": "功能对应", "require_notes": true},
    "PRCUnique": {"id": 4, "cn": "中国特色制度", "require_label": true},
    "HardBlock": {"id": 5, "cn": "绝对阻断", "prohibit_translation": true},
    "DynamicAlignment": {"id": 6, "cn": "动态对齐"},
    "ProceduralOverlap": {"id": 7, "cn": "程序近似"},
    "FunctionalReplacement": {"id": 8, "cn": "功能替代"}
  },
  "risk_tags": {
    "ChinaSpecific": {"cn": "★ 中国特色制度", "severity": "info"},
    "MajorComparativeDifference": {"cn": "※ 重要法系差异", "severity": "warning"},
    "HighRiskFalseEquivalence": {"cn": "⚠ 高风险误译", "severity": "critical"},
    "NoDirectEquivalent": {"cn": "❌ 无对应制度", "severity": "block"}
  }
}
`

## 5.6 引注格式映射

| 美国格式 | 中国格式 |
|---|---|
| U.S.C. § N | 《中华人民共和国XX法》第N条 |
| S. Ct. | 最高人民法院指导案例 |
| F.3d / F.2d | 中/高级人民法院民事判决书 |
| C.F.R. | 中华人民共和国行政法规 |
| Restatement (Second) § N | 《中华人民共和国民法典》第N条 |

---


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
