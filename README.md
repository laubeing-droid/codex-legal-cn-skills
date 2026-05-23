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
> 所有技能输出均为律师审查草稿，不构成法律意见，不能替代律师。
> 引用法规须核验现行有效性，提交/发送前需经执业律师审核。

---

## 仓库内容

| 文件 | 说明 |
|------|------|
| install.ps1 | 一键安装：克隆上游、部署技能、委托 MCP 连接器安装 |
| update.ps1 | 同步上游 + 技能更新 + 委托 MCP 连接器验证/更新 |
| uninstall.ps1 | 一键卸载所有已安装技能和上游缓存 |
| verify.ps1 | 检查安装完整性 |
| skills/ | 13 个技能入口定义（SKILL.md） |
| docs/ | 完整中文文档 |
| .github/workflows/ | 上游监测 GitHub Actions |

---

## MCP 法律检索连接器

MCP 配置由独立仓库 [codex-legal-mcp-connectors](https://github.com/laubeing-droid/codex-legal-mcp-connectors) 管理，
`install.ps1` 和 `update.ps1` 均自动委托给该仓库。支持三种方式：

| 连接器 | 方式 | 工具数 | 推荐 |
|--------|------|--------|------|
| **chineselaw（元典智库）** | MCP 协议 stdio | 33 | ⭐ 首选 |
| **北大法宝 MCP 协议** | MCP 协议 HTTP | 10 服务 | 推荐 |
| **北大法宝 CLI 命令行** | CLI 工具 | — | 调试/验证 |

快速配置：编辑 `~/.codex/config.toml` → 替换凭证 → 重启 Codex。
详细指南见 [MCP 连接器仓库](https://github.com/laubeing-droid/codex-legal-mcp-connectors)。

---

## 技能清单

| skill | area | size |
|-------|------|------|
| codex-for-legal-cn | 根技能（路由+更新） | - |
| commercial-legal | 商事合同 | 43KB + 12 sub-skills |
| litigation-legal | 诉讼仲裁 | 28KB + 19 sub-skills |
| employment-legal | 劳动用工 | 32KB + 20 sub-skills |
| privacy-legal | 数据合规 | 25KB + 9 sub-skills |
| corporate-legal | 公司交易 | 27KB + 13 sub-skills |
| ip-legal | 知识产权 | 17KB + 12 sub-skills |
| product-legal | 产品合规 | 23KB + 7 sub-skills |
| regulatory-legal | 监管合规 | 10KB + 9 sub-skills |
| ai-governance-legal | AI 治理 | 16KB + 10 sub-skills |
| law-student | 法学生/法考 | 35KB + 13 sub-skills |
| legal-clinic | 法律诊所 | 29KB + 16 sub-skills |
| legal-builder-hub | 技能治理中心 | 11KB + 10 sub-skills |

---

## 自动路由

| 你说 | 路由到 |
|------|--------|
| 帮我审查这份 SaaS 服务协议 | commercial-legal |
| 分析这个案件的管辖权问题 | litigation-legal |
| 评估个人信息保护合规风险 | privacy-legal |
| 起草一份竞业限制协议 | employment-legal |
| 做个并购尽调问题清单 | corporate-legal |
| 查一下这个商标能不能注册 | ip-legal |
| 检查这个产品上线合规性 | product-legal |
| 追踪最近三个月的监管动态 | regulatory-legal |
| 评估这个 AI 产品的法律风险 | ai-governance-legal |
| 帮我分析这个法考案例 | law-student |
| 法律援助接谈记录 | legal-clinic |

也可手动指定：@codex-for-legal-cn 帮我审这份合同

---

## 自动更新机制

每次触发法律任务时，根技能自动 git pull 同步上游。手动更新：`.\update.ps1`
`update.ps1` 会同步技能包装层，并委托 `codex-legal-mcp-connectors` 仓库处理 MCP 连接器检查与更新。

---

## 架构

```
codex-legal-cn-skills                  ← 包装层（本仓库）
  skills/SKILL.md                      入口定义 + 路由规则
  install.ps1 / update.ps1             安装与更新
  docs/                                文档
       |
       ▼
~/.codex/vendor/claude-for-legal-CN/   ← 内容层（上游缓存）
  CLAUDE.md + references                工作流指令 + 法条参考
       |
       ▼
~/.codex/skills/<domain>/              ← 运行层
  SKILL.md + CLAUDE.md + references
       |
       ▼
~/.codex/config.toml                   ← MCP 层（由 mcp-connectors 仓库管理）
  [mcp_servers.chineselaw]
  [mcp_servers.pkulaw-*]
```

---

## 上游依赖链

```
anthropics/claude-for-legal → zhou210712/claude-for-legal-ZH
→ SH88-source/claude-for-legal-CN → codex-legal-cn-skills（本仓库）
```

详细项目分析见 docs/project-analysis.md。

---

## 上游监测

GitHub Actions 每周一自动检查上游链更新，仅在检测到实际变化时创建 Issue。

---

## 许可证

Apache License 2.0。
