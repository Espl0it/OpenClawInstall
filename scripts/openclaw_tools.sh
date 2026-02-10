#!/bin/bash
# OpenClaw 工具整合脚本
# 包含：qmd 本地记忆系统、Memos 备忘录集成

# ========================================
# 公共配置
# ========================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

WORKSPACE=${OPENCLAW_WORKSPACE:-/home/ubuntu/.openclaw/workspace}

# ========================================
# Memos 配置
# ========================================
MEMOS_CONTAINER="memos"
MEMOS_PORT="6000"

# ========================================
# QMD 配置
# ========================================
QMD_BIN="/home/ubuntu/.bun/bin/qmd"

# ========================================
# 公共函数
# ========================================

# 彩色输出
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查 Docker
check_docker() {
    if ! command -v docker &> /dev/null; then
        log_error "Docker 未安装"
        return 1
    fi
    if ! docker ps &> /dev/null; then
        log_error "Docker 未运行"
        return 1
    fi
    return 0
}

# ========================================
# QMD 子命令
# ========================================

cmd_qmd_help() {
    echo ""
    echo "========================================"
    echo "  qmd 本地记忆系统"
    echo "========================================"
    echo ""
    echo "  子命令："
    echo "    install     安装 qmd"
    echo "    status      查看状态"
    echo "    search      搜索"
    echo "    embed      更新索引"
    echo "    list        列出集合"
    echo ""
}

