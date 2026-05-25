<!--
version: 2.9.0
module: docs
status: active
-->

# 使用指南

## 本仓库 vs 原版的使用差异

原版（anthropic 美国法）的技能名是英文的：`deposition-prep`、`cease-desist`。  
本仓库改成中文了：**调查取证准备**、**律师函生成**。直接说中文就能用：

| 你说 | 系统怎么处理 |
|:-----|:------------|
| "做证据保全" | → 调用 证据保全与留存（原名 legal-hold，已重写为中国版） |
| "起草律师函" | → 调用 律师函生成（原名 cease-desist，已改名） |
| "申请调查令" | → 调用 调查取证准备（原名 deposition-prep，已重写） |
| "收到法院协查通知" | → 调用 司法协查响应（原名 subpoena-triage，已重写） |
| "审查合同" | → commercial-legal/review |
| "分析管辖权" | → litigation-legal/claim-chart |
| "查商标" | → ip-legal/clearance |
| "合规风险" | → privacy-legal/use-case-triage |

## 手动调用

```powershell
/litigation-legal:调查取证准备 [案件名]
/ip-legal:律师函生成 --send
/litigation-legal:证据保全与留存 --issue
```

## 更新检测

```powershell
.\patches\diff-tool-zhou.ps1           # 看 zhou210712 有没有更新
.\patches\diff-tool-zhou.ps1 -Diff     # 看改了哪行
.\patches\diff-tool-zhou.ps1 -Update   # 决定同步后更新快照
```
