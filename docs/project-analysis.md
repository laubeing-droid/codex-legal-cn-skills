# 项目关系分析

> 最后更新：2026-05-24 | 上游变更后应同步更新本文档

---

## 一、生态总览

六个项目分布在四个平台（Claude Code、Codex、浏览器、Workbuddy），构成中国法律 AI 工作流的生态链。本仓库作为 Codex 平台的整合入口，将上游内容以一鍵安装的方式交付给中国律师，并在此基础上持续**自行研发新技能**，补齐上游未覆盖的业务场景。

## 二、演进路线

```
anthropics/claude-for-legal              ─  Anthropic 官方, 美国法参考
  → CSlawyer1985/claude-for-legal-ZH     ─  fork 自 Anthropic，首次中国法汉化
    → zhou210712/claude-for-legal-ZH      ─  持续维护版（本仓库直接上游）
      ├→ drdavid-kor/claude-for-legal-cn-online  ─  在线网页版（浏览器）
      ├→ MAXXXXXLI/workbuddy-cn-legal-skills     ─  豆包工作台版
      └→ Claude-for-Legal-CN-to-Codex            ─  本仓库（Codex 全功能整合）
```

**本仓库的直接上游只有一个**：`zhou210712/claude-for-legal-ZH`。其余项目皆为同一生态内的衍生分支，不作为本仓库的依赖。

### 历史参考（不活跃依赖）

| 项目 | 与本仓库关系 |
|------|-------------|
| gjhcsjamin/codex-for-legal-CN | 同为 Codex 封装层，本仓库前身灵感来源，非内容依赖 |
| SH88-source/claude-for-legal-CN | 与 zhou210712/claude-for-legal-ZH 内容相同（仅改名），无独立维护价值 |

---

## 三、逐项目介绍

### anthropics/claude-for-legal
- **作者**: Anthropic PBC | **平台**: Claude Code | **许可证**: Apache 2.0
- **定位**: 法律工作流参考实现（12 插件 + 5 Agent 蓝图 + 16 MCP 连接器）
- **法律基础**: 美国法
- **意义**: 整个生态的源头项目

### CSlawyer1985/claude-for-legal-ZH
- **作者**: CSlawyer1985 | **平台**: Claude Code | **许可证**: Apache 2.0
- **定位**: 对 Anthropic 官方版进行中国法替换的首个版本（350 stars）
- **核心工作**: 合同法→民法典合同编、诉讼法→民事诉讼法、劳动法→劳动合同法
- **意义**: 中国法律 AI 工作流的发源版本

### zhou210712/claude-for-legal-ZH （本仓库直接上游）
- **作者**: zhou210712 | **平台**: Claude Code
- **定位**: 在 CSlawyer1985 基础上持续维护的中国法版本
- **核心贡献**: 中国法引用文件（11 个）+ CLAUDE.md 中文化 + MCP 连接器替换
- **意义**: 当前最活跃的中国法版本，本仓库的直接内容来源
- **安装依赖**: install.ps1 克隆此仓库到 `~/.codex/vendor/claude-for-legal-ZH/`

### drdavid-kor/claude-for-legal-cn-online
- **作者**: drdavid-kor | **平台**: 浏览器（Cloudflare Workers）
- **定位**: BYOK 在线 Web 应用，无需 CLI
- **意义**: 降低使用门槛，让不熟悉终端的律师也能使用

### MAXXXXXLI/workbuddy-cn-legal-skills
- **作者**: MAXXXXXLI | **平台**: Workbuddy（豆包）
- **定位**: 151 个中文命名的技能包，覆盖 12 个法律领域
- **意义**: 将法律 AI 技能扩展到豆包工作台用户

### gjhcsjamin/codex-for-legal-CN（历史参考）
- **作者**: gjhcsjamin | **平台**: Codex（OpenAI CLI）
- **定位**: 首次将中国法律技能带到 Codex 平台的封装层（5 个文件，20 KB）
- **内容**: 仅含 SKILL.md 模板 + 安装脚本，无法律内容，委托上游 CSlawyer1985
- **意义**: 本仓库的包装层思路来源。不做内容、只做包装的设计已被本仓库超越：本仓库既有包装层，也有自研技能和 solo-law-firm

