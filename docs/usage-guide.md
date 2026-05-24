# 使用指南

## 日常使用场景

安装重启后，直接输入自然语言，系统自动路由：

| 你说 | 它调用 |
|:-----|:-------|
| "审查这份 SaaS 协议" | commercial-legal → review |
| "管辖权分析" | litigation-legal → 调查取证准备 |
| "评估合规风险" | privacy-legal → use-case-triage |
| "做证据保全" | litigation-legal → 证据保全与留存 |
| "起草律师函" | ip-legal → 律师函生成 |
| "申请调查令" | litigation-legal → 调查取证准备 |
| "查这个商标" | ip-legal → clearance |
| "审劳动合同" | employment-legal → hiring-review |
| "公司股权结构分析" | corporate-legal → tabular-review |
| "检查广告合规" | product-legal → marketing-claims-review |
| "法规动态监控" | regulatory-legal → reg-feed-watcher |
| "算法备案了吗" | ai-governance-legal → use-case-triage |

## 新增的中国化技能

以下技能是原本美国法版本没有的，本仓库专门为中国法律体系重写：

| 新技能 | 原技能 | 对应中国制度 |
|:-------|:-------|:------------|
| 调查取证准备 | deposition-prep | 法院调查令申请、证据保全申请、质证提纲 |
| 证据保全与留存 | legal-hold | 公证保全、诉前保全、电子数据固化 |
| 司法协查响应 | subpoena-triage | 法院调查令、行政协查通知、监管调证 |
| 律师函生成 | cease-desist | 侵权警告函、律师函模板 |

## 手动调用

```powershell
/领域名:新技能名
/ip-legal:律师函生成 --send
/litigation-legal:调查取证准备 [案件名]
```

## 检查上游变更

```powershell
.\patches\diff-tool-zhou.ps1 -Diff
.\patches\diff-tool-max.ps1
.\patches\diff-tool-solo.ps1
```
