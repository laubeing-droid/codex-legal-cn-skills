# 贡献指南

## 仓库结构

```
codex-legal-cn-skills/
  skills/<domain>/SKILL.md   入口定义
  install.ps1                安装脚本
  update.ps1                 更新脚本
  docs/                      文档
  .github/workflows/         GitHub Actions
```

## 设计原则

每个技能包含两层指令：
1. **SKILL.md** — 入口定义：做什么、何时使用
2. **CLAUDE.md** — 完整工作流：步骤、输出框架、质量和护栏

## 编辑技能

本仓库的 SKILL.md 是轻量入口，核心工作流指令在上游仓库的 CLAUDE.md 中。
如需修改法律工作流内容，请直接编辑上游仓库。

本仓库适合做的修改：
- 优化路由关键词
- 调整安装/更新脚本
- 补充文档

## 提交 PR

1. 确保更改不影响现有功能
2. 更新相关文档
3. 提交 PR 到 GitHub 仓库
