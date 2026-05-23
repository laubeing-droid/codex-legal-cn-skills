# 项目源流分析与关系说明

## 一、五个项目的全景关系

以下五个项目均衍生于同一个上游，但面向不同平台和使用场景：

`
Anthropic 官方 claude-for-legal（美国法）
  └─ https://github.com/anthropics/claude-for-legal
     └─ 许可证: Apache 2.0
     └─ 内容: 面向美国法的 Claude Code 插件（UCC、FRCP、GDPR 等）
              ↓
              ↓ 全面汉化：美国法 → 中国法本地化改造
              ↓
     zhou210712/claude-for-legal-ZH  ← 原始中文汉化版
     └─ https://github.com/zhou210712/claude-for-legal-ZH
     └─ 身份: 第一个将 Anthropic 官方项目全面汉化为中国法的版本
     └─ 作者: CSlawyer1985 / zhou210712
     └─ 汉化范围: 12 个插件领域的美国法全部替换为中国法
          - 合同法: UCC → 民法典合同编
          - 诉讼法: FRCP → 民事诉讼法
          - 劳动法: FLSA → 劳动合同法
          - 隐私法: GDPR/CCPA → 个保法/数安法
          - 公司法: Delaware law → 中国公司法
          - 等 12 个领域
     └─ 特点: 保留 Claude Code 插件格式，有 docs/ 官网页面
     └─ 命名空间: claude-for-legal-zh
              │
              ├── SH88-source/claude-for-legal-CN  ← 改名/rebrand 版
              │  └─ https://github.com/SH88-source/claude-for-legal-CN
              │  └─ 身份: 从 zhou210712 仓库 fork 后改名
              │  └─ 核心变化: 只是将插件命名从 -zh 改为 -cn
              │  └─ 内容: 与 zhou210712 版完全一致
              │  └─ 差异: 去掉了致谢部分和 README 图片
              │  └─ 命名空间: claude-for-legal-cn
              │       │
              │       ├── drdavid-kor/claude-for-legal-cn-online
              │       │  └─ https://github.com/drdavid-kor/claude-for-legal-cn-online
              │       │  └─ 类型: 在线 Web 应用（非插件）
              │       │  └─ 技术栈: Cloudflare Workers + Static Assets
              │       │  └─ 核心: 以 SH88-source 仓库为 git submodule
              │       │  └─ 使用方式: BYOK（自带 API Key，浏览器直接用）
              │       │  └─ 模式:
              │       │      - Demo 模式: 8 个预设场景快速体验
              │       │      - Expert 模式: 9 个专业领域技能
              │       │  └─ 隐私: Key 仅存浏览器内存，服务器不持久化
              │       │  └─ 优势: 无需安装任何 CLI 工具
              │       │
              │       └── MAXXXXXLI/workbuddy-cn-legal-skills
              │          └─ https://github.com/MAXXXXXLI/workbuddy-cn-legal-skills
              │          └─ 类型: Workbuddy（字节豆包）技能压缩包
              │          └─ 来源: 从 Anthropic 官方版直接适配到 Workbuddy
              │          └─ 内容: 151 个中文命名的 .zip 技能包
              │          └─ 使用方式: 下载后上传到 Workbuddy 平台
              │          └─ 覆盖: 合同审查、数据合规、AI治理、产品合规、
              │                  公司治理、劳动用工、知识产权、争议解决、
              │                  监管合规、法律援助、中国法学习等
              │
              └── 依赖上游 ──→ gjhcsjamin/codex-for-legal-CN
                 └─ https://github.com/gjhcsjamin/codex-for-legal-CN
                 └─ 类型: Codex（OpenAI CLI）技能封装层
                 └─ 上游: zhou210712/claude-for-legal-ZH
                 └─ 核心功能:
                    - 自动路由: 根据任务关键词自动分发到对应领域
                    - 安装脚本: install.py 一键部署到 Codex
                 └─ 入口: codex-for-legal-cn（兼容入口 claude-for-legal-zh）
                 └─ 优势: 用户不需要记命令，系统自动判断任务类型
`

