# 项目工具

本文档介绍仓库内提供的脚本工具用法。

[← 返回 README](../README.md)

## Git 提交工具

项目包含统一的 Git 提交工具，支持完整和快速两种模式：

```bash
# 完整模式（默认）- 创建分支，交互式提交
./git_commit.sh

# 快速模式 - 直接提交当前更改
./git_commit.sh quick

# 自动推送快速模式
./git_commit.sh --auto-push quick

# 无交互提交
AUTO_ACCEPT=1 ./git_commit.sh quick

# 查看帮助
./git_commit.sh --help
```

## 安全安装脚本

集成了完整的安装流程，支持多种配置选项：

```bash
# 查看帮助
curl -fsSL https://raw.githubusercontent.com/zhengweiyu/openclaw/main/openclaw_secure_install.sh | bash --help
```

## Gateway 修复脚本

专门修复 OpenClaw Gateway 服务的 systemd 用户服务问题：

```bash
# 在线修复
curl -fsSL https://raw.githubusercontent.com/zhengweiyu/openclaw/main/gateway_fix.sh | bash

# 自动修复指定用户
TARGET_USER=ubuntu AUTO_ACCEPT=1 curl -fsSL https://raw.githubusercontent.com/zhengweiyu/openclaw/main/gateway_fix.sh | bash

# 查看帮助
curl -fsSL https://raw.githubusercontent.com/zhengweiyu/openclaw/main/gateway_fix.sh | bash --help
```

更多 Gateway 相关问题与手动验证命令见 [故障排除 - Gateway 服务修复](troubleshooting.md#6-gateway-服务修复)。
