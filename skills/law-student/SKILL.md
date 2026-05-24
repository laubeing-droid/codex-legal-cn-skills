---
name: law-student
description: 法考备考、案例分析、法律写作与学术检索
---

# 法学生与法考 法务技能

## 何时使用
- 法律工作任务属于「法学生与法考」领域
- 关键词触发：法考,案例学习,法律学习,考试,备考

## 工作指令
核心指令位于上游仓库的 CLAUDE.md 文件中，包含完整工作流定义、输出框架和质量标准。
每次启用时根技能已自动拉取最新版本到 ~/.codex/skills/law-student/CLAUDE.md。

## 本地资源（由自动更新同步）
- 主指令：./CLAUDE.md
- 说明：./README.md
- 中国法参考：./references/
- 子技能：./skills/
- MCP 配置：./.mcp.json

## 中美法律概念对齐

当处理涉及中美法律概念对应的问题时，参考以下对齐指南：

### 阻断清单（无对应中国法制度，须拦截）


### 制度映射参考
- IRAC
- bar exam
- legal writing
- case briefing

如需完整映射表，见 patches/references/alignment/law-student.md。

## 重要限制
- 所有输出均为律师审查草稿，不构成法律意见
- 引用法规、案例时必须另行核验现行有效性
- 任何提交、发送或依赖前需经执业律师审核

