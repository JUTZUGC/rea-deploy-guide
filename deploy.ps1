# REA 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://rea.tools/get-started/
# 更新日期：2026-10-28
# 类型：script
$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw '需要先安装 Git' }
if (-not (Get-Command node -ErrorAction SilentlyContinue)) { throw '需要先安装 Node.js' }

New-Item -ItemType Directory -Force -Path .download | Out-Null
Set-Location -Path .download

node -e "const [a,b,c]=process.versions.node.split('.').map(Number);const ok=(a===22&&b>=23)||(a===24&&b>=22)||(a===26&&(b>12||(b===12&&c>=1)))||a>26;if(!ok){console.error('REA 需要 Node 22.23.4+ / 24.22.1+ / 26.12.1+，当前 '+process.versions.node);process.exit(1)}" ; if ($LASTEXITCODE -ne 0) { throw 'Node 版本不满足 REA 要求（22.23.4+ / 24.22.1+ / 26.12.1+）' }
npm install --global rea-agents
rea --help

Write-Host ''

Write-Host '安装完成：运行 rea --help 查看命令；要在 Agent 里用，注册 MCP 命令 npx -y rea-agents@6.8.0 mcp'
Write-Host '若结果异常或需要改配置，请参考官方文档：https://rea.tools/get-started/'
