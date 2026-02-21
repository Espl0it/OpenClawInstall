# 故障排除

本文档汇总常见问题与解决方案，以及重新安装步骤。

[← 返回 README](../README.md)

## 常见问题

### 1. Tailscale 授权失败

```bash
# 手动完成授权
sudo tailscale up
# 浏览器会自动打开授权页面
```

### 2. OpenClaw 命令未找到

```bash
# 检查 PATH
echo $PATH | grep openclaw

# 手动添加到 PATH
export PATH="$HOME/.npm-global/bin:$PATH"
```

### 3. 服务启动失败

```bash
# 查看详细错误信息
# macOS
launchctl print com.openclaw.ai

# Ubuntu
journalctl -u openclaw --no-pager
```

### 4. 权限问题

```bash
# 修复权限
chmod 700 ~/.openclaw
chmod 600 ~/.openclaw/*.json
```

### 5. 网络连接问题

```bash
# 检查网络连接
curl -I https://api.minimax.chat

# 使用代理（如果需要）
export https_proxy=http://proxy.company.com:8080
export http_proxy=http://proxy.company.com:8080
```

### 6. Gateway 服务修复

如果 OpenClaw Gateway 服务出现用户级 systemd 相关问题，可以使用专门的修复脚本：

```bash
# 在线修复（推荐）
curl -fsSL https://raw.githubusercontent.com/Espl0it/OpenClawInstall/main/gateway_fix.sh | bash

# 自动修复指定用户
TARGET_USER=ubuntu AUTO_ACCEPT=1 curl -fsSL https://raw.githubusercontent.com/Espl0it/OpenClawInstall/main/gateway_fix.sh | bash

# 调试模式修复
DEBUG=1 curl -fsSL https://raw.githubusercontent.com/Espl0it/OpenClawInstall/main/gateway_fix.sh | bash
```

**修复脚本解决的问题：**

- 用户级 systemd 总线不通
- XDG_RUNTIME_DIR 缺失
- daemon-reload 执行失败
- 用户服务持久化问题
- 自动重启 Gateway 服务

**修复后的自动操作：**

脚本修复完成后会自动：

- 尝试重启 Gateway 服务
- 检查服务运行状态
- 显示端口信息
- 确认服务正常运行

**手动验证命令：**

```bash
# 验证 linger 状态
sudo loginctl show-user <用户名> | grep Linger

# 重启 Gateway 服务
sudo -iu <用户名> systemctl --user restart gateway

# 查看服务日志
sudo -iu <用户名> journalctl --user -u gateway -f

# 查看用户服务状态
sudo -iu <用户名> systemctl --user status
```

## 重新安装

```bash
# 完全卸载
sudo systemctl stop openclaw 2>/dev/null || true
sudo systemctl disable openclaw 2>/dev/null || true
sudo rm -f /etc/systemd/system/openclaw.service
sudo systemctl daemon-reload 2>/dev/null || true

launchctl unload ~/Library/LaunchAgents/com.openclaw.ai.plist 2>/dev/null || true
rm -f ~/Library/LaunchAgents/com.openclaw.ai.plist

rm -rf ~/.openclaw
npm uninstall -g @openclaw/cli 2>/dev/null || true

# 重新安装
curl -fsSL https://raw.githubusercontent.com/Espl0it/OpenClawInstall/main/install.sh | bash
```

> 说明：原文档中的 `online_install.sh` 已改为使用 `install.sh` 以与当前仓库一致。

---

## Docker 模式问题

### 1. 进入 Docker 容器

```bash
# 查看运行中的容器
docker compose ps

# 进入容器 (交互式)
docker compose exec -it openclaw /bin/bash

# 如果是手动创建的容器
docker exec -it <container_id> /bin/bash
```

### 2. OpenClaw 命令未找到

在 Docker 容器中，OpenClaw 通过 `npx` 运行，不是全局命令：

```bash
# 方式1: 使用 npx
npx openclaw status

# 方式2: 进入项目目录
cd /home/node/.openclaw
npx openclaw status

# 方式3: 查看帮助
npx openclaw --help

# 方式4: 全局安装 (可选)
npm install -g openclaw
openclaw status
```

### 3. 容器内常用命令

| 命令 | 说明 |
|------|------|
| `npx openclaw status` | 查看状态 |
| `npx openclaw gateway start` | 启动 Gateway |
| `npx openclaw gateway stop` | 停止 Gateway |
| `npx openclaw gateway status` | 查看运行状态 |
| `docker compose logs -f` | 查看日志 |
| `docker compose restart` | 重启容器 |

### 4. 常见 Docker 错误

```bash
# 容器未运行
docker compose up -d

# 查看日志
docker compose logs -f

# 重新构建
docker compose build --no-cache

# 删除并重新创建
docker compose down
docker compose up -d
```
