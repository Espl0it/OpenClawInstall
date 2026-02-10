# OpenClaw 工具箱集成

## 📖 概述

本项目集成了多个实用工具：
- **qmd** - 本地记忆系统，专为 AI Agent 设计
- **Memos** - 备忘录服务

## ✨ 特性

### qmd 本地记忆系统
- 🔍 **混合搜索**: 关键词 + 语义 + LLM 重排序
- 💰 **零 API 成本**: 完全本地运行
- 🚀 **高性能**: 毫秒级检索响应
- 📊 **高精准度**: 90%+ 相关性
- 🤖 **MCP 集成**: Agent 可自主调用

### Memos 备忘录
- 📝 **快速记录**: 创建和同步备忘录
- 🔄 **内容同步**: 将文件同步到 Memos
- 🌐 **Web UI**: 通过浏览器访问

## 🚀 快速开始

### 安装所有组件

```bash
cd /home/ubuntu/.openclaw/workspace/OpenClawInstall
bash scripts/openclaw_tools.sh all
```

### 单独使用

```bash
# qmd 本地记忆
bash scripts/openclaw_tools.sh qmd install
bash scripts/openclaw_tools.sh qmd search "关键词"

# Memos 备忘录
bash scripts/openclaw_tools.sh memos status
bash scripts/openclaw_tools.sh memos create "内容"
```

## 📖 使用方法

### qmd 命令

```bash
# 安装
bash scripts/openclaw_tools.sh qmd install

# 查看状态
bash scripts/openclaw_tools.sh qmd status

# 搜索（混合搜索，推荐）
bash scripts/openclaw_tools.sh qmd search "关键词"

# 列出集合
bash scripts/openclaw_tools.sh qmd list

# 更新索引
bash scripts/openclaw_tools.sh qmd embed
```

### Memos 命令

```bash
# 检查状态
bash scripts/openclaw_tools.sh memos status

# 查看日志
bash scripts/openclaw_tools.sh memos logs

# 创建备忘录
bash scripts/openclaw_tools.sh memos create "今天的心情很好"

# 同步文件到 Memos
bash scripts/openclaw_tools.sh memos sync /path/to/file.md
```

### 交互模式

```bash
# 进入交互菜单
bash scripts/openclaw_tools.sh
```

## 📁 目录结构

```
OpenClawInstall/
├── scripts/
│   └── openclaw_tools.sh    # 整合工具箱脚本
├── config/
│   └── mcporter.json       # MCP 配置
├── memory/                  # 每日记忆
│   └── *.md
├── *.md                    # 项目文档
└── TOOLS_INTEGRATION.md    # 本文档
```

## ⚙️ 自动更新

### qmd 自动索引更新

系统会自动设置 cron 任务，每天凌晨 3 点自动更新索引：

```bash
# 查看 cron 任务
crontab -l

# 手动更新
bash scripts/openclaw_tools.sh qmd embed
```

## 📊 模型（qmd）

首次运行会自动下载约 **2GB** 模型：

| 模型 | 大小 | 用途 |
|------|------|------|
| embeddinggemma-300M | 328MB | 向量化 |
| qmd-query-expansion-1.7B | 1.28GB | 查询扩展 |
| qwen3-reranker-0.6B | 639MB | 重排序 |

下载后完全离线工作，零 API 成本。

## 🎯 效果预期

### qmd

| 指标 | 传统方式 | qmd |
|------|---------|-----|
| Token 消耗 | 高 | 降低 90%+ |
| 检索精准度 | 低 | 90%+ |
| 响应速度 | 慢 | 快 |
| 成本 | API 费用 | 免费 |

## 🔧 故障排除

### qmd 搜索无结果

```bash
# 检查集合
bash scripts/openclaw_tools.sh qmd status

# 重新生成索引
bash scripts/openclaw_tools.sh qmd embed
```

### Memos 无法连接

```bash
# 检查状态
bash scripts/openclaw_tools.sh memos status

# 查看日志
bash scripts/openclaw_tools.sh memos logs

# 重启容器
docker restart memos
```

## 📝 更新日志

### 2026-02-10
- ✨ 初始集成
- 🔧 整合 qmd + Memos 到统一工具箱
- 📦 支持混合搜索、语义搜索、MCP 集成
- ⏰ 自动更新 cron

## 📚 参考资料

- **qmd GitHub**: https://github.com/tobi/qmd
- **Memos**: https://github.com/usememos/memos
- **X 讨论**: https://x.com/i/status/2017624068997189807

---

**作者**: Alex  
**维护**: Espl0it  
**版本**: 1.0.0
