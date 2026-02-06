# 安装指南

本文档说明 OpenClaw 的系统要求、安装方式与安装流程。

[← 返回 README](../README.md)

## 🚀 安全安装（推荐）

### 基础安装

```bash
curl -fsSL https://raw.githubusercontent.com/zhengweiyu/openclaw/main/openclaw_secure_install.sh | bash
```

### 高级安装选项

```bash
# 自动安装（无交互）
AUTO_ACCEPT=1 curl -fsSL https://raw.githubusercontent.com/zhengweiyu/openclaw/main/openclaw_secure_install.sh | bash

# 选择LLM提供商
LLM_PROVIDER=claude curl -fsSL https://raw.githubusercontent.com/zhengweiyu/openclaw/main/openclaw_secure_install.sh | bash

# 调试模式
DEBUG=1 curl -fsSL https://raw.githubusercontent.com/zhengweiyu/openclaw/main/openclaw_secure_install.sh | bash

# 跳过Tailscale安装
SKIP_TAILSCALE=1 curl -fsSL https://raw.githubusercontent.com/zhengweiyu/openclaw/main/openclaw_secure_install.sh | bash

# 组合选项
AUTO_ACCEPT=1 LLM_PROVIDER=minimax DEBUG=1 curl -fsSL https://raw.githubusercontent.com/zhengweiyu/openclaw/main/openclaw_secure_install.sh | bash
```

### 支持的 LLM 提供商

| 提供商 | 命令 | 优势 |
|--------|------|------|
| **MiniMax** (默认) | `LLM_PROVIDER=minimax` | 性价比高，中文支持优秀 |
| **Claude** | `LLM_PROVIDER=claude` | 推理能力强，安全性高 |
| **GPT** | `LLM_PROVIDER=gpt` | 生态完善，功能丰富 |

### 本地安装

```bash
# 克隆仓库
git clone https://github.com/zhengweiyu/openclaw.git
cd openclaw
chmod +x openclaw_secure_install.sh

# 运行安装脚本
./openclaw_secure_install.sh
```

## 📋 系统要求

### 支持的操作系统

- **macOS**: 10.15+ (Catalina 及以上版本)
- **Ubuntu**: 20.04 LTS 及以上版本

### 前置条件

#### 基础要求

1. **网络连接**: 稳定的互联网连接用于下载依赖
2. **磁盘空间**: 至少 2GB 可用空间
3. **管理员权限**: 用于安装系统服务和配置防火墙

#### LLM 提供商账户（选择其一）

| 提供商 | 注册地址 | 需要准备 | 适用场景 |
|--------|----------|----------|----------|
| **MiniMax** (默认) | https://api.minimax.chat/ | Group ID + API Key | 个人开发者，中小企业 |
| **Claude** | https://console.anthropic.com/ | API Key | 企业用户，注重安全 |
| **GPT** | https://platform.openai.com/ | API Key | 技术团队，集成开发 |

## 📦 安装流程

### 安装步骤概览

1. **系统检测** - 检测操作系统版本和配置
2. **依赖安装** - 安装 curl、wget、git 等基础工具
3. **网络安全** - 安装和配置 Tailscale（可选）
4. **Node.js** - 安装 Node.js 24 运行环境
5. **OpenClaw** - 安装 OpenClaw CLI 工具
6. **初始化** - 配置 LLM 提供商
7. **插件安装** - 安装 Matrix 插件和安全组件
8. **服务配置** - 创建系统服务，支持开机自启动
9. **安全加固** - 设置文件权限和防护机制

### 环境变量配置

| 变量名 | 默认值 | 说明 |
|--------|--------|------|
| `DEBUG` | 0 | 启用调试模式，显示详细日志 |
| `AUTO_ACCEPT` | 0 | 自动确认所有提示，无需用户交互 |
| `SKIP_TAILSCALE` | 0 | 跳过 Tailscale 安装和配置 |
| `LLM_PROVIDER` | minimax | LLM 提供商：minimax / claude / gpt |
