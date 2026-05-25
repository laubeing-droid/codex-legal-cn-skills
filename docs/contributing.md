<!--
version: 2.9.0
module: docs
status: active
-->

# 贡献指南

## 本仓库不是普通项目

这是**三上游整合 + 自研对齐框架 + 自制护栏 + 自建监控**的系统。每一层有独立的贡献入口：

### 法条层（上游：Daknniel-0881/qulv）
贡献入口：`skills/knowledge-base/`
- 新增法律 → 放官方 PDF，更新 MAPPING.md
- 修正条文 → 替换 PDF，标注变更

### 内容层（子技能）
贡献入口：`skills/*/skills/`
- 新增中国法子技能 → 创建目录 + SKILL.md  
- 修改已有技能 → 编辑 SKILL.md，更新命令引用
- 合并上游更新 → 跑 diff-tool，手动合

### 护栏层
贡献入口：`patches/guards/` + `skills/references/`
- 新增阻断概念 → blocking-list.md
- 新增中美映射 → alignment/
- 新增香港桥梁 → hk-bridge.md

### 监控层
贡献入口：`patches/diff-tool-*.ps1`
- 新增跟踪文件 → 加入 $files
- 新增上游 → 创建新的 diff-tool

## 注意
- 不提交 API Key
- 上游变更不自动合并
