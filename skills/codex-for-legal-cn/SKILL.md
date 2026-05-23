---
name: codex-for-legal-cn
description: >
  中国法律工作总入口。自动识别律师工作场景并路由到对应领域技能。
  每次启用时自动检查上游更新，静默同步。
---

# codex-for-legal-cn

## 自动更新

每次执行法律任务前，检查本地上游仓库是否有更新并同步。

查找顺序：
1. ~/.codex/vendor/claude-for-legal-CN/（install.ps1 创建的缓存）
2. ../claude-for-legal-CN/（本仓库同级目录）

找到后执行 git pull，同步 CLAUDE.md 和 references 到 ~/.codex/skills/。
静默执行，不影响对话。

## 自动路由规则

| 关键词 | 路由目标 |
|---|---|
| 诉讼、仲裁、执行、保全、证据、代理词 | litigation-legal |
| 合同审查、违约、补充协议、函件 | commercial-legal |
| 公司、股权、投资、尽调、并购 | corporate-legal |
| 劳动、社保、解除、竞业、规章制度 | employment-legal |
| 隐私、个保法、数据、出境 | privacy-legal |
| 产品上线、营销合规、广告法 | product-legal |
| 监管、合规跟踪、政策变化 | regulatory-legal |
| AI治理、算法、伦理审查 | ai-governance-legal |
| 商标、专利、著作权、侵权 | ip-legal |
| 法考、案例学习、法律学习 | law-student |
| 法律诊所、法律援助 | legal-clinic |
| 技能安装、技能管理 | legal-builder-hub |

## MCP 连接器

技能预配置了两个中国法律 MCP 连接器（在 ~/.codex/config.toml 的 [mcp_servers] 段）：

- **chineselaw（推荐）**：33 个工具，覆盖法规检索、案例检索、企业信息查询
- **北大法宝（备选）**：10 个专用 MCP 服务

使用法律检索任务时优先调用已配置的 MCP 连接器获取当前有效法条和案例。
如未找到已启用的 MCP 连接器，基于模型训练数据工作，引用标注 [需验证]。

## 工作流程

1. 执行自动更新
2. 判定任务是否属于法律工作流程
3. 检查 MCP 连接器状态（config.toml 的 [mcp_servers] 段）
4. 选择最匹配的领域模块
5. 读取该模块 SKILL.md + CLAUDE.md + references
6. 如有可用 MCP 连接器，优先通过 MCP 检索当前有效法条和案例
7. 法规、案例须核验现行有效性

## 重要限制

- 所有输出均为律师审查草稿，不构成法律意见
- 引用法规须核验现行有效性
- 提交/发送前需经执业律师审核