# MCP 连接器配置指南

法律技能连接了权威法律数据源后效果最佳。本仓库支持两个中国法律 MCP 连接器，**推荐 chineselaw**。

> ⚠️ **重要**：Codex Desktop 的 MCP 配置位于 `~/.codex/config.toml` 的 `[mcp_servers]` 段，
> 不是技能目录下的 `.mcp.json` 文件。运行 `install.ps1` 后会自动写入 `config.toml`，
> 你只需替换凭证即可。

---

## 一、chineselaw（元典智库）— 推荐

将元典智库 API 开放平台封装为 MCP 工具，覆盖三大类共 **33 个工具**。

### 注册获取 API Key

1. 打开 https://open.chineselaw.com
2. 注册账号并登录
3. 进入「个人中心」→「API 管理」
4. 创建 API Key，复制保存

### 配置

安装后打开 `config.toml`：

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
CHINESELAW_API_KEY = "你的_API_KEY"    # ← 替换这里
```

> **要求**：需要 Node.js >= 18。如未安装，从 https://nodejs.org 下载 LTS 版本。

### 可用工具（33 个）

**法律法规（5 个）**

| 工具名 | 功能 |
|--------|------|
| `search_regulations` | 法规关键词检索与过滤 |
| `search_legal_articles` | 法条关键词检索与过滤 |
| `get_article_detail` | 获取法条详情 |
| `get_regulation_detail` | 获取法规详情 |
| `semantic_search_law` | 法律法规语义向量检索 |

**案例文书（4 个）**

| 工具名 | 功能 |
|--------|------|
| `search_cases` | 普通案例多条件检索 |
| `search_authoritative_cases` | 权威案例多条件检索 |
| `get_case_detail` | 获取案例详情 |
| `semantic_search_cases` | 案例语义向量检索 |

**企业信息（24 个）**

| 工具名 | 功能 |
|--------|------|
| `search_enterprise` | 企业名称检索 |
| `get_company_by_name` | 按名称/股票简称查企业详情 |
| `get_company_by_id` | 按 ID/信用代码查企业详情 |
| `get_enterprise_base_info` | 基本信息 + 股东 + 成员 + 分支机构 |
| `get_enterprise_investments` | 对外投资列表 |
| `get_enterprise_trademarks` | 商标列表 |
| `get_enterprise_patents` | 专利列表 |
| `get_enterprise_software_copyrights` | 软著列表 |
| `get_enterprise_works_copyrights` | 作品著作权列表 |
| `get_enterprise_icp` | 网站备案列表 |
| `get_enterprise_changes` | 工商变更记录 |
| `get_enterprise_litigation_stats` | 涉诉信息统计 |
| `get_enterprise_litigation_docs` | 涉诉文书列表 |
| `get_enterprise_court_sessions` | 开庭公告列表 |
| `get_enterprise_court_notices` | 法院公告列表 |
| `get_enterprise_dishonest` | 失信被执行人 |
| `get_enterprise_executed` | 被执行人 |
| `get_enterprise_frozen_equity` | 股权冻结 |
| `get_enterprise_penalties` | 行政处罚 |
| `get_enterprise_pledge` | 股权出质 |
| `get_enterprise_guarantees` | 对外担保 |
| `get_enterprise_abnormal_ops` | 经营异常 |
| `get_enterprise_tax_arrears` | 欠税公告 |
| `get_enterprise_serious_illegal` | 严重违法 |

### 使用示例

```powershell
搜索关于合同法的现行有效法规
查一下北京海淀区2023年的买卖合同纠纷案例
查询华为技术有限公司的工商信息和涉诉情况
```

---

## 二、北大法宝 — 备选方案

北大法宝提供 10 个独立的 MCP 服务。安装脚本已自动写入配置，你只需替换 Token。

### 注册获取凭证

1. 打开 https://mcp.pkulaw.com
2. 注册账号并登录
3. 进入「开发者控制台」→「我的应用」
4. 创建新应用，在已购买的服务中复制各服务 URL
5. 在「密钥管理」生成 Access Token

### 配置

打开 `config.toml`，找到所有以 `pkulaw-` 开头的 `[mcp_servers.*]` 段：

```toml
[mcp_servers.pkulaw-law-search]
url = "https://apim-gateway.pkulaw.com/mcp-law-search-service"
http_headers = { Authorization = "Bearer YOUR_ACCESS_TOKEN" }   # ← 替换 Token
startup_timeout_sec = 30
tool_timeout_sec = 600
enabled = true
```

将每个服务中的 `"YOUR_ACCESS_TOKEN"` 替换为你的真实 Token。

如果购买了 NL SQL 服务，还需替换 `YOUR_NL_SQL_SERVICE_ID`。

### 已配置的 10 个服务

| section | URL | 用途 |
|---------|-----|------|
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

## 三、验证连接

配置完成并重启 Codex Desktop 后，输入以下任一问题测试：

**chineselaw 用户**：
```
搜索民法典关于合同无效的规定
```

**北大法宝用户**：
```
查一下最新关于民间借贷的司法解释
```

如果连接成功，输出中的法规引用会标注具体来源；如果未连接，标注 `[需验证]`。

也可以在 Codex 中查看 MCP 服务状态：Codex 会自动检测并启用配置的 MCP 服务器。

---

## 四、常见问题

### 连接器不生效？

1. 确认 Token/API Key 已替换为真实值（不是 `YOUR_xxx` 占位符）
2. 确认已重启 Codex Desktop
3. 检查 `config.toml` 中 `enabled = true` 存在
4. 运行 `.\verify.ps1` 检查安装完整性

### chineselaw 报 npx 相关错误？

```powershell
# 确认 Node.js 已安装
node --version

# 如网络受限，配置 npm 代理
npm config set proxy http://127.0.0.1:7890
```

### 两个连接器都要配吗？

**不需要**。二选一即可：
- chineselaw：33 个工具，覆盖法规+案例+企业，推荐首选
- 北大法宝：10 个专用服务，覆盖法规+案例+引证

### 无连接器还能用吗？

可以。技能会基于模型训练数据提供分析，但引用会标注 `[需验证现行有效性]`。

### 我不小心覆盖了 config.toml 怎么办？

安装脚本不会删除已有配置，只会添加不存在的条目。如需恢复，重新运行 `install.ps1`。