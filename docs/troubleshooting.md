<!--
version: 2.9.0
module: docs
status: active
-->

# 故障排除

## 安装问题

| 问题 | 原因 | 解决 |
|:-----|:-----|:-----|
| 技能没出现 | 未安装或未重启 | 运行 `.\install.ps1`，重启 Codex |
| solo-law-firm 没装 | 嵌套 8 科室结构需独立处理 | `install.ps1` 有专门逻辑处理，重试即可 |
| 部分技能缺失 | 子目录复制异常 | 删掉 `~/.codex/skills/` 下对应目录，重新安装 |

## 使用问题

| 问题 | 原因 | 解决 |
|:-----|:-----|:-----|
| 引用标注 [需验证] | MCP 未配置 | 编辑 `~/.codex/config.toml` 填入 Key |
| 技能混入美国法概念 | 护栏未生效 | 检查 `skills/references/blocking-list.md` 是否存在 |
| 输出还是英文 | CLAUDE.md 未中文化 | `patches/workflows/` 有 12 个中文快照对照 |

## 上游检测问题

| 问题 | 原因 | 解决 |
|:-----|:-----|:-----|
| diff-tool 报 git 错 | TEMP 目录冲突 | 删 `$env:TEMP\zhou-check` 重试 |
| 所有子技能都是 [Δ] | 快照来源错误 | 首次 `-Update` 应从上游（非本地）创建快照 |
| 多个 diff-tool 运行 | 本仓库跟踪 4 个上游，各有独立脚本 | 正常运行 |

## 性能

| 问题 | 说明 |
|:-----|:-----|
| 首次 diff-tool 慢 | 要 git clone，之后有 TEMP 缓存 |
| 本仓库比单上游版重 | 因为整合了 3 个上游 + 自研，内容更全 |

