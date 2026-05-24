# 故障排除

| 问题 | 原因 | 解决 |
|:----|:----|:-----|
| 技能没出现 | 未安装或未重启 | 运行 `.\install.ps1`，重启 Codex |
| 引用标注 [需验证] | MCP 未配置 | 编辑 `~/.codex/config.toml` |
| diff-tool 报 git 错误 | TEMP 目录冲突 | 删除 `$env:TEMP\zhou-check` 重试 |
| 子技能全是 [+] | 首次运行 | 执行 `-Update` 创建快照 |
| 上游监控无通知 | 未有新 commit | 等待下周一或手动触发 Actions |
