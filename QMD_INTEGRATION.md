# qmd 本地记忆系统集成

## 📖 概述

本项目集成了 **qmd** - 一个专为 AI Agent 设计的本地语义搜索引擎，用于实现精准的记忆检索，大幅降低 Token 消耗（预计节省 90%+）。

> 参考: [Ray Wang X 分享](https://x.com/i/status/2017624068997189807)

## ✨ 特性

- 🔍 **混合搜索**: 关键词 + 语义 + LLM 重排序
- 💰 **零 API 成本**: 完全本地运行
- 🚀 **高性能**: 毫秒级检索响应
- 📊 **高精准度**: 90%+ 相关性
- 🤖 **MCP 集成**: Agent 可自主调用

## 🚀 快速开始

### 方式一：一键安装

```bash
cd /home/ubuntu/.openclaw/workspace/OpenClawInstall
bash scripts/install_qmd.sh
```

### 方式二：手动安装

```bash
# 1. 安装 bun (如果没有)
curl -fsSL https://bun.sh/install | bash

# 2. 安装 qmd
bun install -g https://github.com/tobi/qmd

# 3. 创建记忆库
cd /home/ubuntu/.openclaw/workspace
qmd collection add memory/*.md --name daily-logs
qmd collection add *.md --name workspace

# 4. 生成 Embedding
qmd embed

# 5. 配置 MCP
mkdir -p config
# 编辑 config/mcporter.json...
```

## 📖 使用方法

### 命令行搜索

```bash
# 混合搜索（推荐）
qmd search daily-logs "关键词" --hybrid

# 语义搜索
qmd search daily-logs "关键词"

# 查看集合
qmd list

# 查看状态
qmd status

# 更新索引
qmd embed
```

### MCP 工具

配置 `config/mcporter.json` 后，Agent 可使用以下工具：

| 工具 | 功能 |
|------|------|
| `query` | 混合搜索（最推荐） |
| `vsearch` | 纯语义检索 |
| `search` | 关键词检索 |
| `get` | 获取文档片段 |
| `status` | 健康检查 |

## 📁 目录结构

```
OpenClawInstall/
├── config/
│   └── mcporter.json       # MCP 配置
├── scripts/
│   └── install_qmd.sh      # 一键安装脚本
├── memory/                  # 每日记忆
│   └── *.md
├── *.md                    # 项目文档
└── QMD_INTEGRATION.md      # 本文档
```

## ⚙️ 自动更新

系统会自动设置 cron 任务，每天凌晨 3 点自动更新索引：

```bash
# 查看 cron 任务
crontab -l

# 手动更新
qmd embed
```

## 📊 模型

首次运行会自动下载约 **2GB** 模型：

| 模型 | 大小 | 用途 |
|------|------|------|
| embeddinggemma-300M | 328MB | 向量化 |
| qmd-query-expansion-1.7B | 1.28GB | 查询扩展 |
| qwen3-reranker-0.6B | 639MB | 重排序 |

下载后完全离线工作，零 API 成本。

## 🎯 效果预期

| 指标 | 传统方式 | qmd |
|------|---------|-----|
| Token 消耗 | 高 | 降低 90%+ |
| 检索精准度 | 低 | 90%+ |
| 响应速度 | 慢 | 快 |
| 成本 | API 费用 | 免费 |

## 🔧 故障排除

### 搜索无结果

```bash
# 检查集合
qmd list

# 检查状态
qmd status

# 重新生成索引
qmd embed
```

### 模型下载失败

```bash
# 手动下载
# 模型保存在 ~/.cache/qmd/models/

# 检查网络
curl -I https://huggingface.co
```

### MCP 无法连接

```bash
# 测试 qmd 命令
qmd status

# 检查配置
cat config/mcporter.json
```

## 📝 更新日志

### 2026-02-10
- ✨ 初始集成
- 📦 支持混合搜索
- 🤖 MCP 集成
- ⏰ 自动更新 cron

## 📚 参考资料

- **原文**: https://mp.weixin.qq.com/s/_TPEdjCJOzFt9M5JHMAAug
- **GitHub**: https://github.com/tobi/qmd
- **X 讨论**: https://x.com/i/status/2017624068997189807

---

**作者**: Alex  
**维护**: Espl0it  
**版本**: 1.0.0