## 二、各项目对比表

| 对比维度 | zhou210712 | SH88-source | drdavid-kor | MAXXXXXLI | gjhcsjamin |
|---------|-----------|-------------|-------------|-----------|------------|
| **身份** | 原始汉化版 | 改名版 | 在线网页版 | 豆包技能包 | Codex 封装 |
| **平台** | Claude Code | Claude Code | 浏览器 | Workbuddy | Codex |
| **安装方式** | /plugin install | /plugin install | 打开网页 | 上传 zip | install.py |
| **需要 API Key** | 需要 Claude | 需要 Claude | 需要自备 (BYOK) | 不需要 | 需要 Codex |
| **内容量** | 12 插件 | 12 插件 | 2 种模式 | 151 个 skill | 12 领域 |
| **自动更新** | git pull | git pull | 重新部署 | 重新下载 | git pull |
| **是否需装 CLI** | 是 | 是 | 否 | 否 | 是 |
| **中文命名** | 英文插件名 | 英文插件名 | 中文界面 | 全中文 | 英文/中文 |
| **原创性** | 汉化改造 | rebrand | 架构创新 | 平台适配 | 包装创新 |

## 三、本仓库 (codex-legal-cn-skills) 的定位

本仓库 = gjhcsjamin/codex-for-legal-CN 的思路升级 + 你的本地配置打包。

### 相对于五个项目的位置

`
本仓库是第六个项目，定位为"整合打包层"

依赖关系:
  codex-legal-cn-skills (本仓库)
  ├── skills/*/SKILL.md          ← 自创：入口定义 + 路由规则
  ├── install.ps1                ← 自创：一键安装脚本
  ├── update.ps1                 ← 自创：更新脚本
  │
  │ 运行时依赖上游内容:
  └── SH88-source/claude-for-legal-CN
       └── (或 zhou210712/claude-for-legal-ZH，内容一致)
            └── CLAUDE.md         ← 完整工作流指令
            └── references/       ← 中国法核心规则
            └── skills/*/SKILL.md  ← 子技能定义
`

### 与其他五个项目的本质区别

| 对比项 | 其他五个项目 | 本仓库 |
|--------|------------|--------|
| 定位 | 各自面向特定平台 | **打包整合 + 你本地配置的镜像** |
| 内容 | 仅含各自的平台适配 | 含完整安装脚本 + 路由 + 自动更新 |
| 安装 | 需要各自的手动步骤 | **跑 install.ps1 一步到位** |
| 更新 | 各项目独立更新 | **集成在根技能中自动执行** |
| 可分发 | 需要多家仓库配合 | **单一仓库，clone 即用** |

### 本仓库的核心资产

1. **根技能 codex-for-legal-cn** — 自动路由 + 自动更新逻辑
2. **12 个领域 SKILL.md** — 精简入口定义，指向上游具体内容
3. **install.ps1** — 自动拉取上游 + 安装到 Codex + 设置目录联接
4. **自动更新机制** — 每次使用法律功能时自动 git pull + 同步

### 为什么不直接用一个上游项目？

因为没有一个项目能同时满足：
- zhou210712/SH88-source → 只支持 Claude Code，不是 Codex
- gjhcsjamin → 包装层太薄，缺少自动更新和本地优化
- drdavid-kor → 纯在线版，不能本地使用
- MAXXXXXLI → 只支持豆包

本仓库 = 把 gjhcsjamin 的包装层思路 + 你本地已做的配置优化 + 自动更新合并为一个可分发、可一键安装的独立包。

## 四、推荐搭配策略

| 你的使用场景 | 推荐项目 |
|-------------|---------|
| 日常工作（Codex CLI） | **本仓库 + SH88-source 上游** |
| 快速查资料（不想开终端） | drdavid-kor 在线版 |
| 用豆包 Workbuddy | MAXXXXXLI 技能包 |
| 用 Claude Code | SH88-source 或 zhou210712 原版 |

本仓库是目前唯一**面向 Codex 且自带自动更新**的选项。
