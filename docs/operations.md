# 部署与运维

本文档说明安装完成后的服务启动、控制台访问、日志与监控。

[← 返回 README](../README.md)

## 启动服务

```bash
# macOS
launchctl start com.openclaw.ai

# Ubuntu
sudo systemctl start openclaw
```

## 访问控制台

```bash
# 启动网关
openclaw gateway

# 建立 SSH 隧道（替换 TAILSCALE_IP）
ssh -L 18789:localhost:18789 $USER@<TAILSCALE_IP>

# 访问 Web 控制台
open http://localhost:18789
```

## Matrix 配对

```bash
# 向 Matrix 机器人发送消息获取配对码
openclaw pairing approve telegram <配对码>
```

## 日志和监控

### 日志文件位置

```bash
# 安装日志
/tmp/openclaw_install_<timestamp>.log

# 服务日志
~/.openclaw/logs/stdout.log    # 标准输出
~/.openclaw/logs/stderr.log    # 错误输出

# 系统日志 (Ubuntu)
journalctl -u openclaw -f
```

### 监控命令

```bash
# 检查服务状态
# macOS
launchctl list | grep openclaw

# Ubuntu
sudo systemctl status openclaw

# 查看实时日志
tail -f ~/.openclaw/logs/stdout.log
```
