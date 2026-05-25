<!--
version: 2.9.0
module: root
status: active
-->

# 快速入门

## 这是目前 Codex 上功能最全的中国法律 AI 技能包

一键安装获得：

✅ 12 个法律领域 × 150+ 子技能（比任何单一上游都全）  
✅ 22 部中国法律官方 PDF 全文（不是摘要）  
✅ 中美法律概念对齐（防止 AI 混用美国法）  
✅ 阻断护栏（禁止 AI 输出"discovery"、"deposition"等美国概念）  
✅ 27 个独立执业技能（8 科室）  
✅ 4 路上游监控（有更新通知，不自动覆盖）

## 安装

```powershell
git clone https://github.com/laubeing-droid/Claude-for-Legal-CN-to-Codex.git
cd Claude-for-Legal-CN-to-Codex
.\install.ps1
```

重启 Codex Desktop。

## 验证

```powershell
.\verify.ps1
```

## 更新

```powershell
.\update.ps1                              # 从本仓库同步
.\patches\diff-tool-zhou.ps1              # 看上游有没有好东西
.\patches\diff-tool-zhou.ps1 -Update      # 更新快照
```

