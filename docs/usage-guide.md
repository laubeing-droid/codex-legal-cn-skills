# 使用指南

## 基本使用

安装重启后，直接输入自然语言，系统自动路由：

| 你说 | 调用领域 |
|:----|:---------|
| "审查这份 SaaS 协议" | commercial-legal |
| "管辖权分析" | litigation-legal |
| "个人信息保护合规" | privacy-legal |
| "做证据保全" | litigation-legal → 证据保全与留存 |
| "起草律师函" | ip-legal → 律师函生成 |
| "申请调查令" | litigation-legal → 调查取证准备 |

## 手动调用

```
/领域名:技能名
/ip-legal:律师函生成 --send
/litigation-legal:调查取证准备 [案件名]
```

## 更新

```powershell
.\update.ps1                           # 从本仓库同步
.\patches\diff-tool-zhou.ps1           # 检查上游更新
.\patches\diff-tool-zhou.ps1 -Diff     # 看行级差异
.\patches\diff-tool-zhou.ps1 -Update   # 更新快照
```

## 查看上游通知

GitHub 仓库 → Issues → 标签 `upstream-update`
