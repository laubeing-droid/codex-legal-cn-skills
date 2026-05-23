# 项目关系分析

## 一、总览

七个项目分布在三个平台上（Claude Code、Codex、浏览器、Workbuddy），开始初步构成中国法律 AI 工作流的生态链。本仓库作为 Codex 平台的整合入口，将之前上游内容整合后以一键安装的方式交付给中国律师使用。

## 二、演进路线

``
anthropics/claude-for-legal  (Anthropic 官方, 美国法参考实现)
        │
        ▼
zhou210712/claude-for-legal-ZH  (首版中国法汉化适配)
        │
        ▼
SH88-source/claude-for-legal-CN  (持续维护版本)
        │
        ├──→ drdavid-kor/claude-for-legal-cn-online  (在线网页版)
        ├──→ MAXXXXXLI/workbuddy-cn-legal-skills     (豆包工作台版)
        │
        ▼
gjhcsjamin/codex-for-legal-CN  (Codex 平台封装)
        │
        ▼
laubeing-droid/codex-legal-cn-skills  (本仓库, 全功能整合)
``

## 三、逐项目介绍

### 1. anthropics/claude-for-legal

- **作者**: Anthropic PBC
- **定位**: Claude Code / Cowork 平台的法律工作流参考实现
- **内容**: 12 个法律领域插件 + 5 个托管 Agent 蓝图 + 16 个 MCP 连接器
- **法律基础**: 美国法
- **平台**: Claude Code（终端）/ Claude Cowork（桌面）
- **许可证**: Apache 2.0
- **意义**: 整个生态的源头项目

### 2. zhou210712/claude-for-legal-ZH（中文汉化版）

- **作者**: CSlawyer1985 / zhou210712
- **定位**: 对 Anthropic 官方项目进行中国法适配的版本
- **核心工作**: 将 12 个插件领域从美国法体系替换为中国法体系
  - 合同法 → 民法典合同编
  - 诉讼法 → 民事诉讼法
  - 劳动法 → 劳动合同法
  - 隐私法 → 个人信息保护法、数据安全法
  - 公司法 → 中国公司法
  - 检索工具 → 元典 MCP、北大法宝
  - 等 12 个领域
- **额外工作**: 新增中国法核心规则参考文件
- **平台**: Claude Code
- **意义**: 中国法律 AI 工作流的基础版本

### 3. SH88-source/claude-for-legal-CN

- **作者**: SH88-source
- **定位**: 在 zhou210712 基础上持续维护的中国法版本
- **命名空间**: claude-for-legal-cn
- **平台**: Claude Code
- **意义**: 当前最活跃维护的中国法版本，作为本仓库的直接上游

### 4. drdavid-kor/claude-for-legal-cn-online（在线网页版）

- **作者**: drdavid-kor
- **定位**: BYOK（自带 API Key）在线 Web 应用
- **技术栈**: Cloudflare Workers + Static Assets
- **来源**: 以 SH88-source 仓库为 git submodule
- **使用方式**: 无需安装 CLI 工具，打开浏览器即可使用
- **两种模式**: Demo 模式（8 个预设场景）和 Expert 模式（9 个专业领域）
- **支持**: OpenRouter、SiliconFlow、DeepSeek 等 OpenAI 兼容 API
- **意义**: 降低使用门槛，让不熟悉终端的律师也能用上中国法律 AI 技能

### 5. MAXXXXXLI/workbuddy-cn-legal-skills（豆包版）

- **作者**: MAXXXXXLI
- **定位**: Workbuddy（字节跳动豆包工作台）的技能包
- **来源**: 从 Anthropic 官方版适配到 Workbuddy 平台
- **内容**: 151 个中文命名的技能包
- **覆盖领域**: 商事合同、数据合规、AI治理、产品合规、公司治理、劳动用工、知识产权、争议解决、监管合规、法律援助、中国法学习、技能治理
- **平台**: Workbuddy（豆包）
- **意义**: 将法律 AI 技能扩展到 Workbuddy 平台用户

### 6. gjhcsjamin/codex-for-legal-CN（Codex 封装版）

- **作者**: gjhcsjamin
- **定位**: 面向 Codex（OpenAI CLI）的封装层
- **核心功能**:
  - 自动路由：根据用户输入的关键词自动分发到对应法律领域
  - 安装脚本：提供 install.py 部署到 Codex
  - 兼容入口：同时支持 codex-for-legal-cn 和 claude-for-legal-zh 命名
