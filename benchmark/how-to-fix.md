# Benchmark 修复指南

> 跑完对抗测试发现护栏没拦住？按这个流程修。

---

## 修复流程

```
跑测试 → 发现失败 → 判断失败类型 → 按本文对应方法修复 → 重跑验证
```

---

## 失败类型与修复方法

### 类型 A：美国法概念直接输出（没拦住）

**现象：** AI 直接回答了 deposition / consideration / at-will 等阻断概念，没有提示中国法无此制度。

**修复位置：** `patches/guards/blocking-list.md`

```
| # | 概念 | 领域 | 处理方式 |
|---|---|---|---|
| 1 | consideration（对价） | 合同 | ❌ 整行删除 |
```

**修复方法：**
- 确认该概念是否已在 blocking-list.md 中
- 如果已存在但没拦住 → 增强 CLAUDE.md 中的护栏注入 prompt

**增强护栏注入：**
在 12 个领域的 CLAUDE.md 中，搜索 `你须严格遵守以下规则：` 附近，确认以下指令是否存在：

```
- 如果用户提及 "deposition"、"discovery"、"consideration" 等美国法概念，必须立即指出中国法无此制度，并给出中国法替代方案
- 禁止直译美国法律术语
```

如果不存在，在 `patches/workflows/` 对应领域的 CLAUDE.md 补上。

---

### 类型 B：输出了美国法概念但没给中国替代

**现象：** AI 说"中国没有 deposition 制度"但没有提供中国法替代方案。

**修复位置：** `patches/guards/meta-rules.md`

**修复方法：**
在 meta-rules.md 的阻断规则中，为每个阻断概念加上"替代指引"：

```
Rule C — 阻断必替代：凡触发阻断概念，必须在同一回答中提供中国法等效制度或实务指引。
```

---

### 类型 C：技能路由错了

**现象：** 输入"起草一份 cease and desist letter" → AI 没走"律师函生成"技能。

**修复位置：** `skills/ip-legal/skills/cease-desist/SKILL.md`（已改名）或 `claude-legal-cn` 目录的入口映射。

**修复方法：**
- 检查 `claude-legal-cn/CLAUDE.md` 中的技能路由表，确认 "cease and desist" → "律师函生成" 的映射是否存在
- 如果缺少，在路由表中加上：

```
- 用户说"起草 C&D/cease and desist/侵权警告函" → 调用 ip-legal/律师函生成
```

---

### 类型 D：引用了美国判例/法条

**现象：** AI 引用美国判例或 Delaware 公司法来回答中国法律问题。

**修复位置：** `patches/guards/workflows.md`

**修复方法：**
在 workflows.md 中增强地域阻断规则：

```
Rule D — 法域隔离：禁止引用非中国法域的法律依据。当用户提及境外法域时，必须先确认是否适用于中国法律环境。
```

同时在 CLAUDE.md 中注入：

```
- 你的法律知识库以中国法为准，不得主动引用美国、英国、香港（除特别说明）等法域的法律
```

---

### 类型 E：AI 自己发明了中国法不存在的制度

**现象：** AI 说"您需要准备 privilege log"——中国根本没这个制度。

**修复位置：** `patches/guards/blocking-list.md` + `skills/references/22-blocked-concepts.md`

**修复方法：**
- 如果该概念不在阻断清单中 → 新增一条
- 同时确认 22-blocked-concepts.md 中也有对应条目

---

## 快速修复对照表

| 测试 # | 查询 | 预期失败 | 修复文件 |
|:------:|:-----|:--------|:---------|
| 1 | deposition 提纲 | 没拦住 / 没替代 | blocking-list.md + CLAUDE.md 护栏注入 |
| 2 | consideration | 直接回答了 | blocking-list.md |
| 3 | at-will | 没替代 | meta-rules.md |
| 4 | discovery | 直译没纠正 | workflows.md |
| 5 | 美国判例 | 引用了 | workflows.md + CLAUDE.md |
| 6 | plea bargain | 没替换为"认罪认罚从宽" | blocking-list.md |
| 7 | privilege log | 没阻断 | blocking-list.md（新增） |
| 8 | Delaware 公司法 | 没阻断跨境引用 | workflows.md |
| 9 | false light | 没纠正"侵害名誉权" | blocking-list.md |
| 10 | habeas corpus | 没阻断 | blocking-list.md |
| 11 | summary judgment | 没阻断 | blocking-list.md |
| 12 | severance | 没纠正"离职补偿" | CLAUDE.md 路由 |
| 13 | cease and desist | 没走到"律师函生成" | 技能路由表 |
| 14 | layoff | 用了 at-will 逻辑 | CLAUDE.md 劳动法规则 |
| 15 | statute of frauds | 没阻断 | blocking-list.md |

---

## 一键检查护栏完整性

```powershell
.\verify.ps1
```

会检查：
- 6 个护栏文件是否存在（blocking-list / meta-rules / workflows / china-unique / hk-bridge / appendix）
- 22-blocked-concepts.md 中的阻断条目数量
- 所有技能目录的 CLAUDE.md 是否存在

---

## 修复后验证

```powershell
.\verify.ps1 -Benchmark
```

交互式模式会逐条跑，记录 pass/fail，最后汇总。
