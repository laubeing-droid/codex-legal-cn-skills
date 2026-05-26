# 技能行为参数映射表

> **单一真相源**。全部技能文件中以 `@param:KEY` 格式引用的数值，由本文件统一定义。
> 修改参数只需改这一个文件。AI Agent 执行技能时从此解析当前值。

---

## 通用参数

| 键 | 值 | 用途 |
|:---|:--|:-----|
| `@param:scope:analysis-limit` | `2-5` | 每次分析的推荐条目上限，超过建议分批 |
| `@param:scope:review-granularity` | `3-5` | 详细审查 vs 快速审查分界，低于做详细 |
| `@param:scope:batch-default` | `适量` | 默认拉取/展示条目的语义描述 |
| `@param:scope:batch-recent` | `10-15` | 从外部系统拉取时的推荐条目范围 |

## 访谈参数

| 键 | 值 | 用途 |
|:---|:--|:-----|
| `@param:cold-start:min-items` | `10` | 触发 LIMITED DATA 严重警告的阈值 |
| `@param:cold-start:target-items` | `10-20` | 推荐的覆盖条目范围上限 |

---

## 修改记录

| 日期 | 变更 |
|:-----|:-----|
| 2026-05-26 | 初始创建，从各技能文件中提取现有参数 |