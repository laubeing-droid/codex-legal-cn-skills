#!/usr/bin/env bash
# install.sh — 通用安装：Codex Desktop / Claude Code / Claude Desktop (macOS/Linux)
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
VENDOR_DIR="${HOME}/.codex/vendor"
UPSTREAM_DIR="${VENDOR_DIR}/claude-for-legal-CN"
GIT_URL="https://github.com/SH88-source/claude-for-legal-CN.git"
SKILLS_DIR="${HOME}/.codex/skills"
CLAUDE_RULES_DIR="${HOME}/.claude/rules"
CLAUDE_CODE_CONFIG="${HOME}/.claude/settings.json"
MCP_REPO_URL="https://github.com/laubeing-droid/codex-legal-mcp-connectors.git"
MCP_DIR="${REPO_ROOT}/mcp-connectors"

DOMAINS=(
    commercial-legal privacy-legal product-legal corporate-legal
    employment-legal regulatory-legal ai-governance-legal litigation-legal
    law-student legal-clinic legal-builder-hub ip-legal
)

echo "=== 中国法律技能包 通用安装 ==="
echo ""

# 环境检测
HAS_CODEX=false; [ -d "${HOME}/.codex" ] && HAS_CODEX=true
HAS_CLAUDE_CODE=false; [ -f "$CLAUDE_CODE_CONFIG" ] && HAS_CLAUDE_CODE=true
HAS_CLAUDE_DESKTOP=false; [ -f "${HOME}/Library/Application Support/Claude/claude_desktop_config.json" ] && HAS_CLAUDE_DESKTOP=true

TARGETS=""
$HAS_CODEX && { echo "  [OK] Codex Desktop"; TARGETS="${TARGETS}codex "; } || echo "  [!]  Codex Desktop (未安装)"
$HAS_CLAUDE_CODE && { echo "  [OK] Claude Code"; TARGETS="${TARGETS}claude-code "; } || echo "  [!]  Claude Code (未安装)"
$HAS_CLAUDE_DESKTOP && { echo "  [OK] Claude Desktop"; TARGETS="${TARGETS}claude-desktop "; } || echo "  [!]  Claude Desktop (未安装)"

[ -z "$TARGETS" ] && { echo "  将仅安装上游缓存"; TARGETS="codex "; }
echo ""

# [1/4] 上游内容
echo "[1/4] 克隆上游法律内容..."
mkdir -p "$VENDOR_DIR"
if [ -f "$UPSTREAM_DIR/README.md" ]; then
    (cd "$UPSTREAM_DIR" && git pull 2>&1 | tail -1)
    echo "  上游已是最新: $UPSTREAM_DIR"
else
    echo "  正在克隆: $GIT_URL"
    (cd "$VENDOR_DIR" && git clone "$GIT_URL" claude-for-legal-CN 2>&1 | tail -1)
    [ -f "$UPSTREAM_DIR/README.md" ] || { echo "  [错误] 克隆失败"; exit 1; }
    echo "  上游已克隆"
fi

