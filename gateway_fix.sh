#!/bin/bash

# OpenClaw Gateway 修复脚本
# 版本: 1.1
# 用法: curl -fsSL https://raw.githubusercontent.com/zhengweiyu/openclaw/main/gateway_fix.sh | bash

set -eo pipefail

# ==================== 配置 ====================
readonly SCRIPT_VERSION="1.1"
readonly SCRIPT_URL="https://raw.githubusercontent.com/zhengweiyu/openclaw/main/gateway_fix.sh"
readonly DEBUG="${DEBUG:-0}"
readonly AUTO_ACCEPT="${AUTO_ACCEPT:-1}"
readonly TARGET_USER="${TARGET_USER:-}"

# ==================== 工具函数 ====================
log() {
    local level="$1"
    shift
    [[ "$DEBUG" == "1" ]] && echo "[$level] $*" >&2
}

err() {
    echo "[ERROR] $*" >&2
}

die() {
    err "$1"
    exit "${2:-1}"
}

# 仅交互式且未自动确认时提示
confirm() {
    [[ "$AUTO_ACCEPT" == "1" ]] && return 0
    [[ ! -t 0 ]] && return 0
    local reply
    read -p "$1 [y/N]: " -r reply
    [[ "$reply" =~ ^[yY]([eE][sS])?$ ]]
}

# 是否允许直接执行（非 curl | bash 时也允许，便于本地调试）
can_run_direct() {
    [[ -n "${CURL_EXECUTION:-}" ]] && return 0
    [[ "$(basename "$0")" == "bash" ]] && return 0
    [[ -f "$0" && "$(head -c 2 "$0")" == "#!" ]] && return 0
    return 1
}

# ==================== 业务函数 ====================
show_banner() {
    echo "========================================"
    echo "  Gateway 修复脚本 v${SCRIPT_VERSION}"
    echo "========================================"
    echo "🔧 修复 systemd 用户服务问题"
    echo "⚡ 解决问题: 用户级 systemd 总线、XDG_RUNTIME_DIR、daemon-reload、用户服务持久化"
    echo
}

check_systemd() {
    if ! command -v systemctl &>/dev/null; then
        die "当前系统不是 systemd 架构，本脚本不适用。"
    fi
    log "INFO" "systemd 检查通过"
}

# 仅向 stdout 输出最终用户名，提示信息写 stderr
get_target_user() {
    local current_user
    current_user=$(whoami 2>/dev/null | tr -d '\n\r \t')
    local user="${TARGET_USER:-$current_user}"

    if [[ -n "$TARGET_USER" ]]; then
        echo "ℹ️ 使用指定用户: $user" >&2
    else
        echo "ℹ️ 使用当前用户: $user" >&2
    fi

    user=$(echo "$user" | tr -d '\n\r \t')
    if ! id -u "$user" &>/dev/null; then
        die "用户不存在: $user"
    fi
    echo -n "$user"
}

enable_linger() {
    local target_user="$1"
    echo "🔧 开启用户 linger 持久化..." >&2

    if [[ $EUID -ne 0 ]]; then
        echo "🔑 正在提权到 root..." >&2
        if ! sudo loginctl enable-linger "$target_user" 2>/dev/null; then
            die "提权失败，请手动执行: loginctl enable-linger $target_user"
        fi
        sudo systemctl daemon-reload 2>/dev/null || true
    else
        loginctl enable-linger "$target_user" 2>/dev/null
        systemctl daemon-reload 2>/dev/null || true
    fi
    echo "✅ linger 已开启，systemd 已重载" >&2
}

verify_user_environment() {
    local target_user="$1"
    local target_uid
    target_uid=$(id -u "$target_user")

    echo "🔍 验证用户环境..." >&2
    sudo mkdir -p "/run/user/$target_uid" 2>/dev/null || true
    sudo chmod 700 "/run/user/$target_uid" 2>/dev/null || true
    sudo chown -R "$target_user:$target_user" "/run/user/$target_uid" 2>/dev/null || true

    if ! sudo -iu "$target_user" systemctl --user status &>/dev/null; then
        die "用户级 systemd 总线不通，请检查系统配置。"
    fi
    sudo -iu "$target_user" systemctl --user daemon-reload 2>/dev/null || true
    echo "✅ 用户级 systemd 与 daemon-reload 正常" >&2
    echo "✅ XDG_RUNTIME_DIR: /run/user/$target_uid" >&2
}

try_restart_gateway() {
    local target_user="$1"
    echo "🔄 尝试自动重启 Gateway 服务..." >&2
    if ! sudo -iu "$target_user" command -v openclaw &>/dev/null; then
        echo "ℹ️ 未找到 openclaw，跳过自动重启" >&2
        return 0
    fi
    if sudo -iu "$target_user" openclaw gateway restart 2>/dev/null; then
        sleep 2
        if sudo -iu "$target_user" systemctl --user is-active --quiet gateway 2>/dev/null; then
            echo "✅ Gateway 已重启并运行中" >&2
        else
            echo "⚠️ Gateway 可能仍在启动，请稍后检查" >&2
        fi
    else
        echo "⚠️ 自动重启失败，请手动: sudo -iu $target_user openclaw gateway restart" >&2
    fi
}

show_completion() {
    local target_user="$1"
    echo
    echo "========================================"
    echo "        🎉 Gateway 修复完成！"
    echo "========================================"
    echo
    echo "📋 修复用户: $target_user"
    echo "🔧 内容: systemd 用户服务环境、linger、XDG_RUNTIME_DIR"
    echo
    echo "🚀 建议:"
    echo "   - 重新连接服务器使环境生效"
    echo "   - 重启 Gateway: sudo -iu $target_user systemctl --user restart gateway"
    echo "   - 查看状态:     sudo -iu $target_user systemctl --user status gateway"
    echo "   - 查看日志:     sudo -iu $target_user journalctl --user -u gateway -f"
    echo
    try_restart_gateway "$target_user"
    echo
}

# ==================== 主流程 ====================
main() {
    show_banner
    [[ "$DEBUG" == "1" ]] && log "INFO" "AUTO_ACCEPT=$AUTO_ACCEPT TARGET_USER=$TARGET_USER"

    check_systemd
    target_user=$(get_target_user)

    echo "⚠️ 修复前说明:" >&2
    echo "   • 将开启用户 linger 持久化" >&2
    echo "   • 需要 root（脚本内会 sudo）" >&2
    echo "   • 修复后建议重新连接服务器" >&2
    echo >&2

    confirm "继续执行修复？" || die "已取消"

    enable_linger "$target_user"
    verify_user_environment "$target_user"
    show_completion "$target_user"
}

# ==================== 入口 ====================
case "${1:-}" in
    -h|--help)
        echo "OpenClaw Gateway 修复脚本 v${SCRIPT_VERSION}"
        echo
        echo "用法: curl -fsSL $SCRIPT_URL | bash [选项]"
        echo
        echo "环境变量:"
        echo "  DEBUG=1           调试输出"
        echo "  AUTO_ACCEPT=1     自动确认（默认 1）"
        echo "  TARGET_USER=用户  指定要修复的用户"
        echo
        echo "示例:"
        echo "  curl -fsSL $SCRIPT_URL | bash"
        echo "  TARGET_USER=ubuntu AUTO_ACCEPT=1 curl -fsSL $SCRIPT_URL | bash"
        exit 0
        ;;
esac

if can_run_direct; then
    export CURL_EXECUTION=1
    main "$@"
else
    err "建议通过 curl 执行: curl -fsSL $SCRIPT_URL | bash"
    exit 1
fi
