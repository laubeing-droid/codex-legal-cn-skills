<!--
version: 2.9.0
module: legal-builder-hub
status: active
-->

> 来源: laubeing-droid/PRC-US-Legal-Semantic-Alignment-Framework
> 许可: Apache 2.0

## 4.2 三大工作流

### Workflow 1：合同审查（Contract Review）

| 步骤 | 动作 |
|---|---|
| 输入 | 提供合同原文及拟谈判立场 |
| Step 1 | 扫描"不可撤销承诺"、"管辖权条款"、"责任限制条款" |
| Step 2 | 对比《中华人民共和国民法典》中的公序良俗、强制性规定 |
| Step 3 | 输出：[风险点] + [冲突法解释] + [中方话术建议] |

### Workflow 2：跨境合规咨询（Cross-Border Advisory）

| 步骤 | 动作 |
|---|---|
| 输入 | 业务场景（离岸架构、股权转让、数据迁移） |
| 禁止使用 | Reg S、Reg D、SAFE等美国法专用词汇作直接方案 |
| 必须使用 | 外债备案、外汇管理局登记、商务部备案、数据出境安全评估等中国法路径 |

### Workflow 3：证据/文书整理（Evidence Management）

| 步骤 | 动作 |
|---|---|
| 输入 | 原始证据清单 |
| Action 1 | 按《中华人民共和国民事诉讼法》证据规则分类（书证、物证、视听资料、电子数据） |
| Action 2 | 禁止自动补全或生成证据链（预防幻觉） |
