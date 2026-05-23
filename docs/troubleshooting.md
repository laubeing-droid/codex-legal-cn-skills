# 常见问题排查

## 安装问题

### 安装后 Codex 没有识别技能

检查 `~/.codex/skills/` 目录下是否存在 13 个技能目录。如缺失，重新运行 `install.ps1`。

### MCP 连接器不生效

> ⚠️ Codex Desktop 的 MCP 配置在 `~/.codex/config.toml` 的 `[mcp_servers]` 段，
> 不在技能目录的 `.mcp.json` 中。运行 `.\update.ps1` 可检查 MCP 状态。

```powershell
# 查看 MCP 配置
Select-String "\[mcp_servers" "$env:USERPROFILE\.codex\config.toml"
```

### 北大法宝 Token 无效

1. 确认已从 https://mcp.pkulaw.com 获取有效 Token
2. 确认 config.toml 中没有 `YOUR_ACCESS_TOKEN` 占位符残留
3. Token 有有效期，过期需重新生成

### chineselaw npx 错误

```powershell
# 确认 Node.js 已安装
node --version

# 如网络受限
npm config set proxy http://127.0.0.1:7890
```

### git clone 失败

```powershell
git config --global http.proxy http://127.0.0.1:7890
git config --global https.proxy http://127.0.0.1:7890
```

### PowerShell 执行策略限制

```powershell
Set-ExecutionPolicy -Scope CurrentUser -RemoteSigned -Force
```

## 使用问题

### 没有自动进入法律模式

```powershell
@codex-for-legal-cn 你的问题
```

### 路由到了错误的领域

在问题中更明确地使用领域关键词，或在开头指定 `@领域名`。

### 引用标注全是 [需验证]

MCP 连接器未正确配置。按 docs/connectors.md 的步骤配置 chineselaw 或北大法宝。

### 输出不准确

- 所有输出均为律师审查草稿
- 引用法规、案例须另行核验现行有效性
- 系统默认中国法（大陆），其他法域需明示

## 更新问题

### git pull 冲突

```powershell
git stash && git pull && git stash pop
```

### 更新后技能未生效

重启 Codex Desktop。

## 路径问题

| 内容 | 路径 |
|------|------|
| 技能文件 | `~/.codex/skills/` |
| 上游缓存 | `~/.codex/vendor/claude-for-legal-CN/` |
| MCP 配置 | `~/.codex/config.toml` 的 `[mcp_servers]` 段 |