cmd_qmd_install() {
    log_info "开始安装 qmd 本地记忆系统..."

    # 检查 bun
    if ! command -v bun &> /dev/null; then
        log_error "bun 未安装，请先安装 bun:"
        echo "  curl -fsSL https://bun.sh/install | bash"
        return 1
    fi
    log_info "bun 已安装: $(bun --version)"

    # 安装 qmd
    log_info "安装 qmd..."
    bun install -g https://github.com/tobi/qmd

    # 创建记忆库
    cd "$WORKSPACE"

    # daily-logs
    if ls memory/*.md &> /dev/null; then
        cd memory
        qmd collection add . --name daily-logs 2>/dev/null || log_warn "daily-logs 已存在"
        log_info "✓ daily-logs 集合"
        cd "$WORKSPACE"
    fi

    # workspace
    qmd collection add *.md --name workspace 2>/dev/null || log_warn "workspace 已存在"
    log_info "✓ workspace 集合"

    # 生成 Embedding
    log_info "生成 Embedding（首次需要下载模型约2GB）..."
    qmd embed

    # 配置 MCP
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
    log_info "✓ MCP 配置已创建"

    # 设置自动更新
    CRON_CMD="cd $WORKSPACE && qmd embed"
    if ! crontab -l 2>/dev/null | grep -q "qmd embed"; then
        (crontab -l 2>/dev/null; echo "0 3 * * * $CRON_CMD") | crontab -
        log_info "✓ cron 任务已添加（每天凌晨3点）"
    fi

    log_info "qmd 安装完成！"
}

cmd_qmd_status() {
    cd "$WORKSPACE"
    qmd status
}

cmd_qmd_search() {
    cd "$WORKSPACE"
    shift
    if [ $# -lt 1 ]; then
        echo "用法: $0 qmd search <关键词>"
        return 1
    fi
    qmd search daily-logs "$@" --hybrid
}

cmd_qmd_embed() {
    cd "$WORKSPACE"
    qmd embed
}

cmd_qmd_list() {
    cd "$WORKSPACE"
    qmd collection list
}

# ========================================
# Memos 子命令
# ========================================

cmd_memos_help() {
    echo ""
    echo "========================================"
    echo "  Memos 备忘录集成"
    echo "========================================"
    echo ""
    echo "  子命令："
    echo "    status     检查状态"
    echo "    logs       查看日志"
    echo "    create     创建备忘录"
    echo "    sync       同步文件"
    echo ""
}

cmd_memos_status() {
    if ! check_docker; then
        return 1
    fi

    if docker ps --format '{{.Names}}' | grep -q "^${MEMOS_CONTAINER}$"; then
        log_info "✓ Memos 容器运行中"
    else
        log_error "✗ Memos 容器未运行"
    fi
}

cmd_memos_logs() {
    if ! check_docker; then
        return 1
    fi
    docker logs -f "$MEMOS_CONTAINER" --tail 50
}

cmd_memos_create() {
    if ! check_docker; then
        return 1
    fi

    shift
    if [ $# -lt 1 ]; then
        echo "用法: $0 memos create <内容>"
        return 1
    fi

    local content="$1"
    docker exec "$MEMOS_CONTAINER" curl -s -X POST \
        "http://localhost:5230/api/v1/memos" \
        -H "Content-Type: application/json" \
        -d "{\"content\": \"${content}\", \"visibility\": \"PUBLIC\"}"
}

cmd_memos_sync() {
    if ! check_docker; then
        return 1
    fi

    shift
    if [ $# -lt 1 ]; then
        echo "用法: $0 memos sync <文件路径>"
        return 1
    fi

    local file_path="$1"
    if [ ! -f "$file_path" ]; then
        log_error "文件不存在: ${file_path}"
        return 1
    fi

    local content=$(cat "$file_path")
    local filename=$(basename "$file_path")

    log_info "同步文件到 Memos: ${filename}"
    docker exec "$MEMOS_CONTAINER" curl -s -X POST \
        "http://localhost:5230/api/v1/memos" \
        -H "Content-Type: application/json" \
        -d "{\"content\": \"${content}\", \"visibility\": \"PUBLIC\"}"
}

# ========================================
# 主程序
# ========================================

show_help() {
    echo ""
    echo "========================================"
    echo "  OpenClaw 工具箱"
    echo "========================================"
    echo ""
    echo "  命令："
    echo "    qmd      本地记忆系统"
    echo "    memos    Memos 备忘录"
    echo "    help     显示帮助"
    echo "    all      安装/检查所有组件"
    echo ""
    echo "  示例："
    echo "    $0 qmd search \"Alex 偏好\""
    echo "    $0 memos create \"今天的心情很好\""
    echo "    $0 memos sync /path/to/file.md"
    echo ""
}

show_menu() {
    show_help
    read -p "请选择命令: " cmd
    case "$cmd" in
        qmd)
            shift
            handle_qmd "$@"
            ;;
        memos)
            shift
            handle_memos "$@"
            ;;
        all)
            log_info "安装所有组件..."
            cmd_qmd_install
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            log_error "未知命令: $cmd"
            show_help
            ;;
    esac
}

handle_qmd() {
    local subcmd="${1:-help}"
    shift
    case "$subcmd" in
        install)
            cmd_qmd_install
            ;;
        status)
            cmd_qmd_status
            ;;
        search)
            cmd_qmd_search "$@"
            ;;
        embed)
            cmd_qmd_embed
            ;;
        list)
            cmd_qmd_list
            ;;
        help|--help|-h|"")
            cmd_qmd_help
            ;;
        *)
            log_error "未知 qmd 子命令: $subcmd"
            cmd_qmd_help
            ;;
    esac
}

handle_memos() {
    local subcmd="${1:-help}"
    shift
    case "$subcmd" in
        status)
            cmd_memos_status
            ;;
        logs)
            cmd_memos_logs
            ;;
        create)
            cmd_memos_create "$@"
            ;;
        sync)
            cmd_memos_sync "$@"
            ;;
        help|--help|-h|"")
            cmd_memos_help
            ;;
        *)
            log_error "未知 memos 子命令: $subcmd"
            cmd_memos_help
            ;;
    esac
}

main() {
    if [ $# -eq 0 ]; then
        show_menu
        exit 0
    fi

    local cmd="$1"
    shift

    case "$cmd" in
        qmd)
            handle_qmd "$@"
            ;;
        memos)
            handle_memos "$@"
            ;;
        all)
            cmd_qmd_install
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            log_error "未知命令: $cmd"
            show_help
            exit 1
            ;;
    esac
}

main "$@"
