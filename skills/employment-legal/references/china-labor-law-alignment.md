<!--
version: 2.9.0
module: employment-legal
status: active
-->

> 来源: laubeing-droid/PRC-US-Legal-Semantic-Alignment-Framework
> 许可: Apache 2.0

## 2.15 （十四）劳动与社会保障法编

美国以At-Will Employment为默认原则；中国实行严格的法定解雇保护制度。

| 英文术语 | 功能对应译法 | 对应类型 | 强度 | 对应法条 | 风险标签 |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **at-will employment** | **法定解雇限制制** | 无对应制度 | ★ | 《中华人民共和国劳动合同法》第39-41条 | ❌ 绝对阻断 中国不承认任意解雇 |
| employment contract | 劳动合同 | 完全对应 | ★★★★★ | 《中华人民共和国劳动合同法》第10条 | |
| severance pay | 经济补偿金 | 功能对应 | ★★★★ | 《中华人民共和国劳动合同法》第47条 | 2N违法解除赔偿 |
| wrongful termination | 违法解除劳动合同 | 功能对应 | ★★★★ | 《中华人民共和国劳动合同法》第48条 | |
| non-compete | 竞业限制 | 部分对应 | ★★★★ | 《中华人民共和国劳动合同法》第23条 | 最长2年，须支付补偿 |
| RIF (Reduction in Force) | 经济性裁员 | 功能对应 | ★★★ | 《中华人民共和国劳动合同法》第41条 | ※ 重要法系差异 20人/10%以上须提前30天说明+劳动行政部门报告 |
| workers compensation | 工伤保险 | 完全对应 | ★★★★★ | 《工伤保险条例》 | |

### 跨境RIF裁员阻断

| 母公司RIF指令 | 中国法律红线 | AI强制拦截 |
|---|---|---|
| "Terminate immediately by paying 2 months salary" | 违法解除（双倍赔偿） | 必须触发《中华人民共和国劳动合同法》第41条经济性裁员程序 |
| "No notice required" | 必须提前30天向工会/全体职工说明 | 阻断无程序解雇文本 |

---


## 香港法桥梁（劳动法领域）

| 英文术语 | 香港中文 | 内地中文 | 风险等级 |
|---|---|---|---|
| at-will employment | 自由雇佣 | 无对应 | **❌** 绝对阻断 |
| employment contract | 雇佣合约 | 劳动合同 | **⚠** 香港《雇佣条例》独立体系 |
| severance payment | 遣散费 | 经济补偿金 | **⚠** 计算方式不同 |
| long service payment | 长期服务金 | 无对应 | **⚠** 香港特有制度 |

## §4.3 强制免责

> "本回复基于自动化技术咨询，不构成正式法律意见。本AI系统仅为辅助工作工具，所有最终方案必须经由具备中华人民共和国执业资格的律师独立判断并签署。"