#!/usr/bin/env bash
set -euo pipefail
# REA 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://rea.tools/get-started/
# 更新日期：2026-10-25
# 类型：script
cd "$(dirname "${BASH_SOURCE[0]}")"

command -v git >/dev/null 2>&1 || { echo "需要先安装 Git"; exit 1; }
command -v node >/dev/null 2>&1 || { echo "需要先安装 Node.js"; exit 1; }

mkdir -p .download
cd .download

node -e "const [a,b,c]=process.versions.node.split('.').map(Number);const ok=(a===22&&b>=23)||(a===24&&b>=22)||(a===26&&(b>12||(b===12&&c>=1)))||a>26;if(!ok){console.error('REA 需要 Node 22.23.4+ / 24.22.1+ / 26.12.1+，当前 '+process.versions.node);process.exit(1)}"
npm install --global rea-agents
rea --help

echo ""

echo "安装完成：运行 rea --help 查看命令；要在 Agent 里用，注册 MCP 命令 npx -y rea-agents@6.8.0 mcp"
echo "若结果异常或需要改配置，请参考官方文档：https://rea.tools/get-started/"
