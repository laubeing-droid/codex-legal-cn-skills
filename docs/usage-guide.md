# 使用指南

## 一、安装

### 前置条件

- Codex Desktop 已安装
- 操作系统：Windows 10/11
- Git（[下载](https://git-scm.com/downloads)）
- Node.js >= 18（如使用 chineselaw-mcp 或 @pkulaw/mcp-cli，[下载](https://nodejs.org)）

### 安装步骤

```powershell
git clone https://github.com/laubeing-droid/Claude-for-Legal-CN-to-Codex.git
cd Claude-for-Legal-CN-to-Codex
.\install.ps1
```

安装脚本自动完成：
1. 克隆上游法律内容到 `~/.codex/vendor/claude-for-legal-CN/`
2. 创建 13 个技能目录和入口文件（SKILL.md）
3. 复制工作流指令（CLAUDE.md）和法律参考文件（references/）
4. 委托 MCP 连接器仓库写入 `~/.codex/config.toml`
5. 配置 PowerShell 执行策略
6. 验证安装完整性

### 验证安装

```powershell
.\verify.ps1
```

应显示全部 13 个技能均为 [OK]。

---

## 二、配置 MCP 法律检索

法律技能连接权威数据库后效果最佳。三种连接方式说明如下：

### 方式一：chineselaw（首选，33 个工具）

基于 [chineselaw-mcp](https://www.npmjs.com/package/chineselaw-mcp)（作者 zooges，MIT 协议）。
将元典智库 API 包装为 33 个 MCP 工具，支持法律法规检索、案例文书查询、企业信息查询。

```powershell
# 1. 注册 https://open.chineselaw.com，获取 API Key
# 2. 编辑 config.toml
notepad "$env:USERPROFILE\.codex\config.toml"
# 3. 找到 [mcp_servers.chineselaw.env]，替换 CHINESELAW_API_KEY
# 4. 重启 Codex Desktop
```

### 方式二：北大法宝 MCP 协议（10 个服务）

基于 [北大法宝 MCP](https://mcp.pkulaw.com)（北大法宝官方，MIT 协议）。
提供 10 个 HTTP MCP 服务，支持法律法规、司法案例、行政处罚等检索。

```powershell
# 1. 注册 https://mcp.pkulaw.com，获取 Access Token
# 2. 编辑 config.toml，替换所有 YOUR_ACCESS_TOKEN
# 3. 如有 NL SQL 服务，替换 YOUR_NL_SQL_SERVICE_ID
# 4. 重启 Codex Desktop
```

### 方式三：北大法宝 CLI 命令行（调试工具）

基于 [@pkulaw/mcp-cli](https://www.npmjs.com/package/@pkulaw/mcp-cli)（北大法宝官方，MIT 协议）。
用于验证 Token、查看可用服务、脚本自动化。

```bash
npm install -g @pkulaw/mcp-cli
pkulaw-mcp init --authorization "Bearer YOUR_ACCESS_TOKEN"
pkulaw-mcp update
pkulaw-mcp tools
```

**建议的组合**：方式一（chineselaw）或方式二（北大法宝 MCP），二选一即可。方式三可选安装用于调试。

**完整配置指南和工具列表见 [MCP 连接器仓库](https://github.com/laubeing-droid/Codex-Claude-legal-CN-mcp-connectors)**。

---

## 三、使用方式

### 自动路由（推荐）

直接在 Codex 中描述法律任务，系统自动识别并调用对应技能：

| 你说 | 路由到 |
|------|--------|
| 帮我审查这份 SaaS 服务协议 | commercial-legal |
| 分析这个案件的管辖权问题 | litigation-legal |
| 评估个人信息保护合规风险 | privacy-legal |
| 搜索民法典关于合同无效的规定 | 路由 + 自动调用 MCP 检索 |
| 查一下华为的涉诉信息 | 路由 + 自动调用 MCP 检索 |

### 手动指定

```
@codex-claude-legal-cn 帮我审这份合同
@litigation-legal 分析一下证据问题
```

---

## 四、自动更新

每次使用法律技能时自动同步上游。手动更新：`.\update.ps1`

---

## 五、技能清单

13 个技能覆盖：商事合同、诉讼仲裁、劳动用工、数据合规、公司交易、
知识产权、产品合规、监管合规、AI 治理、法学生/法考、法律诊所、技能治理。

---

## 六、输出说明

- 所有输出均为**律师审查草稿**，不构成法律意见
- 已连 MCP：引用标注具体来源；未连：标注 [需验证]
- 默认适用中国大陆法律

---

## 七、卸载

```powershell
.\uninstall.ps1
```

如需清理 config.toml 中的 MCP 条目，手动删除对应 `[mcp_servers.*]` 段。

---

## 八、故障排查

MCP 配置问题优先查看 [MCP 连接器仓库](https://github.com/laubeing-droid/Codex-Claude-legal-CN-mcp-connectors)。
常见问题见 docs/troubleshooting.md。

