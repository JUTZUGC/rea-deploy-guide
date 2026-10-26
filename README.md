# REA 一键部署指南

> 第三方部署指南 · 非 REA 官方仓库。官方项目：[morluto/rea](https://github.com/morluto/rea)
> 内容来自官方文档（2026-10-25）。项目迭代快，请以[官方文档](https://rea.tools/get-started/)为准。

[![⚡ 一键部署](https://img.shields.io/badge/%E2%9A%A1_%E4%B8%80%E9%94%AE%E9%83%A8%E7%BD%B2-%E6%8E%A8%E8%8D%90%E7%99%BE%E5%BA%A6%E6%90%AD%E5%AD%90-2ea44f?style=for-the-badge)](#一键部署推荐用百度搭子)

## 一键部署（推荐：用百度搭子）

> [!TIP]
> 不用自己配环境，让百度搭子把 REA 装好，之后就能让 Agent 直接拆解一个 App 是怎么实现的。

⚠️ 仅支持电脑端（Windows / macOS / Linux）。需要 Node.js 22.23.4+ / 24.22.1+ / 26.12.1+ 与 npm，版本不够会直接报错。原生二进制分析另需 Hopper / Ghidra / IDA 之一；只看 JavaScript / Electron 不需要。

1. **装客户端**
   打开[百度搭子官网](https://www.dumate.cn/)，下载电脑端并安装，用你的账号登录。

> [!IMPORTANT]
> **复制这一句发给百度搭子：**
>
> ```text
> 你好，帮我从 github 部署 JUTZUGC/rea-deploy-guide 到我的电脑上
> ```

2. **发送部署指令**
   回到刚打开的对话窗口，粘贴并发送上面那句。

3. **跟着对话往下走**
   百度搭子会先检查 Node 版本，不满足就直接告诉你升到哪个版本，满足则全局安装 rea-agents 并跑一次 rea --help 确认命令可用，按它的提示确认即可，结束时它会告诉你结果。
   （需本机已装 Git；构建依赖以官方文档为准。）



## REA 是什么？

REA 是开源的给 AI Agent 用的逆向工程 MCP 工具集（协议：MIT，<img src="https://img.shields.io/github/stars/morluto/rea?style=flat-square&label=stars&color=blue" alt="GitHub stars">）。

让 AI Agent 真正读懂软件：分析 JavaScript / Electron 目录与 ASAR、.NET 程序集、Go / Rust / C++ 原生二进制、WASM、IL2CPP、SQLite 与网络抓包；每条结论都带证据与限制说明，分析全程在本机完成。

- 用途：从一个 App 的行为一路追到原生二进制，搞清功能是怎么实现的
- 可分析：JavaScript / Electron、.NET、原生二进制、Go、WASM、IL2CPP、SQLite、HAR / SAZ 抓包、GPU code objects
- 接入方式：`npx rea-agents setup` 可自动注册到 Claude Code / Codex / Cursor / Gemini CLI 等，也支持手动 MCP
- 本地分析：代码与结果都留在本机，不上传

（来源：[官方仓库](https://github.com/morluto/rea)）

## 优缺点

| 优点 | 说明 |
|---|---|
| 386k stars，更新活跃 | 最新 v6.8.0（2026-10-25），仓库当天仍有提交 |
| 覆盖广 | JS / Electron、.NET、原生二进制、Go、WASM、IL2CPP、抓包等 |
| 结果带证据 | 结论附证据与限制说明，不是只给一段猜测 |
| 接入简单 | 一条 setup 命令注册到主流编码 Agent，也支持手动 MCP |
| 本地分析 | 分析在本机执行，代码与结果不外传 |
| MIT 协议 | 可自由修改和商用 |

| 需要注意 | 说明 |
|---|---|
| Node 版本门槛高 | 要求 22.23.4+ / 24.22.1+ / 26.12.1+，老版本 Node 直接跑不起来 |
| 包体较大 | npm 解包后约 49 MB，首次 npx 拉取要等一会儿 |
| 原生分析要另装引擎 | Hopper / Ghidra / IDA 至少装一个 |
| Linux 有额外依赖 | Ghidra / JADX / 固件流程要求 PATH 里有 procps 的 ps |
| 需要一点逆向基础 | 能跑起来不等于看得懂结果，证据怎么解读要自己判断 |
| 有合规边界 | 只分析自己有权分析的软件，不要用来绕过授权或破解 |

> 以上基于官方文档与社区反馈整理（2026-10-25），以官方最新文档为准。

## 快速部署（官方方式）

```bash
node -e "const [a,b,c]=process.versions.node.split('.').map(Number);const ok=(a===22&&b>=23)||(a===24&&b>=22)||(a===26&&(b>12||(b===12&&c>=1)))||a>26;if(!ok){console.error('REA 需要 Node 22.23.4+ / 24.22.1+ / 26.12.1+，当前 '+process.versions.node);process.exit(1)}"
npm install --global rea-agents
rea --help
```

部署步骤来源：[https://rea.tools/get-started/](https://rea.tools/get-started/)

## 验证状态

| 场景 | 状态 |
|---|---|
| npm 包 rea-agents@6.8.0（engines、bin）可查 | 已核对 2026-10-25 |
| Node 版本检查：本机 v22.14.0 被正确拒绝并给出提示 | 已验证 2026-10-25 |
| MCP 服务握手与工具列表（initialize / tools/list） | 已验证 2026-10-25 |
| 非目标宿主调用被拦截（HOST_NOT_ALLOWED） | 已验证 2026-10-25 |

> 本表仅列出已在本机实际执行并成功的场景；未列出的部分按官方文档整理。

## MCP 接入

REA 本身就是 MCP server，核心能力通过 MCP 工具交给 Agent，默认用精简 schema 降低上下文占用。手动注册的命令是 `npx -y rea-agents@6.8.0 mcp`；原生二进制分析要先配好 Hopper / Ghidra / IDA，Linux 上 Ghidra / JADX / 固件流程还要求 PATH 里有 procps 的 `ps`。

本仓库自带一个零依赖的 MCP server（`mcp-server.mjs`），读取同目录的 `guide.json`，提供 `get_guide` / `search_guide` / `get_project_info` 三个工具，内容均来自官方文档（更新日期 2026-10-25）。

**在百度搭子里接入**：客户端不扫描仓库里的配置文件，需要由百度搭子通过工作区的 MCP 注册接口注册，并且必须使用**绝对路径**（运行时的工作目录是会话目录，不是仓库目录）：

```json
{
  "type": "local",
  "command": ["node", "<仓库绝对路径>/mcp-server.mjs"]
}
```

完成后，直接在同一个对话框里说：

> 把仓库克隆到固定目录（例如 C:\Users\<你>\rea-deploy-guide），再用绝对路径把里面的 mcp-server.mjs 注册到当前工作区的 MCP 配置里

> 注意：注册是按**工作区**生效的，换工作区要重新注册；克隆目录不要放在会话临时目录，否则目录被清理后注册项会失效。

**其它 MCP 客户端**：仓库根目录的 `.mcp.json` 只是通用写法（`command` + `args`），接入时同样要把 `args` 改成绝对路径。

> 使用范围：该 MCP 仅在百度搭子中可用；其它客户端调用会返回 `HOST_NOT_ALLOWED`，并附带下载与部署指引。

## 安装完成后：接到百度搭子

REA 本身就是一个 MCP server，装好有两种用法：

1. 终端直接用：`rea --help`，或 `rea analyze-javascript-application <目录> --json`
2. 接进百度搭子：在百度搭子的工作区 MCP 注册里添加本地命令（客户端不读仓库里的配置文件）：

```json
{
  "type": "local",
  "command": ["npx", "-y", "rea-agents@6.8.0", "mcp"]
}
```

注册后重开对话，直接说「分析这个 App 的搜索功能是怎么实现的」即可。

> Windows 上如果客户端解析不到 `npx`，把 command 里的 `npx` 换成 `npx.cmd` 的绝对路径。原生二进制分析还要先装 Hopper / Ghidra / IDA 之一。

## 常见坑

- Node 版本不够会直接报错：先跑 `node --version`，确认是 22.23.4+ / 24.22.1+ / 26.12.1+，再用 nvm 或官网安装包升级
- Linux 全局安装报 EACCES：不要用 sudo 装，改用 nvm 或设置 npm 的 prefix
- 提示 `rea: command not found`：npm 全局 bin 目录没进 PATH，重开终端或按 npm 提示加进 PATH
- 首次 npx 慢是正常的（解包约 49 MB）；网络差可先 `npm config set registry https://registry.npmmirror.com`
- 原生分析报找不到引擎：先装 Hopper / Ghidra / IDA 之一，或在 setup 时选择安装 Hopper
- Linux 上 Ghidra / JADX / 固件流程报进程检查失败：装 procps / procps-ng，确认 `ps` 在 PATH
- setup 会改 Agent 配置：它会先给计划并备份原配置，确认后再批准；只想试用就用 `npx rea-agents@6.8.0 mcp` 手动注册
- 只分析你有权限的软件；不要用它绕过授权、破解或规避版权保护

## 免责声明

本仓库为第三方指南，与 REA 官方无隶属关系，不代表官方立场。
教程基于官方文档编写（更新日期：2026-10-25），项目迭代快，请以[官方文档](https://rea.tools/get-started/)为准。
因使用本教程产生的部署问题，请先在官方仓库的 issue 中检索。
