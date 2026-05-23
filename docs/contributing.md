# 贡献指南

## 仓库结构

`
Claude-for-Legal-CN-to-Codex/
  skills/
    codex-claude-legal-cn/      根路由（关键词 + 自动更新）
    <domain>/SKILL.md            12 领域入口定义（薄，托管上游）
    solo-law-firm/               独立执业技能集（厚，自包含）
      01-case-practice/           案件实务部 (5)
      02-case-management/         案件管理部 (3)
      03-client-relations/        客户关系部 (3)
      04-due-diligence/           尽职调查部 (4)
      05-business-development/    市场拓展部 (4)
      06-finance-admin/           财务行政部 (3)
      07-knowledge-management/    知识管理部 (3)
      08-risk-compliance/         风控合规部 (1)
  install.ps1                   一键安装脚本
  update.ps1                    更新脚本
  uninstall.ps1                 卸载脚本
  verify.ps1                    安装验证脚本
  docs/                         文档
  .github/workflows/            上游监测 + 自动同步
`

## 设计原则

本仓库是**包装层**，包含两套技能体系：

| 体系 | SKILL.md | 核心内容 | 维护方式 |
|------|----------|----------|----------|
| claude-for-legal-CN | 薄入口（路由 + 关键词） | 委托上游 CLAUDE.md | 薄入口可修改；工作流改上游 |
| solo-law-firm | 厚入口（完整角色 prompt） | 自包含 | 直接修改本仓库 SKILL.md |

## 本仓库适合修改的内容

- SKILL.md 的路由关键词和触发规则
- solo-law-firm 技能的完整 prompt（工作原则、输出格式、工作流程、禁止项）
- 安装/更新/卸载脚本
- MCP 连接器委托逻辑
- 文档完善
- GitHub Actions 工作流配置

## 本仓库不直接修改的内容

- claude-for-legal-CN 的 CLAUDE.md 工作流指令 — 请直接编辑上游 SH88-source/claude-for-legal-CN
- claude-for-legal-CN 的 references/ 法律参考文件 — 请直接编辑上游

## solo-law-firm 上游同步

solo-law-firm 技能的本地上游是 [saysoph/solo-law-firm-agents](https://github.com/saysoph/solo-law-firm-agents)（MIT），本仓库持有一份修改版（合并 2 项、重命名 2 项、部门调整 1 项、协作引用 19 项）。

GitHub Actions 每周自动检测上游更新：
- **新增技能** -> 自动创建 PR，按 department 放入对应目录
- **已合并/重命名的 4 个技能** -> 跳过自动同步，需人工比对后手动合入
- 跳过的技能: case-progress-reporter, evidence-manager, statute-monitor, regulation-monitor

如需同步上游对已合并技能的修改，请手动比对 diff 后合入对应目标技能。

## MCP 连接器修改

MCP 连接器由独立的 [Codex-Claude-legal-CN-mcp-connectors](https://github.com/laubeing-droid/Codex-Claude-legal-CN-mcp-connectors) 仓库管理。
如需新增或修改连接器，修改该仓库的文件。

## 提交 PR

1. 确保更改不影响现有功能
2. 更新相关文档
3. 提交 PR 到 https://github.com/laubeing-droid/Claude-for-Legal-CN-to-Codex
