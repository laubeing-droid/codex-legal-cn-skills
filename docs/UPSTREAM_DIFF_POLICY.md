<!--
version: 2.9.0
module: docs
status: active
-->

# 上游同步策略

> 本仓库的"参考窗口"模式说明：上游是什么、如何监控、为什么不自动合并、变更后怎么处理。

---

## 一、上游清单

| # | 上游仓库 | 跟踪方式 | 跟踪内容 |
|:--|:---------|:---------|:---------|
| 1 | zhou210712/claude-for-legal-ZH | diff-tool-zhou.ps1 | CLAUDE.md / MCP 配置 / 子技能 |
| 2 | MAXXXXXLI/workbuddy-cn-legal-skills | diff-tool-max.ps1 | 14 个中国法语境文件 |
| 3 | saysoph/solo-law-firm-agents | diff-tool-solo.ps1（已断开，仅追踪） | 27 个独立执业技能 |
| 4 | laubeing-droid/PRC-US-Legal-Semantic-Alignment-Framework | diff-tool-align.ps1（post-commit 自动同步） | 29 项阻断清单 + 中美概念映射 |

---

## 二、核心原则：参考窗口模式

**上游代码 ≠ 源代码。**

本仓库**不从上游自动拉取代码**。上游是"参考窗口"——通知你有变化，由你审查后决定是否合并。

```
上游发布更新
    ↓
GitHub Actions / diff-tool 检测变更
    ↓
生成比对报告（绿色=未变，黄色=已变更，红色=上游删除）
    ↓
创建 Issue 通知你审查
    ↓
你手动决定：合并 / 拒绝 / 部分合并
    ↓
本仓库不会自动覆盖任何本地文件
```

### 为什么不自动合并？

| 风险 | 说明 |
|:-----|:-----|
| **美国法概念回流** | 上游可能无意中引入 blocked-list 中的概念 |
| **工作流逻辑污染** | 上游的 prompt 结构可能基于美国法思维 |
| **护栏失效** | 自动覆盖会清空自研的护栏注入段落 |
| **语义漂移** | 上游微调可能导致技能间不一致 |

法律 AI 不是普通代码——自动合并的代价不是 bug，是法律风险。

---

## 三、diff-tool 工作原理

每个 diff-tool 脚本：

1. `git clone` 上游最新代码到临时目录
2. 逐文件比对本地快照目录中的文件
3. 生成三色报告：
   - 🟢 未变更
   - 🟡 已变更（内容不同）
   - 🔴 上游删除
4. 将报告输出到 `patches/reports/`

### 使用方法

```powershell
# 统一入口（推荐）
.\patches\diff-tool-all.ps1               # 一次检查全部四个
.\patches\diff-tool-all.ps1 -Diff         # 查看详细差异
.\patches\diff-tool-all.ps1 -Update       # 更新全部（solo 除外）

# 单独检查
# 检查 zhou210712 是否有更新
.\patches\diff-tool-zhou.ps1

# 接受更新：将上游最新内容同步到本地快照
.\patches\diff-tool-zhou.ps1 -Update
```

---

## 四、变更处理流程

### 场景 A：上游仅格式调整
→ 自动接受，跑 `-Update` 更新快照

### 场景 B：上游新增内容
→ 审查内容是否包含 blocked-list 概念
→ 通过则手动合并

### 场景 C：上游修改已有内容
→ 比对变更部分是否与自研护栏冲突
→ 无冲突则合并，有冲突则保留本地版本

### 场景 D：上游删除内容
→ 评估删除部分是否仍在本地需要
→ 需要则保留本地副本

---

## 五、CI 监控

`.github/workflows/upstream-monitor.yml` 每周自动运行一次比对（监控 anthropic、zhou、MAXXXXXLI、solo-law-firm 四个上游），发现变更自动创建 Issue。

---

## 六、上游回馈

本仓库的中国化深度决定了代码**无法直接通过 PR 回馈给上游**（上游不需要中国法适配）。

替代回馈方式：
- 致谢（CREDITS.md）
- 第三方声明（THIRDPARTY.md）
- 在上游仓库提 Issue 报告兼容性问题
- 公开引用和推广
