# 使用指南

## 一、安装

### 前置条件
- 已安装 Codex Desktop
- 操作系统：Windows 10/11
- 已安装 Git（[下载](https://git-scm.com/downloads)）
- Node.js >= 18（如使用 chineselaw-mcp，[下载](https://nodejs.org)）

### 安装步骤

```powershell
git clone https://github.com/laubeing-droid/codex-legal-cn-skills.git
cd codex-legal-cn-skills
.\install.ps1
```

安装脚本自动完成：
1. 克隆上游法律内容到 `~/.codex/vendor/claude-for-legal-CN/`
2. 创建 13 个技能目录和入口文件
3. **写入 MCP 连接器配置到 `~/.codex/config.toml`**
4. 配置 PowerShell 执行策略
5. 验证安装完整性

### 验证安装

```powershell
.\verify.ps1
```

---

## 二、配置 MCP 法律检索（关键步骤）

### 方式一：chineselaw（推荐，33 个工具）

1. 打开 https://open.chineselaw.com，注册并获取 API Key
2. 编辑 config.toml：

```powershell
notepad "$env:USERPROFILE\.codex\config.toml"
```

3. 找到 `[mcp_servers.chineselaw.env]`，将 `CHINESELAW_API_KEY` 的值替换为真实 Key
4. 重启 Codex Desktop

### 方式二：北大法宝（10 个服务）

1. 打开 https://mcp.pkulaw.com，注册并获取 Access Token
2. 编辑 config.toml，将所有 `"YOUR_ACCESS_TOKEN"` 替换为真实 Token
3. 重启 Codex Desktop

**完整配置指南和工具列表见 docs/connectors.md**。

---

## 三、使用方式

直接在 Codex 中描述法律任务，系统自动路由到对应技能：

| 你说 | 路由到 |
|------|--------|
| 帮我审查这份 SaaS 服务协议 | commercial-legal |
| 分析这个案件的管辖权问题 | litigation-legal |
| 评估个人信息保护合规风险 | privacy-legal |
| 起草一份竞业限制协议 | employment-legal |
| 制定一个股权激励方案 | corporate-legal |
| 查一下这个商标能不能注册 | ip-legal |
| 搜索民法典关于合同无效的规定 | commercial-legal（自动调用 MCP） |
| 查一下华为的涉诉信息 | corporate-legal（自动调用 MCP） |

也可手动指定：

```
@codex-for-legal-cn 帮我审这份合同
@litigation-legal 分析一下证据问题
```

---

## 四、自动更新

每次使用法律技能时自动同步上游。手动更新：

```powershell
.\update.ps1
```

---

## 五、技能清单

| 技能 | 领域 | 内容量 |
|------|------|--------|
| codex-for-legal-cn | 根技能（路由+更新） | - |
| commercial-legal | 商事合同 | 43KB + 12 子技能 |
| litigation-legal | 诉讼仲裁 | 28KB + 19 子技能 |
| employment-legal | 劳动用工 | 32KB + 20 子技能 |
| privacy-legal | 数据合规 | 25KB + 9 子技能 |
| corporate-legal | 公司交易 | 27KB + 13 子技能 |
| ip-legal | 知识产权 | 17KB + 12 子技能 |
| product-legal | 产品合规 | 23KB + 7 子技能 |
| regulatory-legal | 监管合规 | 10KB + 9 子技能 |
| ai-governance-legal | AI 治理 | 16KB + 10 子技能 |
| law-student | 法学生/法考 | 35KB + 13 子技能 |
| legal-clinic | 法律诊所 | 29KB + 16 子技能 |
| legal-builder-hub | 技能治理中心 | 11KB + 10 子技能 |

---

## 六、输出说明

- 所有输出均为**律师审查草稿**，不构成法律意见
- 已连 MCP：引用标注具体来源
- 未连 MCP：引用标注 `[需验证]`
- 默认适用中国大陆法律

---

## 七、卸载

```powershell
.\uninstall.ps1
```

手动清理 config.toml 中的 MCP 条目（如有需要）。

---

## 八、故障排查

见 docs/troubleshooting.md。