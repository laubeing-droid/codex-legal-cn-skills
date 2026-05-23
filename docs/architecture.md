# 架构说明

## 项目定位

**Claude for Legal CN to Codex** 是一个包装层项目。它将两套技能体系以 Codex Desktop 可识别的格式部署到用户环境：
- [SH88-source/claude-for-legal-CN](https://github.com/SH88-source/claude-for-legal-CN) — 12 领域法律工作流（薄入口 + 上游 CLAUDE.md）
- [saysoph/solo-law-firm-agents](https://github.com/saysoph/solo-law-firm-agents) — 26 个自包含执业技能（厚 SKILL.md，修改版）

## 五层架构

`
+----------------------------------------------------+
| Claude-for-Legal-CN-to-Codex      <- packaging     |
| skills/*/SKILL.md   install.ps1    docs/            |
| skills/solo-law-firm/     self-contained (26)      |
|        |                     |                      |
|        v                     v                      |
| +--------------+   +--------------------+          |
| | Content A     |   | Content B          |          |
| | ~/.codex/     |   | skills/solo-law-   |          |
| | vendor/       |   | firm/              |          |
| | claude-for-   |   | (self-contained,   |          |
| | legal-CN/     |   |  no upstream)      |          |
| | CLAUDE.md +   |   +--------------------+          |
| | references    |                                   |
| +------+-------+                                    |
|        v                                            |
| Runtime  ~/.codex/skills/<domain>/                  |
| SKILL.md + CLAUDE.md + references                   |
|        |                                            |
|        v                                            |
| MCP  ~/.codex/config.toml  [mcp_servers]            |
+----------------------------------------------------+
`

## 各层职责

| 层级 | 内容 | 维护者 |
|------|------|--------|
| 包装层 | SKILL.md（入口定义）、安装脚本、文档 | 本仓库 |
| 内容层A（claude-for-legal） | CLAUDE.md（工作流指令）、references（法条参考） | 上游 SH88-source |
| 内容层B（solo-law-firm） | 自包含 SKILL.md（完整角色 prompt + 模板） | 上游 saysoph（本仓库修改版） |
| 运行层 | skills/ 下各领域执行目录 | install.ps1 自动管理 |
| MCP 层 | chineselaw + 北大法宝连接器配置 | Codex-Claude-legal-CN-mcp-connectors |

## 两套技能架构对比

| 维度 | claude-for-legal-CN | solo-law-firm |
|------|---------------------|---------------|
| 入口格式 | 薄 SKILL.md（路由 + 关键词） | 厚 SKILL.md（完整角色定义） |
| 核心内容 | 委托上游 CLAUDE.md | 自包含（模板、流程、禁止项） |
| 更新方式 | 自动 git pull 上游 | GitHub Actions 自动同步 PR |
| 安装目录 | ~/.codex/skills/<domain>/ | ~/.codex/skills/solo-law-firm/ |
| 适用场景 | 法律专业深度分析 | 执业全流程运营 |

## 设计原则

1. **两层分离**：包装层只维护 SKILL.md（入口），工作流指令来自上游
2. **自包含共存**：solo-law-firm 为自包含厚技能，不依赖上游 CLAUDE.md
3. **自动同步**：claude-for-legal 每次启用时 git pull；solo-law-firm 每周 Actions 自动检测
4. **委托而非重复**：MCP 连接器管理委托给独立仓库
5. **原生格式**：使用 Codex Desktop 的 config.toml [mcp_servers] 格式
6. **零额外依赖**：除 Git 和 Codex Desktop 外无其他系统依赖

## 更新流程

### claude-for-legal 更新
`
用户触发法律任务
  -> 根技能 codex-claude-legal-cn 激活
    -> 自动 git pull 上游 SH88-source 最新内容
      -> 同步 CLAUDE.md + references 到 ~/.codex/skills/
        -> 检查 config.toml MCP 状态
          -> 读取最新工作流指令
            -> 完成法律任务
`

### solo-law-firm 更新
`
GitHub Actions 每周一触发
  -> 检测 saysoph/solo-law-firm-agents 最新提交
    -> 对比本地缓存 SHA
      +-- 无变化 -> 跳过
      +-- 有新提交
          +-- 新增技能 -> 自动按 department 放入对应目录
          +-- 已合并技能 -> 跳过（标记需人工审核）
          +-- 创建 PR (label: upstream-sync) -> 人工审核合并
`

## 上游监测

| 监测目标 | 方式 | 频率 |
|---------|------|------|
| claude-for-legal 上游链（4 仓库） | Issue 通知 | 每周一 |
| npm 包更新（2 包） | Issue 通知 | 每周一 |
| solo-law-firm-agents | 自动同步 PR | 每周一 |

## 依赖关系

- **SH88-source/claude-for-legal-CN**（Apache 2.0）— claude-for-legal 直接上游
- **saysoph/solo-law-firm-agents**（MIT）— solo-law-firm 上游
- **Codex-Claude-legal-CN-mcp-connectors**（独立仓库）— MCP 连接器管理
