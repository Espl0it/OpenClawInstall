#!/bin/bash

# ========================================
# qmd 本地记忆系统安装脚本
# 用于 OpenClaw AI Agent
# ========================================

set -e

echo "🚀 开始安装 qmd 本地记忆系统..."

# 1. 检查 bun
if ! command -v bun &> /dev/null; then
    echo "❌ bun 未安装，请先安装 bun:"
    echo "   curl -fsSL https://bun.sh/install | bash"
    exit 1
fi
echo "✅ bun 已安装: $(bun --version)"

# 2. 安装 qmd
echo "📦 安装 qmd..."
bun install -g https://github.com/tobi/qmd

# 3. 进入工作目录
WORKSPACE=${1:-/home/ubuntu/.openclaw/workspace}
cd "$WORKSPACE"

# 4. 创建记忆库
echo "📚 创建记忆库..."

# daily-logs
cd memory
if [ -f "*.md" ]; then
    qmd collection add . --name daily-logs 2>/dev/null || echo "daily-logs 已存在"
    echo "✅ daily-logs 集合"
fi

# workspace
cd "$WORKSPACE"
qmd collection add *.md --name workspace 2>/dev/null || echo "workspace 已存在"
echo "✅ workspace 集合"

# 5. 生成 Embedding
echo "🧠 生成 Embedding（首次需要下载模型约2GB）..."
qmd embed

# 6. 配置 MCP
echo "🔗 配置 MCP 集成..."
mkdir -p config
cat > config/mcporter.json << 'EOF'
{
  "mcpServers": {
    "qmd": {
      "command": "/home/ubuntu/.bun/bin/qmd",
      "args": ["mcp"]
    }
  }
}
EOF
echo "✅ MCP 配置已创建: config/mcporter.json"

# 7. 设置自动更新
echo "⏰ 设置自动更新 cron 任务..."
CRON_CMD="cd $WORKSPACE && qmd embed"
if ! crontab -l 2>/dev/null | grep -q "qmd embed"; then
    (crontab -l 2>/dev/null; echo "0 3 * * * $CRON_CMD") | crontab -
    echo "✅ cron 任务已添加（每天凌晨3点自动更新）"
fi

# 8. 完成
echo ""
echo "========================================"
echo "✅ qmd 安装完成！"
echo "========================================"
echo ""
echo "📖 使用方法："
echo "   混合搜索: qmd search daily-logs \"关键词\" --hybrid"
echo "   查看集合: qmd list"
echo "   更新索引: qmd embed"
echo ""
echo "📄 详细文档: $WORKSPACE/QMD_INTEGRATION.md"
echo ""
