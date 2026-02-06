# 维护与更新

本文档说明日常维护、备份与 API 密钥轮换。

[← 返回 README](../README.md)

## 定期维护

```bash
# 更新系统包
# Ubuntu
sudo apt update && sudo apt upgrade -y

# macOS
brew update && brew upgrade

# 更新 OpenClaw
openclaw update

# 安全审计
openclaw security audit --deep
```

## 备份策略

```bash
# 备份配置目录
tar -czf openclaw_backup_$(date +%Y%m%d).tar.gz ~/.openclaw

# 加密备份
gpg -c openclaw_backup_$(date +%Y%m%d).tar.gz
```

## API 密钥轮换

```bash
# 重新配置 API 密钥
openclaw config set minimax.api_key <new_key>

# 重新配置 Group ID
openclaw config set minimax.group_id <new_group_id>
```