### Claude-for-Legal-CN-to-Codex（本仓库）
- **作者**: laubeing-droid | **平台**: Codex Desktop
- **定位**: Codex 平台的全功能整合包装层 + 自主研发技能
- **核心资产**:

  | 资产 | 说明 |
  |------|------|
  | 14 个 SKILL.md | 1 个根路由 + 12 领域入口 + 1 个 solo-law-firm 入口 |
  | solo-law-firm 技能集 | 27 个自包含执业技能（8 部门），含自行研发新增技能 |
  | install.ps1 | 一键安装（上游克隆+技能部署+MCP 配置） |
  | update.ps1 | 手动同步（5 步流程） |
  | 自动更新 | 每次使用法律功能时自动 git pull 上游 |
  | GitHub Actions | 每周监测上游 + npm 包更新 |
  | 全中文文档 | 使用指南、架构、项目分析等 |
  | patches/zhou210712/ | 上游中国化补丁快照（41 文件，用于追踪上游变更） |

---

## 四、saysoph/solo-law-firm-agents 贡献与致谢

本仓库内置的 solo-law-firm 技能集源自 [saysoph/solo-law-firm-agents](https://github.com/saysoph/solo-law-firm-agents)（MIT 许可证），该项目由 **saysoph** 独立创建和维护，为独立执业律师设计了 26 个覆盖 8 个部门的厚技能。本仓库在此基础之上进行了以下工作：

| 类型 | 说明 |
|------|------|
| **上游适配** | 将原始 Claude Code 格式的技能迁移为 Codex Desktop SKILL.md 格式 |
| **合并优化** | 将 2 组功能重叠的技能合并（证据分析+证据管理→evidence-analyst；statute-monitor→regulatory-change-monitor） |
| **引用补全** | 为 19 个技能补全上下游协作引用关系 |
| **自主研发** | 在 saysoph 上游未覆盖的场景下，自行研发新技能补全业务闭环 |

### 本仓库自行研发的新技能

| 技能 | 归属部门 | 说明 |
|------|------|------|
| **trial-outline-generator**（庭审提纲自动生成器） | 02-案件管理部 | 五阶段流水线自动生成标准化开庭提纲，覆盖案件信息、诉请主张、各方观点、证据调查、争议焦点与法律依据、待办事项六大板块。补齐了 solo-law-firm 从"庭前准备核查"到"开庭发言"之间的关键环节 |

> 凡是对 saysoph 上游的修改（合并、重命名、部门调整），均在被修改技能的原始 metadata 中通过 `merged-from` 或 `original-name` 字段标明来源，确保贡献可追溯。

---

## 五、关键对比

| 维度 | anthropics | zhou210712 | drdavid-kor | MAXXXXXLI | **本仓库** |
|------|-----------|-----------|-------------|-----------|-----------|
| 目标平台 | Claude Code | Claude Code | 浏览器 | Workbuddy | **Codex** |
| 法律体系 | 美国法 | 中国法 | 中国法 | 中国法 | **中国法** |
| 安装方式 | 多步 | 多步 | 打开网页 | 上传 zip | **1 步** |
| 自动更新 | 手动 | 手动 | 重新部署 | 重新下载 | **自动** |
| 文档语言 | 英文 | 中文 | 中文 | 中文 | **中文** |
| 自研技能 | — | — | — | — | **是** |

> gjhcsjamin/codex-for-legal-CN 未列入对比表——它不是与上述项目并列的独立项目，而是本仓库前身，功能上已被本仓库完整覆盖。

---

## 六、本仓库的定位

### 解决的问题

| 需求 | 上游状态 | 本仓库方案 |
|------|---------|-----------|
| 在 Codex 上使用中国法技能 | 需手动克隆配置 | `install.ps1` 一键安装 |
| 保持技能最新 | 手动更新 | 自动 git pull + Actions 监测 |
| 中文文档 | 英文为主 | 完整中文文档体系 |
| MCP 连接器配置 | 需手动编辑 | 委托独立仓库自动管理 |
| 庭审提纲自动生成 | 上游无覆盖 | 自行研发 trial-outline-generator |

### 不涉及的范围

- 不直接修改上游的法律内容原文（solo-law-firm 修改版通过 metadata 标明来源）
- 不提供在线网页版服务
- 不跨平台转码（如转为 Workbuddy 格式）

### 核心设计原则

1. **上游唯一**：法律工作流内容只依赖 `zhou210712/claude-for-legal-ZH` 一个来源
2. **包装层分离**：SKILL.md 负责路由，CLAUDE.md 委托上游
3. **自主补全**：上游未覆盖的场景自行研发
4. **自动同步**：每次启用时 git pull 上游
5. **来源可追溯**：所有衍生修改通过 metadata 标明原始来源
