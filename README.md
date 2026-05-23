# Claude for Legal CN to Codex

将 [Claude for Legal (China Law)](https://github.com/SH88-source/claude-for-legal-CN) 的中国法工作流一键移植到 **Codex Desktop**。覆盖诉讼仲裁、商事合同、劳动用工、数据合规、知识产权等 12 个核心法律领域，安装即用、自动更新。

> **新用户？** 从 [QUICKSTART.md](QUICKSTART.md) 开始 —— 60 秒完成安装。

---

> **重要声明**
> 所有技能输出均为律师审查草稿，不构成法律意见，不能替代执业律师。
> 引用法规须核验现行有效性，提交/发送前需经执业律师审核。

---

## 一键安装

> **Windows 用户**：如果遇到执行策略限制，先运行：
> ```powershell
> Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
> ```

```powershell
git clone https://github.com/laubeing-droid/Claude-for-Legal-CN-to-Codex.git
cd Claude-for-Legal-CN-to-Codex
.\install.ps1
```

重启 Codex Desktop，直接描述法律任务即可自动启用。

---

## 仓库内容

| 文件 | 说明 |
|------|------|
| `install.ps1` | 一键安装：克隆上游、部署 13 个技能、委托 MCP 连接器安装 |
| `update.ps1` | 手动同步：上游更新 → 技能同步 → MCP 验证/更新 |
| `uninstall.ps1` | 删除所有已安装技能和上游缓存 |
| `verify.ps1` | 检查 13 个技能是否安装完整 |
| `skills/` | 13 个技能入口定义（SKILL.md） |
| `docs/` | 完整中文文档 |
| `.github/workflows/` | 上游监测 GitHub Actions |

---

## MCP 法律检索连接器

本仓库的 MCP 配置委托给独立仓库 [Codex-Claude-legal-CN-mcp-connectors](https://github.com/laubeing-droid/Codex-Claude-legal-CN-mcp-connectors) 管理，`install.ps1` 和 `update.ps1` 自动调用。支持三种连接方式：

| 连接器 | 方式 | 工具数 | 推荐 |
|--------|------|--------|------|
| **chineselaw（元典智库）** | MCP 协议 stdio | 33 | ⭐ 首选 |
| **北大法宝 MCP 协议** | MCP 协议 HTTP | 10 服务 | 推荐 |
| **北大法宝 CLI 命令行** | CLI 工具 | — | 调试/验证 |

> 编辑 `~/.codex/config.toml` → 替换凭证 → 重启 Codex。
>
> **安全提醒**：API 密钥通过 `config.toml` 或环境变量注入，**不要将凭证提交到 Git**。本仓库不包含任何密钥文件。

---

## 技能清单

| 技能 | 领域 | 子技能数 |
|------|------|:--------:|
| `claude-legal-cn` | 根技能（路由+自动更新） | — |
| `commercial-legal` | 商事合同 | 12 |
| `litigation-legal` | 诉讼仲裁 | 19 |
| `employment-legal` | 劳动用工 | 20 |
| `privacy-legal` | 数据合规 | 9 |
| `corporate-legal` | 公司交易 | 13 |
| `ip-legal` | 知识产权 | 12 |
| `product-legal` | 产品合规 | 7 |
| `regulatory-legal` | 监管合规 | 9 |
| `ai-governance-legal` | AI 治理 | 10 |
| `law-student` | 法学生/法考 | 13 |
| `legal-clinic` | 法律诊所 | 16 |
| `legal-builder-hub` | 技能治理中心 | 10 |
| `solo-law-firm` | 独立执业（8部门） | 26 |

---

## 自动路由

直接在 Codex 中描述法律任务，系统自动识别并调用对应技能：

| 你说 | 路由到 |
|------|--------|
| 帮我审查这份 SaaS 服务协议 | `commercial-legal` |
| 分析这个案件的管辖权问题 | `litigation-legal` |
| 评估个人信息保护合规风险 | `privacy-legal` |
| 起草一份竞业限制协议 | `employment-legal` |
| 做个并购尽调问题清单 | `corporate-legal` |
| 查一下这个商标能不能注册 | `ip-legal` |
| 检查这个产品上线合规性 | `product-legal` |
| 追踪最近三个月的监管动态 | `regulatory-legal` |
| 评估这个 AI 产品的法律风险 | `ai-governance-legal` |
| 帮我分析这个法考案例 | `law-student` |
| 法律援助接谈记录 | `legal-clinic` |

也可手动指定：`@claude-legal-cn 帮我审这份合同`

---

## 架构

```
Claude-for-Legal-CN-to-Codex           ← 包装层（本仓库）
  skills/*/SKILL.md                    入口定义 + 路由规则
  install.ps1 / update.ps1             安装与更新
  docs/                                文档
       │
       ▼
~/.codex/vendor/claude-for-legal-CN/   ← 内容层（上游缓存）
  CLAUDE.md + references                工作流指令 + 法条参考
       │
       ▼
~/.codex/skills/<domain>/             ← 运行层
  SKILL.md + CLAUDE.md + references
       │
       ▼
~/.codex/config.toml                  ← MCP 层（由 mcp-connectors 仓库管理）
  [mcp_servers.chineselaw]
  [mcp_servers.pkulaw-*]
```

---

## 上游依赖链

```
anthropics/claude-for-legal        ─  Anthropic 官方, 美国法参考实现
  → zhou210712/claude-for-legal-ZH ─  首版中国法汉化适配
    → SH88-source/claude-for-legal-CN ─  持续维护（本仓库直接上游）
      → gjhcsjamin/codex-for-legal-CN ─  Codex 平台首次封装
        → Claude-for-Legal-CN-to-Codex ─  本仓库（全功能整合）
```

详细分析见 [docs/project-analysis.md](docs/project-analysis.md)。

---

## 上游监测

GitHub Actions 每周一自动执行：

| 监测目标 | 行为 |
|---------|------|
| claude-for-legal 上游链（4 仓库） | 检测新提交 -> 创建 Issue |
| npm 包（chineselaw-mcp, @pkulaw/mcp-cli） | 检测新版本 -> 创建 Issue |
| **solo-law-firm-agents** | 检测新技能 -> **自动同步 + 创建 PR** |

> solo-law-firm 新增技能自动按部门合入；已合并/重命名技能跳过自动同步，标记需人工审核。
> 详见 [docs/architecture.md](docs/architecture.md)

---


## solo-law-firm 独立执业技能集

本仓库同时内置了 [saysoph/solo-law-firm-agents](https://github.com/saysoph/solo-law-firm-agents) 的修改版（26 个自包含技能，8 个部门），专为独立执业律师设计：

| 部门 | 核心技能 |
|------|------|
| **案件实务部** (5) | 合同审查、法律检索、诉讼策略、文书撰写、证据分析与管理 |
| **案件管理部** (3) | 案件排期、时效监控、庭前准备 |
| **客户关系部** (3) | 初次咨询、客户沟通（含进展通报）、满意度回访 |
| **尽职调查部** (4) | 企业背调、股权穿透、诉讼风险排查、资产线索追踪 |
| **市场拓展部** (4) | SEO优化、公众号、小红书/知乎、短视频策划 |
| **财务行政部** (3) | 收费策略、利润核算、发票催收 |
| **知识管理部** (3) | 案例模板脱敏、法官偏好分析、法规动态监控 |
| **风控合规部** (1) | 利益冲突排查 |

> 技能对照索引详见 [docs/skills-crosswalk.md](docs/skills-crosswalk.md)

| 你说 | 路由到 |
|------|--------|
| 帮我查一下对方公司有没有诉讼记录 | `solo-law-firm` (尽职调查部) |
| 这个案子该报多少钱 | `solo-law-firm` (收费策略顾问) |
| 客户问案件进度，帮我写个回复 | `solo-law-firm` (客户沟通起草) |
| 帮我写个抖音普法脚本 | `solo-law-firm` (短视频策划) |
| 明天开庭，检查一下要带什么 | `solo-law-firm` (庭审准备清单) |

## 许可证

Apache License 2.0。