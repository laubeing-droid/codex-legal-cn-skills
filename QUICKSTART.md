# 快速入门

60 秒完成安装，获得一套完整的**中国法律 AI 技能系统**。

## 安装

```powershell
git clone https://github.com/laubeing-droid/Claude-for-Legal-CN-to-Codex.git
cd Claude-for-Legal-CN-to-Codex
.\install.ps1
```

安装后重启 Codex Desktop。

## 你能得到什么

| 类别 | 内容 | 数量 |
|:-----|:-----|:----:|
| 法律领域 | 商事合同/诉讼仲裁/劳动用工/数据合规/公司交易/知识产权/产品合规/监管合规/AI治理 | 12 个 |
| 法律子技能 | 审查合同、分析管辖权、起草律师函、评估合规风险等 | 150+ |
| 独立执业 | 案件管理/客户关系/尽职调查/市场拓展/财务行政等 | 27 个（8 科室）|
| 法条引用 | 民法典/公司法/劳动法等官方 PDF 全文 | 22 部 |
| 中国法护栏 | 阻断清单/元规则/香港桥梁等 | 8 个 |
| AI 概念对齐 | 中美法律概念对照 | 12 组 |

> 所有内容已适配中国法律体系，输入中文自然语言即可自动路由到对应技能。

## 验证

```powershell
.\verify.ps1
```

## 更新

```powershell
.\update.ps1                              # 同步本仓库最新内容
.\patches\diff-tool-zhou.ps1              # 查看上游有无更新
.\patches\diff-tool-zhou.ps1 -Diff        # 看具体差异
.\patches\diff-tool-zhou.ps1 -Update      # 更新快照
```

## 常见问题

| 问题 | 解决 |
|:-----|:-----|
| 技能没出现？ | 重启 Codex Desktop |
| 引用标注[需验证]？ | 配置 MCP（`.\update.ps1` 查看状态） |
| 上游有更新了吗？ | 查看仓库 Issues → `upstream-update` |
| 想卸载？ | `.\uninstall.ps1` |
