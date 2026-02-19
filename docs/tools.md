# 项目工具

本文档介绍仓库内提供的脚本工具用法。

[← 返回 README](../README.md)

## install.sh - 主安装脚本

### 基本用法

```bash
# 标准安装
curl -fsSL https://raw.githubusercontent.com/Espl0it/OpenClawInstall/main/install.sh | bash

# Docker 模式
curl -fsSL https://raw.githubusercontent.com/Espl0it/OpenClawInstall/main/install.sh | bash -s -- --mode docker

# 查看帮助
curl -fsSL https://raw.githubusercontent.com/Espl0it/OpenClawInstall/main/install.sh | bash -s -- --help
```

### 常用选项

| 选项 | 说明 |
|------|------|
| `-h, --help` | 显示帮助 |
| `-v, --verbose` | 详细输出 |
| `-n, --dry-run` | 模拟运行 |
| `--mode MODE` | 安装模式 (native/docker) |
| `--config FILE` || `--uninstall 配置文件路径 |
` | 卸载 OpenClaw |

### 环境变量

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `DEBUG` | 0 | 调试模式 |
| `VERBOSE` | 0 | 详细输出 |
| `DRY_RUN` | 0 | 模拟运行 |
| `AUTO_ACCEPT` | 0 | 自动确认 |
| `LLM_PROVIDER` | minimax | LLM 提供商 |
| `SKIP_TAILSCALE` | 0 | 跳过 Tailscale |
| `INSTALL_MODE` | native | 安装模式 |

### 配置文件示例

```bash
# 创建配置文件
cat > ~/.openclaw/install.conf << 'EOF'
LLM_PROVIDER=minimax
AUTO_ACCEPT=1
SKIP_TAILSCALE=1
VERBOSE=1
EOF

# 使用配置安装
curl -fsSL https://raw.githubusercontent.com/Espl0it/OpenClawInstall/main/install.sh | bash -s -- --config ~/.openclaw/install.conf
```

## git_commit.sh - Git 提交工具

```bash
# 完整模式（默认）- 创建分支，交互式提交
./git_commit.sh

# 快速模式 - 直接提交
./git_commit.sh quick

# 自动推送
./git_commit.sh --auto-push quick

# 无交互
AUTO_ACCEPT=1 ./git_commit.sh quick

# 帮助
./git_commit.sh --help
```

## gateway_fix.sh - Gateway 修复脚本

```bash
# 在线修复
curl -fsSL https://raw.githubusercontent.com/Espl0it/OpenClawInstall/main/gateway_fix.sh | bash

# 自动修复
TARGET_USER=ubuntu AUTO_ACCEPT=1 curl -fsSL https://raw.githubusercontent.com/Espl0it/OpenClawInstall/main/gateway_fix.sh | bash

# 帮助
curl -fsSL https://raw.githubusercontent.com/Espl0it/OpenClawInstall/main/gateway_fix.sh | bash --help
```

## OpenClaw 内置命令

安装完成后可使用以下命令：

```bash
openclaw gateway start   # 启动网关
openclaw gateway stop    # 停止网关
openclaw status          # 查看状态
openclaw onboard         # 初始化配置
openclaw doctor          # 健康检查
openclaw token           # 获取 Token
```

详见 [故障排除](./troubleshooting.md)
