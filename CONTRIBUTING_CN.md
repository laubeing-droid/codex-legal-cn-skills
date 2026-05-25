# CONTRIBUTING_CN.md — 贡献指南

> 欢迎贡献！本文档说明如何参与本仓库的开发。建议先阅读 `README.md` 了解项目全貌。

---

## 一、项目架构速览

```
Claude-for-Legal-CN-to-Codex/
├── skills/                  # 12 领域 + solo-law-firm 技能
│   ├── commercial-legal/    # 每个领域 = claude-for-legal 结构
│   │   ├── CLAUDE.md        # 领域级系统指令（含护栏注入）
│   │   ├── skills/          # 子技能目录
│   │   └── references/      # 法条/案例/对齐参考
│   └── ...
├── patches/                 # 本仓库的"增量层"
│   ├── guards/              # 护栏文件（阻断清单/元规则等）
│   ├── workflows/           # 上游 CLAUDE.md 快照
│   ├── connectors/          # MCP 配置快照
│   ├── references/          # 法条/语境/对齐文件
│   │   ├── alignment/       # 12 领域中美概念映射
│   │   └── context/         # MAXXXXXLI 中国法语境
│   └── overlay.yaml         # 声明式 override 配置
├── benchmark/               # 对抗测试集
├── docs/                    # 架构/治理/使用文档
├── install.ps1              # 部署脚本
├── update.ps1               # 更新脚本
├── verify.ps1               # 完整性验证
└── .github/workflows/       # CI 监控
```

---

## 二、贡献入口

### 你想做什么？ → 对应目录

| 想做什么 | 去哪里 |
|:---------|:-------|
| 新增/修改中国法律子技能 | `skills/*/skills/` |
| 增强护栏（新增阻断概念） | `patches/guards/blocking-list.md` |
| 完善中美概念映射 | `patches/references/alignment/` |
| 补充法条引用 | `skills/*/references/`（引用 qulv） |
| 新增对抗测试用例 | `benchmark/adversarial-tests.md` |
| 改进部署脚本 | `install.ps1` / `update.ps1` |
| 优化 CI 工作流 | `.github/workflows/` |
| 完善文档 | `docs/` / `README.md` |

---

## 三、提交规范

### 分支命名

```
codex/<简短描述>
```

示例：`codex/add-labor-arbitration-skill`、`codex/fix-blocking-list`

### Commit 格式

```
<类型>: <简短描述>

<详细说明（可选）>
```

类型：
- `feat`: 新功能
- `fix`: 修复
- `docs`: 文档
- `guard`: 护栏层变更
- `align`: 对齐层变更
- `sync`: 上游同步

---

## 四、护栏层贡献规范

修改 `blocking-list.md` 的前置检查：
1. 该概念是否在中国法确实不存在？（查阅中国法律确认）
2. 该概念是否有中国等效制度？（决定处理方式：阻断/替换）
3. 修改后运行 `python D:\scan_terms.py` 确认无误报
4. 在 `benchmark/adversarial-tests.md` 新增对应对抗用例

---

## 五、子技能贡献规范

### 新增子技能

```
skills/<领域>/skills/<技能名>/
├── SKILL.md          # 技能定义（触发条件/参数/工作流）
├── _README.md        # 不可提交案卷内容
└── (可选) 其他资源文件
```

### SKILL.md 必须包含

- 触发条件
- 输入参数
- 工作流步骤
- 引法依据（中国法律条文）
- 护栏规则（如果涉及美国法风险概念）

### 禁止内容

- API Key / Token
- 真实案卷信息
- 客户个人数据
- 美国法条文引用（除非标注为对比学习用且加 ❌ 标记）

---

## 六、测试要求

提交前请确保：

```powershell
# 护栏完整性
.\verify.ps1 -Quick

# 美国法术语扫描（零残留）
python D:\scan_terms.py
# 预期输出：ALL CLEAN

# 对抗测试（逐条验证新用例）
.\benchmark\run-benchmark.ps1
```

---

## 七、上游同步

本仓库不从上游自动合并。如需同步上游更新：

1. 运行对应 diff-tool 检查变更
2. 审查变更内容是否符合中国化适配原则
3. 手动合并通过审查的内容
4. 更新 UPSTREAM_DIFF_POLICY.md 中的变更记录

详见 `docs/UPSTREAM_DIFF_POLICY.md`。

---

## 八、行为准则

- 尊重上游贡献者的劳动（见 CREDITS.md 和 THIRDPARTY.md）
- 不提交侵犯第三方版权的法条全文（引用官方来源）
- 讨论聚焦技术问题和法律适配，避免法域优劣争论
- 中文交流优先，英文可接受但推荐提供中英对照

---

## 九、许可证

本仓库采用 Apache License 2.0。提交代码即表示你同意在此许可证下发布你的贡献。

参见 `LICENSE` 和 `THIRDPARTY.md`。
