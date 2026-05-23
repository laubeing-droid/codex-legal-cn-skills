# 使用指南

## 一、安装

### 前置条件
- 已安装 Codex Desktop
- 系统：Windows 10/11

### 安装步骤

```powershell
git clone https://github.com/laubeing-droid/codex-legal-cn-skills.git
cd codex-legal-cn-skills
.\install.ps1
```

安装脚本会自动：
1. 克隆上游法律内容
2. 创建 12 个领域技能的入口文件
3. 设置目录联接，便于自动更新
4. 复制每个领域的 CLAUDE.md 和 references
安装后重启 Codex Desktop 即可使用。

## 二、使用方式

### 方式一：自动路由（推荐）
直接在 Codex 中描述法律工作任务，系统会自动识别并调用对应技能。

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

### 方式二：手动触发
系统自动识别任务类型并路由到对应领域。

## 三、自动更新
每次使用法律功能时，根技能自动执行 git pull 拉取上游最新内容，
同步 CLAUDE.md 和 references 到本地 skills 目录，本次对话直接生效。
静默执行，不影响对话。

## 四、技能清单

| 技能 | 领域 | 内容量 |
|------|------|--------|
| codex-for-legal-cn | 根技能（自动路由+更新） | - |
| commercial-legal | 商事合同 | 43KB + 12子技能 |
| litigation-legal | 诉讼仲裁 | 28KB + 19子技能 |
| employment-legal | 劳动用工 | 32KB + 20子技能 |
| privacy-legal | 数据合规 | 25KB + 9子技能 |
| corporate-legal | 公司交易 | 27KB + 13子技能 |
| ip-legal | 知识产权 | 17KB + 12子技能 |
| product-legal | 产品合规 | 23KB + 7子技能 |
| regulatory-legal | 监管合规 | 10KB + 9子技能 |
| ai-governance-legal | AI治理 | 16KB + 10子技能 |
| law-student | 法学生/法考 | 35KB + 13子技能 |
| legal-clinic | 法律诊所 | 29KB + 16子技能 |
| legal-builder-hub | 技能治理中心 | 11KB + 10子技能 |

## 五、常见问题

Q: Codex 没有自动识别法律任务？
检查 ~/.codex/skills/codex-for-legal-cn/SKILL.md 是否存在。
如果不存在，重新运行 install.ps1。

Q: 技能输出不准确？
- 所有输出均为律师审查草稿，不构成法律意见
- 引用法规、案例时必须另行核验现行有效性
- 系统默认中国法（大陆），其他法域需明示
- 任何提交、发送或依赖前需经执业律师审核

Q: 如何手动更新？
运行 update.ps1 即可。

## 六、架构关系

本仓库是包装层，不包含上游法律内容副本。安装时自动拉取。

```
codex-legal-cn-skills    <- 包装层
  skills/SKILL.md        入口定义 + 路由规则
  install.ps1            一键安装
  update.ps1             手动更新
  docs/                  文档
       |
       v
SH88-source/claude-for-legal-CN  <- 上游
  CLAUDE.md              工作流指令
  references/            中国法规则
  skills/                子技能
       |
       v
~/.codex/skills/domain/   <- 运行层
  SKILL.md               本仓库提供
  CLAUDE.md              上游同步
  references/            上游同步
```
