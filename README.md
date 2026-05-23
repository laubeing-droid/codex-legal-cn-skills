# Codex 中国法律技能包

面向中国律师的 Codex 法律工作技能集。覆盖诉讼仲裁、商事合同、劳动用工、
数据合规、知识产权等 12 个核心法律领域，安装即用、自动更新。

## 快速安装

```powershell
git clone https://github.com/laubeing-droid/codex-legal-cn-skills.git
cd codex-legal-cn-skills
.\install.ps1
```

重启 Codex Desktop，直接描述法律任务即可自动启用。

## 包含的技能

| 技能 | 领域 | 内容量 |
|------|------|--------|
| codex-for-legal-cn | 根技能（自动路由 + 自动更新） | - |
| commercial-legal | 商事合同审查、交易文件起草 | 43KB + 12子技能 |
| litigation-legal | 诉讼仲裁、证据管理、文书起草 | 28KB + 19子技能 |
| employment-legal | 劳动用工、解除审查、竞业限制 | 32KB + 20子技能 |
| privacy-legal | 数据合规、个人信息保护 | 25KB + 9子技能 |
| corporate-legal | 公司治理、并购尽调 | 27KB + 13子技能 |
| ip-legal | 知识产权、商标专利、FTO | 17KB + 12子技能 |
| product-legal | 产品合规、广告审查 | 23KB + 7子技能 |
| regulatory-legal | 监管合规、动态监测 | 10KB + 9子技能 |
| ai-governance-legal | AI 治理、算法伦理 | 16KB + 10子技能 |
| law-student | 法考、案例学习 | 35KB + 13子技能 |
| legal-clinic | 法律诊所、法律援助 | 29KB + 16子技能 |
| legal-builder-hub | 技能治理中心 | 11KB + 10子技能 |

## 自动更新

每次在 Codex 中触发法律任务时，系统自动 git pull 上游最新内容并同步到本地。
静默执行，本次对话直接生效。

## 上游监测

GitHub Actions 每周一自动检查整条上游链的更新：
- anthropics/claude-for-legal（美国法原版）
- zhou210712/claude-for-legal-ZH（汉化版）
- SH88-source/claude-for-legal-CN（当前上游）
- gjhcsjamin/codex-for-legal-CN（Codex 封装）
有变化时自动创建 Issue 通知。

## 架构

本仓库是包装层，不包含上游法律内容副本。安装时自动拉取 SH88-source/claude-for-legal-CN。
详细说明见 docs/ 目录。

## 许可证

Apache License 2.0。上游内容基于 SH88-source/claude-for-legal-CN，原始版权归 Anthropic PBC。
