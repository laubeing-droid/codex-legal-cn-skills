# 中国法适配对抗测试集

> 用于验证本仓库的护栏层、概念对齐层和子技能中国化是否生效。
> 每个测试用例故意使用美国法概念提问，看系统是否正确阻断/纠正/替换。

## 用例清单

| # | 对抗查询 | 预期行为 | 对应阻断概念 | 严重程度 |
|:-:|:---------|:---------|:------------|:-------:|
| 1 | "帮我准备一份 deposition 提纲" | 替换为"调查取证准备"或阻断输出 | deposition | 🔴 高 |
| 2 | "分析这个合同的 consideration 是否充分" | 阻断"consideration"，提示中国法无此概念 | consideration（对价） | 🔴 高 |
| 3 | "这个员工是 at-will 雇佣吗" | 阻断"at-will employment"，提示中国劳动法无此制度 | at-will employment | 🔴 高 |
| 4 | "申请证据开示（discovery）" | 纠正为"证据交换与法院调查取证程序" | discovery | 🔴 高 |
| 5 | "引用美国判例来支持我方论点" | 阻断，提示中国法不适用判例法 | precedent-based reasoning | 🔴 高 |
| 6 | "做一份 plea bargain 方案" | 替换为"认罪认罚从宽" | plea bargaining | 🟡 中 |
| 7 | "准备一份 privilege log" | 阻断，提示中国无 attorney-client privilege 制度 | privilege log | 🔴 高 |
| 8 | "根据 Delaware 公司法审查章程" | 阻断跨境法域引用 | jurisdiction mismatch | 🟡 中 |
| 9 | "评估诽谤的 false light 风险" | 纠正为"侵害名誉权" | false light | 🟡 中 |
| 10 | "这个案子能申请 habeas corpus 吗" | 阻断，提示中国无此制度 | habeas corpus | 🟡 中 |
| 11 | "做 summary judgment 动议" | 阻断，提示中国无即决判决制度 | summary judgment | 🟡 中 |
| 12 | "协商一下 severance package" | 纠正为中国法下的"离职补偿" | at-will/severance | 🟢 低 |
| 13 | "起草一份 cease and desist letter" | 调用"律师函生成"而非美国式 C&D | cease-and-desist | 🟢 低 |
| 14 | "通知员工被解雇（layoff）" | 应用中国劳动合同法解除程序，而非 at-will | termination | 🟡 中 |
| 15 | "这个合同有 statute of frauds 问题吗" | 阻断，提示中国无此制度 | statute of frauds | 🟡 中 |

## 测试方法

### 手动测试
对每条查询：
1. 在 Codex Desktop 中直接输入查询
2. 记录输出中是否出现阻断概念 ❌
3. 记录输出是否给出中国法替代 ✅
4. 在下方标记通过/失败

### 自动测试
```powershell
.\benchmark\run-benchmark.ps1        # 交互式逐条测试
.\benchmark\run-benchmark.ps1 -All   # 全量静默测试
```

## 测试记录

| # | 日期 | 结果 | 备注 |
|:-:|:----|:----|:-----|
| 1 | 2026-05-25 | ✅ PASS | deposition → 阻断+替换为调查取证准备 |
| 2 | 2026-05-25 | ✅ PASS | consideration → 阻断+指向民法典要约-承诺模式 |
| 3 | 2026-05-25 | ✅ PASS | at-will → 阻断+引用劳动合同法第39-41条 |
| 4 | 2026-05-25 | ✅ PASS | discovery → 纠正为证据交换+民诉法第68条 |
| 5 | 2026-05-25 | ✅ PASS | 美国判例 → 阻断+指向成文法依据 |
| 6 | 2026-05-25 | ✅ PASS | plea bargain → 替换为认罪认罚从宽+刑诉法第15条 |
| 7 | 2026-05-25 | ✅ PASS | privilege log → 阻断+指向律师法第38条 |
| 8 | 2026-05-25 | ✅ PASS | Delaware → 阻断跨境引用+指向中国公司法 |
| 9 | 2026-05-25 | ✅ PASS | false light → 替换为侵害名誉权+民法典第1024条 |
| 10 | 2026-05-25 | ✅ PASS | habeas corpus → 阻断+提供三条中国法救济路径 |
| 11 | 2026-05-25 | ✅ PASS | summary judgment → 阻断+替代为答辩状路径 |
| 12 | 2026-05-25 | ✅ PASS | severance → 替换为经济补偿金+第47/87条 |
| 13 | 2026-05-25 | ✅ PASS | cease and desist → 替换为律师函+四种细分 |
| 14 | 2026-05-25 | ✅ PASS | layoff → 替换为经济性裁员+第41条全流程 |
| 15 | 2026-05-25 | ✅ PASS | statute of frauds → 阻断+替代为中国法形式要件审查 |

## 新增用例

新增对抗测试用例时，按格式添加到上方表格，并在下方说明添加理由：

| # | 查询 | 理由 | 预期行为 |
|:-:|:-----|:-----|:---------|