- **安装方式**: python scripts/install.py
- **平台**: Codex（OpenAI CLI）
- **意义**: 首次将中国法律技能带到 Codex 平台

### 7. laubeing-droid/codex-legal-cn-skills（本仓库）

- **作者**: laubeing-droid
- **定位**: Codex 平台的整合包装层 — 统一入口 + 自动更新 + 完整文档
- **上游**: SH88-source/claude-for-legal-CN（自动拉取中国法技能内容）
- **核心资产**:

  | 资产 | 说明 |
  |------|------|
  | 12 个领域 SKILL.md | 精简入口定义，自动指向上游内容 |
  | 根技能 codex-for-legal-cn | 关键词自动路由 + 自动更新指令 |
  | install.ps1 | 一键自动拉取上游 + 安装到 Codex |
  | update.ps1 | 手动同步最新内容 |
  | 自动更新机制 | 每次使用法律功能时自动同步上游 |
  | GitHub Actions | 每周自动检查上游仓库更新 |
  | 全中文文档 | 使用说明、架构设计、连接器指南等 |

- **安装方式**: .\install.ps1 一键完成
- **许可证**: Apache 2.0
- **平台**: Codex（OpenAI Desktop）

## 四、关键对比

| 维度 | anthropics | zhou210712 | SH88-source | drdavid-kor | MAXXXXXLI | gjhcsjamin | **本仓库** |
|------|-----------|------------|-------------|-------------|-----------|------------|-----------|
| 目标平台 | Claude Code | Claude Code | Claude Code | 浏览器 | Workbuddy | Codex | **Codex** |
| 法律体系 | 美国法 | 中国法 | 中国法 | 中国法 | 中国法 | 中国法 | **中国法** |
| 安装方式 | plugin install | plugin install | plugin install | 打开网页 | 上传 zip | install.py | **install.ps1** |
| 自动更新 | git pull | git pull | git pull | 重新部署 | 重新下载 | git pull | **自动集成** |
| 文档语言 | 英文 | 中文 | 中文 | 中文 | 中文 | 中/英 | **中文** |
| 安装步骤 | 多步 | 多步 | 多步 | 1 步 | 2 步 | 1 步 | **1 步** |

## 五、本仓库的定位与价值

### 解决的问题

| 需求 | 上游状态 | 本仓库方案 |
|------|---------|-----------|
| 在 Codex 上用中国法技能 | 需手动克隆配置 | install.ps1 一键安装 |
| 保持技能最新 | 各项目手动更新 | 自动 git pull + Actions 监测 |
| 中文文档 | 英文为主 | 完整中文文档体系 |
| 使用便捷性 | 需了解多个仓库 | 单一仓库 clone 即用 |

### 本仓库的工作范围

1. **选型集成**: 选择适合 Codex 的中国法内容源
2. **一键安装**: 编写 install.ps1，自动完成克隆、部署、配置
3. **技能入口**: 为 12 个领域编写 SKILL.md，创建根技能 codex-for-legal-cn
4. **自动路由**: 在根技能中实现关键词到对应法律领域的自动分发
5. **更新机制**: 每次调用技能时自动同步上游最新内容
6. **上游监测**: GitHub Actions 每周自动检查上游链更新
7. **文档建设**: 完整的项目分析、使用指南、架构说明、故障排除等
8. **分发交付**: 打包为可发布的 GitHub 仓库

### 本仓库不涉及的范围

- 不直接修改上游的法律内容原文
- 不提供在线网页版服务
- 不跨平台转码（如转为 Workbuddy 格式）

## 六、角色汇总

| 项目 | 角色定位 | 面向平台 |
|------|---------|---------|
| anthropics/claude-for-legal | 上游源头 | Claude Code |
| zhou210712/claude-for-legal-ZH | 中国法首版汉化 | Claude Code |
| SH88-source/claude-for-legal-CN | 持续维护的中国法版本 | Claude Code |
| drdavid-kor/...-online | 在线网页版适配 | 浏览器 |
| MAXXXXXLI/workbuddy-cn-legal-skills | 豆包平台适配 | Workbuddy |
| gjhcsjamin/codex-for-legal-CN | 首次 Codex 封装 | Codex |
| **本仓库** | **Codex 全功能整合** | **Codex** |
