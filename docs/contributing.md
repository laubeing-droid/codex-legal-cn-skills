# 贡献指南

## 本仓库的贡献模型

本仓库不是普通项目——它是一个**中国法适配工程**，每一层都有明确的贡献方向：

### 法条层（qulv 知识库）

```
skills/knowledge-base/
├── 新增法律 → 放入官方 PDF，更新 MAPPING.md
└── 修正条文 → 替换 PDF，标注变更
```

### 内容层（子技能）

```
skills/*/skills/
├── 新增中国法子技能 → 创建目录 + SKILL.md
├── 修改已有技能 → 编辑 SKILL.md，更新跨文件命令引用
└── 合并上游更新 → 运行 diff-tool，手动合并有价值的变更
```

### 护栏层

```
patches/guards/ + skills/references/
├── 新增阻断概念 → 加入 blocking-list.md
├── 新增概念映射 → 加入 patches/references/alignment/
└── 新增香港桥梁 → 加入 hk-bridge.md
```

### 监控层

```
patches/diff-tool-zhou.ps1
├── 新增跟踪文件 → 加入 $files 数组
├── 调整映射规则 → 修改路径映射
└── 新增上游 → 创建新的 diff-tool-*.ps1
```

## 工作流

1. Fork 本仓库
2. 修改对应文件
3. 运行 `.\verify.ps1` 确认完整性
4. 提交 PR

## 注意

- 不要提交 API 密钥到仓库
- 上游变更通过 Issues + diff-tool 处理，不自动合并
