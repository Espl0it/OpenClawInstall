# 贡献指南

欢迎参与 OpenClaw 项目，本文档说明开发环境与提交流程。

[← 返回 README](../README.md)

## 开发环境

```bash
# 克隆仓库
git clone https://github.com/Espl0it/OpenClawInstall.git
cd openclaw

# 检查脚本语法
bash -n install.sh
bash -n gateway_fix.sh

# 运行测试
bats tests/
```

## 代码规范

- 遵循 [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- 使用严格模式 `set -euo pipefail`
- 所有变量使用 readonly 声明
- 函数名使用下划线命名
- 提供完整的错误处理和日志记录

## 提交流程

1. Fork 项目仓库
2. 创建功能分支
3. 编写测试用例
4. 提交 Pull Request
5. 等待代码审查
