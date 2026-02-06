# 支持与帮助

本文档提供官方资源、获取帮助方式与版本历史。

[← 返回 README](../README.md)

## 许可证

本项目采用 MIT 许可证，详见仓库根目录 [LICENSE](../LICENSE) 文件。

## 官方资源

- **文档**: https://openclaw.ai/docs
- **社区**: https://community.openclaw.ai
- **GitHub**: https://github.com/zhengweiyu/openclaw

## 获取帮助

```bash
# 安装脚本帮助
curl -fsSL https://raw.githubusercontent.com/zhengweiyu/openclaw/main/openclaw_secure_install.sh | bash --help

# Gateway 修复脚本帮助
curl -fsSL https://raw.githubusercontent.com/zhengweiyu/openclaw/main/gateway_fix.sh | bash --help

# Git 提交脚本帮助
./git_commit.sh --help

# OpenClaw 命令帮助
openclaw --help

# 获取支持
openclaw support
```

## 报告问题

如遇到问题，可通过以下方式反馈：

1. [GitHub Issues](https://github.com/zhengweiyu/openclaw/issues)
2. 社区论坛
3. 支持邮件: zhengweiyu@gmail.com

## 版本历史

### v2.0（当前版本）

- 新增在线一键安装功能
- 多 LLM 提供商支持（MiniMax / Claude / GPT）
- 重构脚本架构，提高可维护性
- 增强安全加固措施
- 完善日志和错误处理
- 优化跨平台兼容性
- 添加详细文档和部署指南

### v1.0

- 初始版本发布
- 基础 macOS 和 Ubuntu 支持
- 核心安全功能
