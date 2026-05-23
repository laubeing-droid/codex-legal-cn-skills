# Codex 中国法律技能包

面向中国律师的 Codex 法律工作技能集。覆盖诉讼仲裁、商事合同、劳动用工、
数据合规、知识产权等 12 个核心法律领域，安装即用、自动更新。

> **新用户？** 从 QUICKSTART.md 开始 —— 60 秒完成安装。本文档是完整参考手册。

---

## 快速安装

```powershell
git clone https://github.com/laubeing-droid/codex-legal-cn-skills.git
cd codex-legal-cn-skills
.\install.ps1
```

重启 Codex Desktop，直接描述法律任务即可自动启用。

---

> **重要声明**
> **这些技能的所有输出均为律师审查草稿 —— 不是法律意见，不是法律结论，不能替代律师。**
> 它们内置了安全机制：每条引用标注来源、涉及主观法律判断默认保守处理、
> 管辖权假设明示标注、任何提交/发送/依赖前有明确门槛。
> 律师审查、核实并对所有对外产出承担专业责任。这些技能让审查更快，但不能替代审查。
> **这些技能不代表任何法律立场。** 它们是帮助律师分析问题的工具。
> 使用技能的律师 —— 而非技能本身 —— 对其工作成果中的法律立场负责。

---

## 仓库内容

- 12 个领域技能 —— 每个领域围绕冷启动访谈构建，学习你的工作方式
- 根技能自动路由 —— codex-for-legal-cn 根据关键词自动分发到对应领域
- 自动更新机制 —— 每次使用法律功能时自动 git pull 同步上游最新内容
- 上游监测 —— GitHub Actions 每周自动检查 4 个上游仓库的更新

---

## 技能清单

skill               | area                  | size
--------------------|-----------------------|-------
codex-for-legal-cn  | 根技能（路由+更新）   | -
commercial-legal    | 商事合同              | 43KB + 12 sub-skills
litigation-legal    | 诉讼仲裁              | 28KB + 19 sub-skills
employment-legal    | 劳动用工              | 32KB + 20 sub-skills
privacy-legal       | 数据合规              | 25KB + 9 sub-skills
corporate-legal     | 公司交易              | 27KB + 13 sub-skills
ip-legal            | 知识产权              | 17KB + 12 sub-skills
product-legal       | 产品合规              | 23KB + 7 sub-skills
regulatory-legal    | 监管合规              | 10KB + 9 sub-skills
ai-governance-legal | AI 治理               | 16KB + 10 sub-skills
law-student         | 法学生/法考           | 35KB + 13 sub-skills
legal-clinic        | 法律诊所              | 29KB + 16 sub-skills
legal-builder-hub   | 技能治理中心          | 11KB + 10 sub-skills

## 自动路由

you say                          | routes to
---------------------------------|----------
帮我审查这份 SaaS 服务协议       | commercial-legal
分析这个案件的管辖权问题         | litigation-legal
评估个人信息保护合规风险         | privacy-legal
起草一份竞业限制协议             | employment-legal
做个并购尽调问题清单             | corporate-legal
查一下这个商标能不能注册         | ip-legal
检查这个产品上线合规性           | product-legal
追踪最近三个月的监管动态         | regulatory-legal
评估这个 AI 产品的法律风险       | ai-governance-legal
帮我分析这个法考案例             | law-student
法律援助接谈记录                 | legal-clinic

也可以手动指定：
```
@codex-for-legal-cn 帮我审这份合同
@litigation-legal 分析一下证据问题
@commercial-legal/review 审查这份 NDA
```

---

## 自动更新机制

每次在 Codex 中触发法律任务时，根技能自动执行：
1. 查找上游仓库（优先本仓库同级目录，其次 vendor 链接）
2. git pull 拉取 SH88-source/claude-for-legal-CN 最新内容
3. 同步 CLAUDE.md + references + 子技能到 ~/.codex/skills/
4. 本次对话直接生效，无需重启

手动更新：
```powershell
.\update.ps1
```

---

## 架构

```
codex-legal-cn-skills              <- 包装层（本仓库）
  skills/SKILL.md                  入口定义 + 路由规则
  install.ps1                      一键安装
  update.ps1                       手动更新
  docs/                            文档
       |
       | 依赖上游
       v
SH88-source/claude-for-legal-CN    <- 内容层
  CLAUDE.md                        完整工作流指令
  references/                      中国法核心规则
  skills/                          子技能
  agents/                          托管 Agent
  .mcp.json                        MCP 连接配置
       |
       | 安装到
       v
~/.codex/skills/<domain>/           <- 运行层
  SKILL.md                         本仓库提供（入口）
  CLAUDE.md                        上游同步（主指令）
  references/                      上游同步（法条参考）
  skills/                          上游同步（子技能）
```

### 设计原则
每个技能包含两层指令：
- **SKILL.md** —— 入口定义：该技能做什么、何时使用
- **CLAUDE.md** —— 完整工作流：步骤、输出框架、质量标准和护栏

---

## 上游依赖链

```
anthropics/claude-for-legal        <- 美国法原版（Anthropic 官方）
  | fork + 全面汉化
  v
zhou210712/claude-for-legal-ZH     <- 原始中文汉化版
  | fork + 改名
  v
SH88-source/claude-for-legal-CN    <- 当前直接上游
  | 本仓库包装层
  v
codex-legal-cn-skills              <- 你在这里
  | 安装到 Codex
  v
~/.codex/skills/                   <- 运行层
```

上游角色：
- **anthropics/claude-for-legal**: 最上游，美国法 Claude Code 插件
- **zhou210712/claude-for-legal-ZH**: 原始汉化版，美国法全面汉化为中国法
- **SH88-source/claude-for-legal-CN**: 改名版
- **codex-legal-cn-skills**: 包装层（本仓库），SKILL.md 入口 + 路由 + 自动更新

详细分析见 docs/project-analysis.md。

---

## 上游监测

GitHub Actions 每周一自动检查整条上游链的更新。
有变化时自动在当前仓库创建 Issue 通知。

监测对象：anthropics/claude-for-legal, zhou210712/claude-for-legal-ZH,
SH88-source/claude-for-legal-CN, gjhcsjamin/codex-for-legal-CN

---

## 连接器（MCP）

预配置了 yuandian（元典）MCP 连接器用于案例检索和法规检索。
详情见 docs/connectors.md。

---

## 常见问题

- **Command not found？** 重启 Codex Desktop
- **引用标注[需验证]？** 连接法律检索工具
- **输出不准确？** 所有输出均为草稿，引用须核验现行有效性

---

## 许可证

Apache License 2.0。上游内容基于 SH88-source/claude-for-legal-CN，
原始版权归 Anthropic PBC。
