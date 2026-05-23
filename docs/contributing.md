# 贡献指南

感谢你希望为这个项目做出贡献。

## 仓库结构

```
codex-legal-cn-skills/
  skills/<domain>/SKILL.md   入口定义（轻量）
  install.ps1                安装脚本
  update.ps1                 更新脚本
  docs/                      文档
  .github/workflows/         GitHub Actions 配置
```

## 两层指令设计

每个技能包含两层指令：

1. **SKILL.md** — 入口定义：做什么、何时使用、路由关键词
2. **CLAUDE.md** — 完整工作流（位于上游仓库）：步骤、输出框架、质量标准和护栏

## 编辑指南

### 本仓库适合修改的内容
- SKILL.md 中的路由关键词和触发规则
- 安装/更新脚本（install.ps1, update.ps1）
- 文档完善（docs/ 目录下所有文件）
- GitHub Actions 工作流配置

### 本仓库不直接修改的内容
- 法律工作流指令（CLAUDE.md）— 请直接编辑上游仓库
- 法律参考文件（references/）— 请直接编辑上游仓库
- 子技能内容 — 请直接编辑上游仓库

### 法律内容修改流程
如需修改法律工作流内容（如调整某个领域的审查标准）：
1. 修改上游仓库（SH88-source/claude-for-legal-CN 或更上游）
2. 本仓库的自动更新机制会在下次使用时同步变更

## 提交 PR

1. 确保更改不影响现有功能
2. 更新相关文档
3. 提交 PR 到 https://github.com/laubeing-droid/codex-legal-cn-skills
