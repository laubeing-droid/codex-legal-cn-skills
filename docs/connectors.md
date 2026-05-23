# MCP 连接器配置指南

法律技能连接了权威法律数据源后效果最佳。本仓库支持以下连接方式：

| 连接器 | 方式 | 工具数 | 推荐 |
|--------|------|--------|------|
| **chineselaw（元典智库）** | MCP 协议 stdio | 33 | ⭐ 首选 |
| **北大法宝 MCP 协议** | MCP 协议 HTTP | 10 服务 | 推荐 |
| **北大法宝 CLI 命令行** | CLI 调试工具 | — | 配合验证 |

---

## 一、chineselaw（元典智库）— 首选

基于 [chineselaw-mcp](https://www.npmjs.com/package/chineselaw-mcp)（作者 zooges），
将元典智库 API 开放平台封装为 MCP 工具，覆盖三大类共 **33 个工具**。

### 前置条件

- Node.js >= 18。如未安装，从 https://nodejs.org 下载 LTS 版本

### 注册获取 API Key

1. 打开 https://open.chineselaw.com
2. 注册账号并登录
3. 进入「个人中心」→「API 管理」
4. 创建 API Key，复制保存

### 配置

安装后编辑 config.toml：

```powershell
notepad "$env:USERPROFILE\.codex\config.toml"
```

找到以下内容，将 `YOUR_API_KEY` 替换为真实 Key：

```toml
[mcp_servers.chineselaw]
command = "npx"
args = ["-y", "chineselaw-mcp"]
startup_timeout_sec = 30
tool_timeout_sec = 600
enabled = true

[mcp_servers.chineselaw.env]
CHINESELAW_API_KEY = "YOUR_API_KEY"    # ← 替换为真实 API Key
```

### 可用工具（33 个）

**法律法规（5 个）**

| 工具名 | 功能 |
|--------|------|
| search_regulations | 法规关键词检索与过滤 |
| search_legal_articles | 法条关键词检索与过滤 |
| get_article_detail | 获取法条详情 |
| get_regulation_detail | 获取法规详情 |
| semantic_search_law | 法律法规语义向量检索 |

**案例文书（4 个）**

| 工具名 | 功能 |
|--------|------|
| search_cases | 普通案例多条件检索（案由、法院、地区、日期等） |
| search_authoritative_cases | 权威案例多条件检索 |
| get_case_detail | 获取案例详情 |
| semantic_search_cases | 案例语义向量检索 |

**企业信息（24 个）**

| 工具名 | 功能 |
|--------|------|
| search_enterprise | 企业名称检索 |
| get_company_by_name | 按名称/股票简称查企业聚合详情 |
| get_company_by_id | 按 ID/信用代码查企业聚合详情 |
| get_enterprise_base_info | 企业基本信息 + 股东 + 成员 + 分支机构 |
| get_enterprise_investments | 对外投资列表 |
| get_enterprise_trademarks | 商标列表 |
| get_enterprise_patents | 专利列表 |
| get_enterprise_software_copyrights | 软著列表 |
| get_enterprise_works_copyrights | 作品著作权列表 |
| get_enterprise_icp | 网站备案列表 |
| get_enterprise_changes | 工商变更记录 |
| get_enterprise_litigation_stats | 涉诉信息统计 |
| get_enterprise_litigation_docs | 涉诉文书列表 |
| get_enterprise_court_sessions | 开庭公告列表 |
| get_enterprise_court_notices | 法院公告列表 |
| get_enterprise_dishonest | 失信被执行人 |
| get_enterprise_executed | 被执行人 |
| get_enterprise_frozen_equity | 股权冻结 |
| get_enterprise_penalties | 行政处罚 |
| get_enterprise_pledge | 股权出质 |
| get_enterprise_guarantees | 对外担保 |
| get_enterprise_abnormal_ops | 经营异常 |
| get_enterprise_tax_arrears | 欠税公告 |
| get_enterprise_serious_illegal | 严重违法 |

---

## 二、北大法宝 MCP 协议 — Codex 集成方式

北大法宝提供 10 个独立的 HTTP MCP 服务。安装脚本已在 `~/.codex/config.toml` 写入全部配置，
你只需替换 Token 即可在 Codex 中直接使用。

### 注册获取凭证

1. 打开 https://mcp.pkulaw.com
2. 注册账号并登录
3. 进入「开发者控制台」→「我的应用」，创建新应用
4. 在已购买的服务中复制各服务 URL
5. 在「密钥管理」生成 Access Token

### 配置到 Codex

打开 config.toml：

```powershell
notepad "$env:USERPROFILE\.codex\config.toml"
```

找到所有以 `[mcp_servers.pkulaw-` 开头的段，将 `YOUR_ACCESS_TOKEN` 替换为真实 Token：

```toml
[mcp_servers.pkulaw-law-search]
url = "https://apim-gateway.pkulaw.com/mcp-law-search-service"
http_headers = { Authorization = "Bearer YOUR_ACCESS_TOKEN" }   # ← 替换
startup_timeout_sec = 30
tool_timeout_sec = 600
enabled = true
```

如购买了 NL SQL 服务，还需替换 `YOUR_NL_SQL_SERVICE_ID`。

### 已配置的 10 个服务

| 配置段名 | 服务端点 | 用途 |
|----------|---------|------|
| pkulaw-law-search | mcp-law-search-service | 法律法规语义检索 |
| pkulaw-law-keyword | mcp-law | 法律法规关键词检索 |
| pkulaw-case-semantic-search | mcp-case-search-service | 案例语义检索 |
| pkulaw-case-keyword | mcp-case | 案例关键词检索 |
| pkulaw-law-item-keyword | mcp-fatiao | 法条关键词检索 |
| pkulaw-law-recognition | law_recognition | 法律文本识别 |
| pkulaw-case-number-recognition | case_number_recognition | 案号识别 |
| pkulaw-citation-validator | pku_citation_validator | 引证验证 |
| pkulaw-doc-link | add-doc-link | 文档关联 |
| pkulaw-semantic-nlsql | YOUR_NL_SQL_SERVICE_ID | NL SQL 查询（需额外购买） |

---

## 三、使用 pkulaw-mcp-cli 验证配置

基于 [@pkulaw/mcp-cli](https://www.npmjs.com/package/@pkulaw/mcp-cli)（北大法宝官方，MIT 协议），
**在安装和配置完 MCP 协议后，用于诊断 Token 有效性、发现已订阅服务、验证 API 返回结果**。

运行 `.\update.ps1` 会自动检测是否已安装此工具。本页说明手动操作步骤。

### 安装

```bash
npm install -g @pkulaw/mcp-cli
```

### 初始化（只需一次）

```bash
pkulaw-mcp init --authorization "Bearer YOUR_ACCESS_TOKEN"
```

`YOUR_ACCESS_TOKEN` 与上一节 MCP 协议配置使用**同一个 Token**。

### 验证流程

**第 1 步：确认 Token 有效、拉取已订阅服务**
```bash
pkulaw-mcp update
```
成功后会显示你实际已订阅的北大法宝服务列表。如果失败，说明 Token 有误或网关不可达。

**第 2 步：查看每个服务下有哪些工具可用**
```bash
pkulaw-mcp tools law-search
pkulaw-mcp tools case-keyword
```

**第 3 步：直接调用工具验证返回数据**
```bash
pkulaw-mcp law-search search_regulations --searchKey "民法典 合同无效"
pkulaw-mcp case-keyword search_cases --searchKey "买卖合同纠纷"
```

### 其他诊断命令

| 命令 | 用途 |
|------|------|
| `pkulaw-mcp check` | 检查配置文件完整性 |
| `pkulaw-mcp config list` | 查看当前配置 |
| `pkulaw-mcp docs` | 查看各服务在线文档 |
| `pkulaw-mcp --help` | 查看所有命令 |

---

## 四、验证 Codex 连接

配置完成并重启 Codex Desktop 后，输入以下任一问题测试：

**chineselaw 用户**：
```
搜索民法典关于合同无效的规定
```

**北大法宝 MCP 用户**：
```
查一下最新关于民间借贷的司法解释
```

连接成功时输出中的法规引用会标注具体来源；未连接时标注 `[需验证]`。

---

## 五、常见问题

### 连接器不生效？

1. 确认 Token/API Key 已替换为真实值（不是 `YOUR_xxx` 占位符）
2. 确认已重启 Codex Desktop
3. 确认 `config.toml` 中 `enabled = true` 存在
4. 使用 `.\update.ps1` 检查 MCP 状态（自动检测 pkulaw-mcp-cli）
5. 运行 `.\verify.ps1` 检查安装完整性

### chineselaw 报 npx 相关错误？

```powershell
node --version                          # 确认 Node.js 已安装
npm config set proxy http://127.0.0.1:7890   # 如网络受限
```

### 需要同时配置多个连接器吗？

不需要。推荐组合：
- **chineselaw** 或 **北大法宝 MCP 协议**（二选一作为 Codex 集成）
- **北大法宝 CLI 命令行**（可选安装，用于调试和验证）

### 无连接器还能用吗？

可以。技能会基于模型训练数据提供分析，但引用会标注 `[需验证现行有效性]`。

### 我不小心损坏了 config.toml？

安装脚本不会删除已有配置，只添加缺失条目。重新运行 `install.ps1` 即可恢复。