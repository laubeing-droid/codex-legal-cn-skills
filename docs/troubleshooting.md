# 常见问题排查

## 安装问题

### 安装后 Codex 没有识别技能

检查 `~/.codex/skills/` 目录下是否存在技能目录。如果不存在，重新运行 `install.ps1`。

```powershell
# 查看已安装的技能
Get-ChildItem "$env:USERPROFILE\.codex\skills"
```

### git clone 失败（网络问题）

如果你在中国需要使用代理：

```powershell
git config --global http.proxy http://127.0.0.1:7890
git config --global https.proxy http://127.0.0.1:7890
```

### PowerShell 执行策略限制

如果遇到执行策略错误：

```powershell
Set-ExecutionPolicy -Scope CurrentUser -RemoteSigned -Force
```

### 安装过程中断

重新运行 `.\install.ps1` 即可，脚本会检测已有文件并继续。

## 使用问题

### 没有自动进入法律模式

直接指定技能名称：

```
@codex-for-legal-cn 你的问题
```

### 路由到了错误的领域

在问题中更明确地使用领域关键词，或在对话开头指定：

```
@litigation-legal 分析一下证据问题
```

### 输出不准确

- 所有输出均为律师审查草稿，不构成法律意见
- 引用法规、案例时必须另行核验现行有效性
- 系统默认中国法（大陆），其他法域需明示

## 更新问题

### git pull 冲突

如果更新时发生冲突：

```powershell
git stash
git pull
git stash pop
```

### 更新后技能未生效

重启 Codex Desktop 即可。

## 路径问题

### 技能安装到了哪里

默认路径：`C:\Users\你的用户名\.codex\skills\`

### 上游内容缓存位置

`codex-legal-cn-skills\vendor\SH88-source\claude-for-legal-CN\`
