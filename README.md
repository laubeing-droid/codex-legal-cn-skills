# Claude for Legal CN to Codex

## 🔴 只有这个仓库做了的事

### 1. PRC-US 法律语义对齐框架（自研）
市面上所有版本（zhou210712、MAXXXXXLI、gjhcsjamin）都只是"把美国法改成中文名"。
**PRC-US 法律语义对齐框架** — 12 个领域逐一进行中美法律概念映射，配套 8 个阻断护栏，防止 AI 输出美国法概念（如 discovery、deposition、privilege）。

### 2. 官方 PDF 全文入库（qulv）
**qulv 知识库包含 22 部中国法律官方 PDF 全文**（民法典 1062 条、公司法 248 条等），可逐条检索引用。

### 3. 三上游整合
`zhou210712` 的法条 + `MAXXXXXLI` 的语境 + `saysoph` 的独立执业技能——  
**只有这个仓库把它们放在一起**，做成了一键安装包。其他版本都只依赖单一路径。

### 4. 参考窗口架构（独创）
上游更新了，**不会自动覆盖你的修改**。  
4 路 diff-tool 各自跟踪一个上游，告诉你"他改了啥，你看要不要抄"。  


### 5. 五个美国法子技能重写
不是翻译，是**法律重写**：

| 原名（美国法） | 现名（中国法） | 这是什么 |
|:--------------|:-------------|:---------|
| deposition-prep | 调查取证准备 | 中国只有调查令，没有 deposition |
| legal-hold | 证据保全与留存 | 中国没有 legal hold 义务 |
| subpoena-triage | 司法协查响应 | 中国只有法院调查令，没有 subpoena |
| cease-desist | 律师函生成 | 本身就是中国律师函 |
| privilege-log-review | 已删除 | 中国没这个制度，留着会误导 |

### 6. MCP 连接器独立管理
别人把 API Key 硬编码在配置里。  
你把 MCP 拆成独立仓库，隔离凭证、分离关注点、可独立更新。

---

## 安装

```powershell
git clone https://github.com/laubeing-droid/Claude-for-Legal-CN-to-Codex.git
cd Claude-for-Legal-CN-to-Codex
.\install.ps1
```

---

## 适配全景

| 适配层 | 上游做了什么 | **本仓库额外做了什么** |
|:-------|:-----------|:---------------------|
| 法条引用 | zhou210712: 9 个摘要文件 | **22 部官方 PDF 全文** |
| 子技能 | zhou210712: 精简 29%，加中文注释 | **5 个全量重写为中国版** |
| 工作流 | zhou210712: UI 中文化 | **全中文 + 护栏注入** |
| MCP 连接 | zhou210712: 替换为中国工具 | **独立 MCP Hub 仓库管理** |
| 概念对齐 | 上游版本未覆盖 | **12 领域 PRC-US 映射 + 8 护栏** |
| 语境 | MAXXXXXLI: 14 个语境文件 | **整合进 12 领域 + 自研补充** |
| 独立执业 | saysoph: 26 个技能 | **补充庭审提纲等缺失环节** |
| 上游监控 | 上游版本未覆盖 | **4 路 diff-tool 参考窗口** |

---

## 上游关系

| 上游 | 角色 |
|:-----|:-----|
| anthropics/claude-for-legal | 原始美国法框架（参考） |
| zhou210712/claude-for-legal-ZH | 中国汉化版内容来源（参考窗口） |
| MAXXXXXLI/workbuddy-cn-legal-skills | 中国法语境文件（参考窗口） |
| saysoph/solo-law-firm-agents | 独立执业技能（参考窗口） |
| **PRC-US-Legal-Semantic-Alignment-Framework** | **自研对齐框架（本仓库独有）** |

```powershell
# 检查上游有无更新
.\patches\diff-tool-zhou.ps1
.\patches\diff-tool-zhou.ps1 -Diff   # 看改了哪行
.\patches\diff-tool-zhou.ps1 -Update # 决定同步后更新快照
```

---

## 依赖

- **Codex Desktop**（运行环境）
- **PRC-US-Legal-Semantic-Alignment-Framework**（自研，本仓库独有）
- **Codex-Claude-legal-cn-mcp-hub**（MCP 连接器独立仓库）
- 上游仓库均不作运行依赖（参考窗口模式）

---

## 致谢

本仓库整合了以下开源项目的成果，详见 [CREDITS.md](CREDITS.md)：

| 项目 | 贡献 |
|:-----|:-----|
| [anthropics/claude-for-legal](https://github.com/anthropics/claude-for-legal) | 原始法律 AI 框架（Apache 2.0） |
| [zhou210712/claude-for-legal-ZH](https://github.com/zhou210712/claude-for-legal-ZH) | 中国汉化版主体内容 |
| [MAXXXXXLI/workbuddy-cn-legal-skills](https://github.com/MAXXXXXLI/workbuddy-cn-legal-skills) | 中国法律语境文件 |
| [saysoph/solo-law-firm-agents](https://github.com/saysoph/solo-law-firm-agents) | 独立执业技能（MIT） |


