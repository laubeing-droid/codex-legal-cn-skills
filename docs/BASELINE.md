<!--
version: 2.9.0
module: docs
status: active
-->

# 版本基线 — Claude-for-Legal-CN-to-Codex

> 基线版本：**v2.9.0** | 锁定日期：2026-05-25
> 基线定义：通过完整安装验证、所有技能可正常加载的稳定版本。

---

## 基线构成

### 核心技能（12 领域）

| 领域 | 版本 | 状态 | 子技能数 |
|:-----|:----|:----|:--------|
| ai-governance-legal | 2.9.0 | stable | 11 |
| commercial-legal | 2.9.0 | stable | 13 |
| corporate-legal | 2.9.0 | stable | 14 |
| employment-legal | 2.9.0 | stable | 21 |
| ip-legal | 2.9.0 | stable | 12 |
| law-student | 2.9.0 | stable | 14 |
| legal-builder-hub | 2.9.0 | stable | 11 |
| legal-clinic | 2.9.0 | stable | 16 |
| litigation-legal | 2.9.0 | stable | 20 |
| privacy-legal | 2.9.0 | stable | 9 |
| product-legal | 2.9.0 | stable | 8 |
| regulatory-legal | 2.9.0 | stable | 9 |
| solo-law-firm | 2.9.0 | stable | 27 |

### 基础设施

| 组件 | 版本 | 状态 |
|:-----|:----|:----|
| install.sh / install.ps1 | 2.9.0 | stable |
| update.sh / update.ps1 | 2.9.0 | stable |
| uninstall.sh / uninstall.ps1 | 2.9.0 | stable |
| verify.ps1 | 2.9.0 | stable |
| gen-knowledge-index.ps1 | 2.9.0 | stable |
| diff-tool-all.ps1 | 2.9.0 | stable |
| 4 路 diff-tool | 2.9.0 | stable |
| 护栏文件 (8) | 2.9.0 | stable |
| OUTPUT_STANDARD.md | 2.9.0 | stable |

### 知识库

| 组件 | 版本 | 法条截止日期 |
|:-----|:----|:------------|
| qulv 知识库 (22 部 PDF) | 2.9.0 | 2026-05-25 |

---

## 变更控制

- 基线文件不得直接修改，需通过 PR + 验证后合并
- 子技能新增/删除需同步更新本文件
- 每次 release 打 tag 后本文件随版本号更新

## 已知差距（不在基线内）

| 项目 | 优先级 | 备注 |
|:-----|:------|:-----|
| 司法解释层 | P1 | 需另建数据源 |
| 裁判规则层 | P1 | 需类案数据 |
| 地方实践层 | P2 | 挂起 |

> 已完成移除：中国法 benchmark（v2.9.0 加入 12 正面用例）、Rule Runtime（12 领域推理模板 + overlay.yaml）、非诉自动化（合同审查清单 + 数据合规SOP + 劳动SOP） |