# [2/4] 安装技能
echo "[2/4] 安装技能..."
for name in "${DOMAINS[@]}"; do
    src="$UPSTREAM_DIR/$name"
    [ -d "$src" ] || continue

    # Codex Desktop
    if echo "$TARGETS" | grep -q "codex"; then
        tgt="$SKILLS_DIR/$name"
        mkdir -p "$tgt"
        [ -f "$REPO_ROOT/skills/$name/SKILL.md" ] && cp "$REPO_ROOT/skills/$name/SKILL.md" "$tgt/SKILL.md"
        [ -f "$src/CLAUDE.md" ] && cp "$src/CLAUDE.md" "$tgt/CLAUDE.md"
        [ -f "$src/README.md" ] && cp "$src/README.md" "$tgt/README.md"
        [ -d "$src/references" ] && { mkdir -p "$tgt/references"; cp "$src/references/"* "$tgt/references/" 2>/dev/null || true; }
        [ -d "$src/skills" ] && for sub in "$src/skills/"*/; do
            [ -d "$sub" ] && { mkdir -p "$tgt/skills/$(basename "$sub")"; [ -f "$sub/SKILL.md" ] && cp "$sub/SKILL.md" "$tgt/skills/$(basename "$sub")/SKILL.md"; }
        done
        [ -d "$src/agents" ] && { mkdir -p "$tgt/agents"; cp "$src/agents/"* "$tgt/agents/" 2>/dev/null || true; }
    fi

    # Claude Code
    if echo "$TARGETS" | grep -q "claude-code"; then
        mkdir -p "$CLAUDE_RULES_DIR"
        rule_file="$CLAUDE_RULES_DIR/legal-$name.md"
        if [ ! -f "$rule_file" ]; then
            readme_content=""
            [ -f "$src/README.md" ] && readme_content=$(cat "$src/README.md")
            claude_content=""
            [ -f "$src/CLAUDE.md" ] && claude_content=$(cat "$src/CLAUDE.md")
            cat > "$rule_file" <<-RULES
# 中国法律技能：$name
# 自动生成自 SH88-source/claude-for-legal-CN

## 领域说明
${readme_content:-中国法律 $name 领域技能}

## 上游指令
上游完整内容缓存于: $src
RULES
            echo "  [添加] Claude Code -> $name"
        else
            echo "  [跳过] Claude Code -> $name"
        fi
    fi
done

# 根技能
if echo "$TARGETS" | grep -q "codex"; then
    mkdir -p "$SKILLS_DIR/codex-for-legal-cn"
    cp "$REPO_ROOT/skills/codex-for-legal-cn/SKILL.md" "$SKILLS_DIR/codex-for-legal-cn/SKILL.md"
fi
if echo "$TARGETS" | grep -q "claude-code"; then
    routing_file="$CLAUDE_RULES_DIR/legal-routing.md"
    if [ ! -f "$routing_file" ]; then
        cat > "$routing_file" <<-'ROUTING'
# 中国法律技能自动路由规则

| 关键词 | 路由到 |
|--------|--------|
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

## 重要限制
- 所有输出均为律师审查草稿，不构成法律意见
- 引用法规须核验现行有效性
- 提交/发送前需经执业律师审核
ROUTING
        echo "  [添加] Claude Code -> legal-routing"
    fi
fi
echo "  技能安装完成"

# [3/4] MCP 连接器
echo "[3/4] 配置 MCP 连接器..."
if [ ! -f "$MCP_DIR/detect.sh" ]; then
    echo "  正在克隆 MCP 连接器仓库..."
    (cd "$REPO_ROOT" && git clone --depth 1 "$MCP_REPO_URL" mcp-connectors 2>&1 | tail -1)
fi
if [ -f "$MCP_DIR/install.sh" ]; then
    echo "  运行 MCP 连接器安装脚本..."
    chmod +x "$MCP_DIR/install.sh" && "$MCP_DIR/install.sh"
else
    echo "  [警告] 无法获取 MCP 连接器，跳过"
fi

# [4/4] 验证
echo "[4/4] 验证..."
if echo "$TARGETS" | grep -q "codex"; then
    missing=""
    for name in "${DOMAINS[@]}" "codex-for-legal-cn"; do
        [ ! -f "$SKILLS_DIR/$name/SKILL.md" ] && missing="$missing $name"
    done
    [ -z "$missing" ] && echo "  [OK] Codex: 13 个技能" || echo "  [!!] Codex: 缺失$missing"
fi
if echo "$TARGETS" | grep -q "claude-code"; then
    count=$(ls "$CLAUDE_RULES_DIR"/legal-*.md 2>/dev/null | wc -l | tr -d ' ')
    echo "  [OK] Claude Code: $count 个规则文件"
fi

echo ""
echo "安装完成！重启对应客户端使生效。"
