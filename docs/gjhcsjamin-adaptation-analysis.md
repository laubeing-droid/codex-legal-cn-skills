# gjhcsjamin/codex-for-legal-CN → anthropics/claude-for-legal 对比分析

> 分析日期：2026-05-24
> 对比对象：anthropics/claude-for-legal（美国法原版）vs gjhcsjamin/codex-for-legal-CN（Codex 封装层）

---

## 一、结论先行

**gjhcsjamin/codex-for-legal-CN 与 zhou210712/claude-for-legal-ZH 不是同一类东西。**

| 维度 | zhou210712 | gjhcsjamin |
|------|-----------|-----------|
| 定位 | **内容修改层** | **Codex 包装层** |
| 做了什么 | 改写 CLAUDE.md + 新增中国法引用 + 替换 MCP | 生成薄 SKILL.md 入口 |
| 中国法内容 | ✅ 11 个引用文件 + 中文化 | ❌ 无（只是引用上游） |
| 文件数 | 150+ SKILL.md + 41 个独有文件 | 5 个文件（不含上游内容） |
| 依赖 upstream | 自身就是 upstream | 依赖 CSlawyer1985 上游 |

---

## 二、gjhcsjamin 仓库结构

```
codex-for-legal-CN/
├── README.md            安装和使用说明（中文，2629 字节）
├── LICENSE              Apache 2.0
├── docs/
│   └── auto-routing.md  自动路由规则说明（中文，1078 字节）
├── scripts/
│   └── install.py       Codex 安装脚本（3721 字节）
└── templates/
    └── root-skill.md.tpl 根技能模板（1563 字节）
```

**总文件：5 个，总大小：20 KB**

相较于 anthropics（150+ 文件，~3.5 MB），gjhcsjamin 仓库本身没有法律内容。

---

## 三、gjhcsjamin 具体做了哪些工作

### 3.1 生成的 SKILL.md 模板（核心贡献）

install.py 为 12 个领域各生成一个薄 SKILL.md，结构如下：

```yaml
---
name: litigation-legal
description: 诉讼仲裁、案件管理、证据三性、大事记与文书草拟。封装自本地安装的 codex-for-legal-CN / claude-for-legal-ZH。
---

# litigation-legal

## 何时使用
- 用户任务与 litigation-legal 领域直接相关
- 需要参考中国法工作方法、输出结构、清单和提示模板

## 本地来源
- 上游模块：~/.codex/vendor/claude-for-legal-ZH/litigation-legal
- 主提示：~/.codex/vendor/claude-for-legal-ZH/litigation-legal/CLAUDE.md

## 使用步骤
1. 先读该模块 README，确认边界。
2. 再读 CLAUDE，按它的输出框架做事。
3. 只加载当前任务必要的 references。
4. 法源与案例必须另行核验。
```

**与 anthropic 的 SKILL.md 对比：**

| 维度 | anthropic 的 SKILL.md | gjhcsjamin 生成的 SKILL.md |
|------|---------------------|---------------------------|
| 篇幅 | 2-48 KB（含完整 prompt） | ~1.5 KB（薄入口） |
| 角色定义 | 详细的审查标准、输出格式、禁止项 | 仅说"去读上游 CLAUDE.md" |
| 处理流程 | 完整的 Checklist 和工作流 | 只有 4 条使用步骤 |
| 中国法内容 | 美国法框架 | 无（委托上游） |

### 3.2 根技能自动路由（模板贡献）

`templates/root-skill.md.tpl` 定义了一个总入口 `codex-for-legal-cn`，包含：

- 9 组自动路由规则（诉讼→litigation-legal，合同→commercial-legal 等）
- 3 条工作规则（判定→选择→读取→核验）
- 比 anthropic 的根技能更简洁（anthropic 的根 CLAUDE.md 有 101 行开发者指南）

### 3.3 install.py 安装脚本

| 步骤 | 说明 |
|------|------|
| 检查上游 | 确认 `~/.codex/vendor/claude-for-legal-ZH` 存在 |
| 复制自身 | 将本仓库复制到 `vendor/codex-for-legal-CN` |
| 生成根技能 | 渲染模板到 `skills/codex-for-legal-cn/SKILL.md` |
| 生成 12 领域技能 | 循环生成薄 SKILL.md |
| 生成注册表 | 输出 `installed-modules.json` |

**与 anthropic 安装方式的对比：** anthropic 是 Claude Code 插件市场，通过 `/plugin marketplace add` 安装；gjhcsjamin 是手动脚本安装。

### 3.4 文档中文化

- README.md：全中文，面向中国律师
- docs/auto-routing.md：全中文，路由规则说明
- 法律术语全中文（诉讼仲裁、合同审查、劳动用工等）

---

## 四、gjhcsjamin 没做的事

| 事项 | anthropic 有 | gjhcsjamin 有 | 说明 |
|------|-------------|:------------:|------|
| CLAUDE.md 工作流指令 | 每个领域 200-500 行 | ❌ | 委托上游，仓库内没有 |
| references/ 法条引用 | 仅 currency-watch.md | ❌ | 委托上游 |
| agents/ 子代理定义 | 按领域分布 | ❌ | 未实现 |
| .mcp.json 连接器 | 各领域独立配置 | ❌ | 未实现 |
| managed-agent-cookbooks | 5 个 Cookbook | ❌ | 未实现 |
| 中国法内容 | ❌（美国法） | ❌ | 没有也不创造中国法内容 |
| 技能子技能 | 150 个子技能 | ❌ | 仅生成 12 个入口 |
| hooks/ 钩子 | 各领域有 hooks.json | ❌ | 未实现 |

---

## 五、与 zhou210712 的对比

| 维度 | zhou210712/claude-for-legal-ZH | gjhcsjamin/codex-for-legal-CN |
|------|-------------------------------|-------------------------------|
| 本质 | **内容修改层** | **平台包装层** |
| 上游 | fork 自 CSlawyer1985 | 引用 CSlawyer1985 |
| 修改了 CLAUDE.md | ✅ 全部中文化 | ❌ |
| 新增中国法 reference | ✅ 11 个 | ❌ |
| 替换 MCP 连接器 | ✅ 全部替换为中国生态 | ❌ 没做 |
| Codex 兼容 | ❌（Claude Code 格式） | ✅ 生成 Codex SKILL.md |
| 可独立安装 | ✅ 可直接用 | ❌ 需要上游 |
| 本仓库借鉴 | 上游内容来源 | 包装层思路来源 |

**简而言之：** 你要的是 zhou210712 的内容 + gjhcsjamin 的包装思路 = 你现在这个仓库做的事。

---

## 六、对本仓库的价值

| 可借鉴的点 | 说明 |
|----------|------|
| **自动路由规则** | gjhcsjamin 的 9 组路由规则和本仓库的 claude-legal-cn 路由思路一致 |
| **薄入口设计** | SKILL.md 只负责路由，内容委托上游——这个架构本仓库沿用了 |
| **install.py 的模块注册表** | 生成 installed-modules.json 的思路可以借鉴 |
| **安装前提检查** | 安装前确认上游存在，避免装了一半报错 |

| 不需要模仿的点 | 理由 |
|-------------|------|
| **不做内容只做包装** | 本仓库已经有自研技能和 solo-law-firm，不只是包装层 |
| **没有 MCP 配置** | 本仓库有独立的 mcp-connectors 仓库管理 |
| **没有 solo-law-firm** | 本仓库已有 solo-law-firm 技能集 |
