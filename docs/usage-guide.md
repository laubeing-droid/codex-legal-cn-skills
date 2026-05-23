# 使用指南

## 一、安装

### 前置条件

- 已安装 Codex Desktop
- 操作系统：Windows 10/11
- 已安装 Git（[下载](https://git-scm.com/downloads)）
- 网络：能访问 github.com（如在中国可能需要代理）

### 安装步骤

```powershell
# 克隆本仓库
git clone https://github.com/laubeing-droid/codex-legal-cn-skills.git
cd codex-legal-cn-skills

# 一键安装
.\install.ps1
```

安装脚本会自动完成：

1. 克隆上游法律内容仓库（SH88-source/claude-for-legal-CN）
2. 创建 12 个领域技能的入口文件（SKILL.md）
3. 设置目录联接，便于自动更新
4. 复制每个领域的完整工作流指令（CLAUDE.md）和法律参考文件

安装完成后重启 Codex Desktop 即可使用。

### 验证安装

检查技能目录是否存在：

```powershell
Get-ChildItem "$env:USERPROFILE\.codex\skills\"
```

应列出以下目录（共 13 个）：

```
codex-for-legal-cn     根技能（路由+更新）
commercial-legal       商事合同
litigation-legal       诉讼仲裁
employment-legal       劳动用工
privacy-legal          数据合规
corporate-legal        公司交易
ip-legal               知识产权
product-legal          产品合规
regulatory-legal       监管合规
ai-governance-legal    AI 治理
law-student            法学生/法考
legal-clinic           法律诊所
legal-builder-hub      技能治理中心
```

## 二、使用方式

### 方式一：自动路由（推荐）

直接在 Codex 中描述你的法律工作任务，系统会根据关键词自动识别并调用对应技能。

| 你说 | 自动路由到 |
|------|-----------|
| 帮我审查这份 SaaS 服务协议 | commercial-legal |
| 分析这个案件的管辖权问题 | litigation-legal |
| 评估个人信息保护合规风险 | privacy-legal |
| 起草一份竞业限制协议 | employment-legal |
| 做个并购尽调问题清单 | corporate-legal |
| 查一下这个商标能不能注册 | ip-legal |
| 检查这个产品上线合规性 | product-legal |
| 追踪最近三个月的监管动态 | regulatory-legal |
| 评估这个 AI 产品的法律风险 | ai-governance-legal |
| 帮我分析这个法考案例 | law-student |
| 法律援助接谈记录 | legal-clinic |

### 方式二：手动指定

如果自动路由没有命中，或者你想精确控制使用哪个技能，可以在对话开头使用 `@技能名`：

```
@codex-for-legal-cn 帮我审这份合同
@litigation-legal 分析一下证据问题
@commercial-legal/review 审查这份 NDA
```

## 三、自动更新机制

每次在 Codex 中使用法律技能时，根技能会自动执行以下操作：

1. 查找上游仓库（优先同级目录，其次 vendor 链接）
2. `git pull` 拉取 SH88-source/claude-for-legal-CN 最新内容
3. 同步 CLAUDE.md + references + 子技能到 `~/.codex/skills/`
4. 本次对话直接使用最新内容，无需重启

整个过程静默执行，不影响你的对话体验。

### 手动更新

如果需要立即获取最新内容：

```powershell
cd codex-legal-cn-skills
.\update.ps1
```

## 四、技能清单

| 技能 | 领域 | 内容 |
|------|------|------|
| codex-for-legal-cn | 根技能（自动路由+更新） | 路由规则、更新指令 |
| commercial-legal | 商事合同 | 合同审查、谈判、NDA 审查等 12 子技能 |
| litigation-legal | 诉讼仲裁 | 证据分析、案件管理、代理词起草等 19 子技能 |
| employment-legal | 劳动用工 | 劳动合同、竞业限制、工伤处理等 20 子技能 |
| privacy-legal | 数据合规 | 个保法合规、DPA 审查、DSAR 处理等 9 子技能 |
| corporate-legal | 公司交易 | 并购尽调、公司治理、交割检查等 13 子技能 |
| ip-legal | 知识产权 | 商标检索、专利分析、开源合规等 12 子技能 |
| product-legal | 产品合规 | 上线审查、营销审查、风险评估等 7 子技能 |
| regulatory-legal | 监管合规 | 监管动态追踪、差距分析等 9 子技能 |
| ai-governance-legal | AI 治理 | AI 政策起草、供应商审查等 10 子技能 |
| law-student | 法学生/法考 | 案例分析、论文写作、法考备考等 13 子技能 |
| legal-clinic | 法律诊所 | 接待记录、备忘录、状态报告等 16 子技能 |
| legal-builder-hub | 技能治理中心 | 技能安装、管理、QA 等 10 子技能 |

## 五、架构说明

本仓库不直接包含上游法律内容。安装时自动从上游拉取。

```
codex-legal-cn-skills           <- 包装层（本仓库）
  skills/SKILL.md               入口定义 + 路由规则
  install.ps1                   一键安装
  update.ps1                    手动更新
  docs/                         文档
       │
       ▼
SH88-source/claude-for-legal-CN <- 内容层（上游）
  CLAUDE.md                     工作流指令
  references/                   法律参考
  skills/                       子技能
       │
       ▼
~/.codex/skills/<domain>/       <- 运行层
  SKILL.md                      本仓库提供
  CLAUDE.md                     上游同步
  references/                   上游同步
```

## 六、输出说明与注意事项

### 输出定位
- 所有输出均为**律师审查草稿**
- 不构成法律意见，不替代律师判断
- 使用前须经执业律师审核

### 引用标注
- 连接法律检索工具时：引用标注具体来源
- 未连接检索工具时：引用标注 **[需验证]**
- 无论是否连接，建议均通过人工检索核实

### 法律假设
- 默认假设适用中国法律（中国大陆）
- 如涉及其他法域，需在问题中明示

## 七、进阶配置

### 配置 MCP 连接器

参考 docs/connectors.md 配置法律检索工具。

### 自定义路由关键词

编辑 `skills/codex-for-legal-cn/SKILL.md`，在关键字列表中添加你的常用词汇。

### 上游监测

本仓库配置了 GitHub Actions，每周自动检查上游仓库是否有更新。有变化时自动创建 Issue 通知。
