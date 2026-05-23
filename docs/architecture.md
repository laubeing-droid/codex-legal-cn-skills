# 架构说明

## 三层结构

本仓库采用三层架构设计，将**入口定义**、**法律内容**和**运行环境**分离：

```
codex-legal-cn-skills                    ← 包装层（本仓库）
  skills/*/SKILL.md                      入口定义 + 路由规则
  install.ps1                            一键安装
  update.ps1                             手动更新
  docs/                                  文档
         │
         │ 依赖上游（自动拉取）
         ▼
SH88-source/claude-for-legal-CN          ← 内容层
  commercial-legal/
    ├── CLAUDE.md                        完整工作流指令
    ├── references/                      中国法核心规则
    └── skills/*/SKILL.md                子技能
  litigation-legal/
  employment-legal/
  ...（共 12 个领域）
         │
         │ 安装到
         ▼
~/.codex/skills/<domain>/               ← 运行层
  ├── SKILL.md                           本仓库提供（入口）
  ├── CLAUDE.md                          上游同步（主指令）
  ├── references/                        上游同步（法条参考）
  └── skills/                            上游同步（子技能）
```

## 设计原则

每个技能包含两层指令：

1. **SKILL.md** —— 入口定义：该技能做什么、何时触发、路由规则
2. **CLAUDE.md** —— 完整工作流：具体步骤、输出框架、质量标准和安全护栏

这种分离设计使得：
- 本仓库专注入口管理和平台适配
- 上游仓库专注法律内容维护
- 更新法律内容时不需要修改本仓库

## 更新流程

```
用户触发法律任务
  → 根技能 codex-for-legal-cn 激活
  → 执行 git pull 拉取上游最新内容
  → 同步 CLAUDE.md + references 到 ~/.codex/skills/
  → 读取最新内容完成任务
```

## 依赖关系

- **SH88-source/claude-for-legal-CN**（Apache 2.0）— 当前直接上游
  - 源流：anthropics/claude-for-legal（Anthropic 美国法参考）
  - 首版汉化：zhou210712/claude-for-legal-ZH

详细项目关系分析见 docs/project-analysis.md。
