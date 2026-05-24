# 贡献指南

## 修改技能

1. 直接编辑 `skills/<domain>/skills/<skill>/SKILL.md`
2. 运行 `.\verify.ps1` 验证完整性
3. 提交 PR

## 处理上游更新

1. 查看 Issues 标签 `upstream-update`
2. 运行对应 diff-tool 比对差异
3. 手动合并有价值的变更到本地 skills/
4. 提交 PR

## 新增上游监控

在 `upstream-monitor.yml` 的 `check_repo` 调用列表中添加。
