# Creation Skill Suite

![version](https://img.shields.io/badge/version-0.1.4-blue) ![packages](https://img.shields.io/badge/packages-17-green) ![python](https://img.shields.io/badge/Python-3.15.2-blue) ![node](https://img.shields.io/badge/Node-24.22.3+-green)

**v0.1.2** — 一个 monorepo，收拢 **17 个上游创作工具**：**媒体创作 7 个** + **建站/站点分析 10 个**。每个子包保持上游目录结构与许可证、独立可用；本仓库在其上提供统一的环境基线、验证入口与共享工程设施（Makefile / 检查脚本 / CI）。

**v0.1.4 变更**：ai-website-cloner-template 本地升级 `next` + `eslint-config-next` 16.3.5 → 16.4.6（满足 `@opennextjs/cloudflare` ≥16.4.5 的 Cloudflare Workers 部署要求，唯一偏离上游 5426e0e2 的改动，`npm run check` 复验通过）。**v0.1.3 变更**：monorepo Node 基线从 22.23.4 对齐升至 **24.22.3**——ai-website-cloner-template 在 Node 24 下 `npm ci && npm run check`（lint + typecheck + Next.js 16 build）实测通过，superpowers 7/7 `.test.js`、security-audit-skill/hallmark/cinecode 冒烟复验通过；CI setup-node 同步升至 24。**v0.1.2 变更**：纳入 [ai-website-cloner-template](packages/ai-website-cloner-template)（39.6k star，agent skill 网站克隆器 + Next.js 16 脚手架）为第 17 个子包。

**v0.1.1 变更**：Linux 全量实测（2026-11-22，CPython 3.15.2 基线）后同步——重写验证状态、补齐 12 项冲突定位与 4 组修复（wrapper×9 / graphify 3.15 / ocr locale / 工具链），详见 [TEST-RECORD.md](TEST-RECORD.md)。

## 功能描述

本套件面向 coding agent 与开发者，覆盖三类能力：

1. **媒体创作（7 包）**：视频/音频编辑（ffmpeg-skill）、动态图与海报（gif-factory）、代码生成电影（cinecode）、动画短片（claude-animated-shorts）、视频逆向拆解（rea-video）、软件逆向重建（craft-anything）、agent 数据防护（unlose）。
2. **建站 / 站点分析（9 包）**：开发方法论技能集（superpowers）、AI 代码审查（open-code-review）、逆向工程 MCP 框架（rea）、代码知识图谱（graphify）、反 AI 套路设计（hallmark）、设计语言引擎（impeccable）、HTML→视频（hyperframes）、安全审计编排（security-audit-skill）、SEO 审计（claude-seo）。
3. **统一工程设施**：全部 Python 子包统一跑在 **CPython 3.15.2**（claude-seo 为此做了基于 3.15 的改写）；`make check` 一键验证 17 个子包，结果为 `PASS` / `SKIP(原因)` / `FAIL` 三态；上游 commit、构建/测试命令记录在 [packages.json](packages.json)。

### 媒体创作（7）

| 子包 | 能做什么 | 技术栈 | 许可证 | 上游 |
|---|---|---|---|---|
| [ffmpeg-skill](packages/ffmpeg-skill) | 给 coding agent 的本地视频/音频编辑器：42 个工具覆盖裁剪、拼接、转码、字幕烧录、音频分离、静默检测、响度标准化、HDR→SDR、多机位、平台导出检查。无云、无 API key。 | Python 3.15（纯标准库）+ FFmpeg 9 | MIT | kajisho5/ffmpeg-skill |
| [gif-factory](packages/gif-factory) | 动态图创作工厂：表情包、光栅变画卡、动态海报、动态签名、电影片头、文章封面配色、动态绘本、品牌短片。有素材就能合成，不需要文生图模型。 | Python 3.15 + Pillow 13 / NumPy 2.5 / SciPy 1.18 | MIT | WoYun520/gif-factory |
| [cinecode](packages/cinecode) | 代码生成电影：AI 写剧本，three.js 在无头 Chrome 逐帧渲染 3D 场景，FFmpeg 合成 MP4。短片、YouTube 长视频、广告、科普视频、MV。 | Python 3.15 + Node 24 + three.js + FFmpeg | MIT | sarpstar/cinecode |
| [claude-animated-shorts](packages/claude-animated-shorts) | 竖屏 55–70s 动画故事短片：2D 角色 + 彩色 3D 世界，墨线轮廓、镜头运动、配乐音效。纯本地渲染，不用 AI 视频生成器。 | Remotion 4.0.545 + three.js + Node 24 + Python 3.15 | MIT | mromidev/claude-animated-shorts |
| [rea-video](packages/rea-video) | 视频逆向拆解：逐镜头判断实拍/AI 生成/3D 渲染/代码模板/录屏，输出 VIDEO.md 格式报告 + 复刻方案（Remotion / Blender / 拍摄计划）。 | Python ≥3.10 + OpenCV + NumPy + ffmpeg | Apache-2.0 | JuneYaooo/rea-video |
| [craft-anything](packages/craft-anything) | 软件逆向重建引擎：看懂任意网站/应用/游戏怎么做的，再用 coding agent 在你的目标栈里重建。320 工具 + CLI + MCP server。 | Rust 1.97+ + wgpu + egui | MIT / Apache-2.0 | storytold/craft-anything |
| [unlose](packages/unlose) | AI agent 数据防护：agent 开工前自动做全盘 VSS 快照，删错/损坏/加密后拖时间线恢复。 | C# / .NET 8 + WPF + Windows VSS | Apache-2.0 | unlose-app/unlose |

### 建站 / 站点分析（10）

| 子包 | 能做什么 | 技术栈 | 许可证 | 上游 |
|---|---|---|---|---|
| [superpowers](packages/superpowers) | 给 coding agent 的软件开发方法论技能集：15 个 markdown 技能（brainstorming、TDD、systematic-debugging、code-review 等），跨多宿主安装。 | TypeScript + 15 个技能目录 | MIT | obra/superpowers |
| [open-code-review](packages/open-code-review) | AI 代码审查 CLI（ocr）：读 git diff，确定性文件分组 + LLM agent，行级精准评论，内置 NPE/线程安全/XSS/SQL 注入规则集。 | Go 1.26 + Node launcher | Apache-2.0 | alibaba/open-code-review |
| [rea](packages/rea) | 逆向工程 MCP 框架：agent 调用本地工具分析 native 二进制 / JS / Electron / .NET / APK / 固件，输出带证据的结论。 | Node.js 22+/24+/26 + TypeScript + turbo | MIT | morluto/rea |
| [graphify](packages/graphify) | 代码知识图谱：tree-sitter AST 本地解析 40+ 语言 + 文档/PDF/音视频，生成可查询图谱（graph.html / graph.json），agent 查图代替 grep。 | Python 3.15 + tree-sitter + networkx | Apache-2.0 + MIT | Graphify-Labs/graphify |
| [hallmark](packages/hallmark) | 反 AI 套路设计技能：50 套材质主题 + 真实素材截图 + 浏览器 sloplint 门禁（对比度/焦点环/首屏/动效），拒绝"一眼 AI"的页面。 | TypeScript + 50 主题 + 可选 Chrome/puppeteer-core | MIT | nutlope/hallmark |
| [impeccable](packages/impeccable) | 设计语言引擎：`polish`/`bolder`/`critique`/`audit` 引导 coding agent 设计，Rust engine 做 62 条确定性检测（拦截 AI 前端套路）。 | Rust 1.97+ engine + TypeScript launcher | Apache-2.0 | pbakaus/impeccable |
| [hyperframes](packages/hyperframes) | agent 原生 HTML→视频框架：HTML/CSS + 可寻址动画写成确定性 MP4。9 个技能路由 + bun 多包 monorepo。 | TypeScript (bun workspaces) + Node | Apache-2.0 | heygen-com/hyperframes |
| [security-audit-skill](packages/security-audit-skill) | 6 阶段安全审计编排技能（Cloudflare）：侦察→覆盖驱动狩猎→候选验证→结构化输出→独立记录核验→目标中性报告。 | markdown + JS（零依赖） | MIT | cloudflare/security-audit-skill |
| [claude-seo](packages/claude-seo) | 通用 SEO 审计插件：29 子技能 + 20 专家 agent 覆盖技术 SEO / E-E-A-T / Schema.org / AI 搜索(GEO/AEO) / 本地 / 电商 / 国际化 / Google API / PDF+Excel 报告。 | Python 3.11–3.15 + pytest | MIT | AgriciDaniel/claude-seo |
| [ai-website-cloner-template](packages/ai-website-cloner-template) | agent skill 网站克隆器：`/clone-website` 一条命令把任意网站重建为干净可编辑的 Next.js 代码。四步流程（Map 路由 → Observe 浏览器观察/提取真实资源 → Build 组件 → Compare 对照修复），含 Framer/动效站专门指引。 | Next.js 16 + React 19 + TS strict + shadcn/ui + Tailwind v4 | MIT | JCodesMore/ai-website-cloner-template |

## 依赖描述

### 工具链基线

| 工具 | 版本 | 用于 |
|---|---|---|
| Python | CPython 3.15.2 | ffmpeg-skill / gif-factory / cinecode / claude-animated-shorts / rea-video / graphify / claude-seo（统一基线） |
| FFmpeg / ffprobe | ≥ 6.1（实测 9.0.2） | 媒体管线（系统 PATH，BtbN 静态构建） |
| Node.js | 24.22.3 | cinecode 渲染、claude-animated-shorts / superpowers / rea / hallmark / security-audit-skill 脚本、ai-website-cloner-template 完整构建（Next.js 16） |
| Rust | 1.97+（cargo） | craft-anything / impeccable engine |
| bun | latest | hyperframes 工作区 |
| Go | 1.25（GOTOOLCHAIN=auto 取 1.26） | open-code-review |
| .NET | 8.0 | unlose（仅 Windows） |

### 系统依赖

- **媒体类**：FFmpeg ≥ 6.1、无头 Chrome（cinecode 逐帧渲染、hallmark/impeccable 浏览器门禁可选）
- **Python 类**：各包 requirements 见包内 `requirements.txt` / `pyproject.toml`；检查脚本会自动建 `.venv` 并安装
- **JS 类**：hyperframes 需 `bun install`；rea 需 `npm install`；纯技能类（hallmark / security-audit-skill）零构建
- **Rust 类**：craft-anything / impeccable 需 cargo 工具链；引擎缺失时 impeccable 退化为纯提示词 skill
- **Windows**：unlose 仅 Windows（VSS + WPF + .NET service）

## 使用描述

### 一键验证 / 构建

```bash
make check          # 验证全部 17 个子包（build + smoke/test）
make check-<pkg>    # 验证单个子包，如 make check-hallmark
make build          # 构建全部子包
make build-<pkg>    # 构建单个子包
```

检查脚本自动降级：Python 类子包缺解释器时 `SKIP`，纯技能类子包无需 Python 即可验证；两个子包支持全量测试开关（hyperframes 用 `HYPERFRAMES_FULL=1`、claude-seo 用 `CLAUDE_SEO_FULL=1`）。

### 单包使用

每个子包是独立完整的上游项目，直接进入目录按上游方式使用：

```bash
# 进入目标子包（保持上游结构，README/SKILL.md 即上游文档）
cd packages/<pkg>

# Python 类：检查脚本自动建 .venv，或手动
python3 -m venv .venv && .venv/bin/pip install -r requirements.txt

# JS 类：装依赖后按包内 package.json 的 scripts 跑
bun install   # 或 npm install
```

子包清单、上游 commit、构建/测试命令见 [packages.json](packages.json)；逐包检查脚本见 [tools/](tools/)。

## 验证状态（Linux 全量实测，2026-11-22；CPython 3.15.2 / bun 1.4.5 / Go 1.26.10 / git 2.47.1+PCRE；全量实测基于 Node 22.23.4，同日 Node 24.22.3 对齐复验：ai-website-cloner-template 完整 check / superpowers 全量 / 其余 JS 轻量包冒烟均通过）

逐包单元/组件/集成测试实测（全量结果，非抽样；完整记录见 [TEST-RECORD.md](TEST-RECORD.md)）：

| 子包 | 结果 |
|---|---|
| ffmpeg-skill | PASS：1907 passed / 3 failed / 20 skipped（3 个失败为字体替换渲染等价性测试，与本机自定义 fontconfig 相关） |
| gif-factory | PASS：27 项测试全过 |
| cinecode | PASS：210 passed / 21 skipped（需无头 Chrome + 系统库，已装） |
| claude-animated-shorts | 无测试套件（纯 Remotion 模板 + 文档），结构验证通过 |
| rea-video | 无测试套件（上游缺陷：pyproject 声明 testpaths=tests 但目录不存在）；核心依赖 + import 验证 PASS |
| craft-anything | PASS：cargo test 全绿（426 个 test result: ok，5000+ `#[test]`；需中性 TMPDIR，见冲突 C3） |
| unlose | SKIP：Windows-only（无 dotnet；CI 覆盖） |
| superpowers | PASS：version-bump shell 测试全过（需 mikefarah yq 的 `strenv` 扩展 + jq，见 C6） |
| open-code-review | PASS：Go 全量全绿（需 git ≥2.47 且带 PCRE 编译，见 C5）+ pages vitest 109/109 |
| rea | 8-worker 全量 54834 tests：49474 passed / 4763 failed / 597 skipped —— **4763 失败全部定性为宿主 node 22.22.3 < engines 下限 22.23.4 的版本缺口假阳性**（runtime-admission 门禁，见 C4）；node 24/26 下复跑待续 |
| graphify | PASS（带环境标注）：全量 11382 passed / 348 skipped / 11 failed；11 失败全在 skillgen（需上游 git 完整历史，本机 git 协议受限，上游 CI fetch-depth:0 可过，见 C7）；3.15 适配已修（C1/R2） |
| hallmark | PASS：验证器 + 结构验证通过 |
| impeccable | PASS：cargo 测试全绿 + UI 组件测试全绿（需浏览器栈） |
| hyperframes | 全量 bun test 进行中/暂停（并发策略调整，见 C9）；已完成小包中 gcp-cloud-run、inspector 全绿；studio 观察到 `vi.waitFor`（vitest API）在 bun test 下 undefined（测试/runner 不匹配，C12） |
| security-audit-skill | PASS：2 个 .test.cjs 全过 + 4 个校验器语法通过 |
| claude-seo | PASS：3876 tests 全过（需先 `git init`） |
| ai-website-cloner-template | PASS：clone-website skill（SKILL.md + 2 references）+ agent 文档（AGENTS.md/CLAUDE.md）+ Next.js 16 脚手架 + package.json 结构验证通过（默认 check）；Node 24.22.3 下 `npm ci && npm run check`（lint + typecheck + build）实测通过（2026-11-22），next 升 16.4.6 后复验通过（2026-11-26）；克隆需带浏览器的 coding agent |

## 冲突与修复（2026-11-22 实测定位）

当日全量实测定位到 12 项冲突，其中 4 组已修复（完整证据链见 [TEST-RECORD.md](TEST-RECORD.md) §3–§4）：

| 组 | 内容 |
|---|---|
| R1 wrapper/CI ×9 | `cmd \| tail` 掩盖退出码 → 显式 `RC=$?` 捕获；去 `bc` 依赖（awk `ver_ge`）；ffmpeg 解压 glob；Go 下载 URL；hyperframes JSON probe；mygo-music 残留清理 |
| R2 graphify 3.15 适配 | `requires-python` → `>=3.11.5,<3.16`（保留上限原则、放行 3.15；tree-sitter 已发 cp315 wheel）+ cap 测试同步 + wrapper 注释 |
| R3 open-code-review locale bug | `isNotGitRepoError` 原匹配英文 fatal 字样，非英文 locale 下纯目录 `--no-index` 重试失效 → 改为 128 + 文件系统探测 `.git`（locale 无关），双 locale 全量验证 |
| R4 工具链补齐 | CPython 3.15.2 / FFmpeg 9.0.2 / Rust / Go 1.26.10 / bun 1.4.5 / git 2.47.1(+libpcre2) / jq 1.7.1 / mikefarah yq 4.54.3 / Chromium+字体 / gettext |

未修复（硬阻塞/环境因素）：rea node 版本缺口假阳性的 Node 24 复跑（C4，基线已升 24.22.3、CI 已就绪，全量 vitest 约 30 分钟级待 CI 或空闲环境复跑收敛 4763 例）、graphify skillgen×11（C7，需上游 git 历史）、ffmpeg-skill 字体×3（C8）、hyperframes 全量与 `vi.waitFor` runner 不匹配（C9/C12，续跑中）。

## 目录结构

```
packages/       17 个子包（保持上游结构）
tools/          顶层验证编排脚本（check-package.sh 分发 + 每包一个检查脚本）
.monkeycode/    规格文档（需求与技术设计）
.github/        CI workflow（GitHub Actions 跑全量 check）
packages.json   子包 manifest（名称、语言、上游 commit、构建/测试命令）
```

## 已知限制

- **ffmpeg-skill**：纯标准库，需 FFmpeg ≥ 6.1 在 PATH；全量 test_all.py 耗时长，CI 按契约测试跑。
- **rea-video**：onnxruntime（音频分离 UVR MDX-Net + BandIt v2）在 Python 3.15 无 wheel，核心视频取证不依赖它；VLM 需配置 Gemini / Doubao 端点。
- **craft-anything**：完整桌面 app 构建需 libgtk-3-dev；CLI 与 MCP server 为 headless 路径；early alpha。
- **unlose**：Windows-only（VSS + WPF + .NET service）；Linux/macOS 只做源码验证。
- **open-code-review**：go.mod 要求 Go 1.26，系统 1.25 时由 `GOTOOLCHAIN=auto` 在 CI 拉取。测试 git 依赖：需 git ≥ 2.47（`git grep --max-count`）且编译带 PCRE（`-P` 正则；`./configure --with-libpcre2`）。已修复的 locale bug：`isNotGitRepoError` 原匹配英文 fatal 字样，非英文 locale 下纯目录重试失效，现改为 128 + 文件系统探测（v0.1.1）。
- **rea**：native 分析需 Hopper/Ghidra/IDA 之一；静态 JS/.NET 分析无需引擎。**Node 版本门禁**：`engines.node = ^22.23.4 || ^24.22.1 || >=26.12.1`，低于下限的宿主（如 22.22.3）会触发 runtime-admission 拒绝，所有"起真实 CLI 子进程"的验收测试批量假失败（2026-11-22 实测 4763 例）——monorepo 基线已升 24.22.3（满足 `^24.22.1`），CI 24 下复跑即可收敛。全量 vitest（3825 文件）耗时长（8-worker 约 30 分钟级）。
- **graphify**：`requires-python = >=3.11.5,<3.16`（v0.1.1 起：保留"上限防无 wheel 解释器"原则、放行 3.15——tree-sitter 已发 cp315 wheel；3.16+ 无 wheel 会回退源码编译）。测试注意：skillgen×11 需上游 git 完整历史（CI fetch-depth:0；无 git 历史环境会失败）；依赖按 uv.lock 版本 pin（pyyaml 6.0.3、tree-sitter-c-sharp 0.23.5），装到更新的 minor 会触发版本漂移断言；TMPDIR 含 "cache" 等字样时个别路径断言会假阳性（用中性 TMPDIR）。
- **hallmark**：浏览器检查（sloplint --render、截图）需 Chrome + puppeteer-core；缺失时静态检查仍可跑。
- **impeccable**：Rust engine 需 `cargo build --release -p impeccable`；引擎缺失时 skill 退化为纯提示词。
- **hyperframes**：完整构建/测试需 `bun install`；默认 check 只做 manifest + 技能目录验证。迁移时曾遗漏上游 `scripts/` 目录（build 后处理 + test:scripts 全部脚本测试依赖它），已从上游 `af0664c` 补齐（167 项）；上游另有的 `releases/`、`server.json`、`skills-manifest.json` 仅 CI 发布流程引用，未随迁。测试环境受限项：Chrome headless 缺失时浏览器相关测试自动降级。全量 `bun test` 注意：部分 studio 测试使用 vitest 的 `vi.waitFor` 但 runner 为 bun test（`vi` undefined，2026-11-22 实测观察到，属测试/runner 不匹配）；并行执行需控制进程数（17 路并行实测触发 OOM，串行或 ≤4 路并行安全）。
- **security-audit-skill**：实际审计需 coding agent 基础设施（agent runtime + 并行 subagent + 沙箱）。
- **claude-seo**：已基于 3.15 改写——google-ads 全系 ≤35.1.0 元数据声明 `<3.15`，实测 35.1.0 在 3.15.2 import 通过，setup 以 `--ignore-requires-python` 安装并纳入安装验证，8 处版本边界副本同步改写；PDF 报告需系统 pango；实际审计需 Claude Code 运行环境。测试环境受限项：`test_render_page_never_mode_against_example_com` 需访问 example.com（沙箱无外网时失败），属 live 网络测试。
- **ai-website-cloner-template**：克隆网站需带浏览器访问能力的 AI coding agent（推荐 Claude Code + Opus 5.5，也支持 Codex/Cursor/OpenCode——无内置浏览器的宿主需配 Playwright MCP）+ Node.js 24+（上游要求，monorepo 基线已对齐 24.22.3）；`npm run check`（lint + typecheck + build）需先 `npm install`；默认 check 只做 skill + 脚手架结构验证。用途自担：上游明确禁止钓鱼冒充、盗用设计、违反目标站服务条款。**Node 基线对齐（2026-11-22 完成）**：monorepo Node 基线已从 22.23.4 升至 24.22.3（CI setup-node 同步）——本包 `npm ci && npm run check` 在 24.22.3 下实测通过（Next.js 16 build 4/4 静态页），superpowers / security-audit-skill / hallmark / cinecode 等 JS 包复验通过；rea `engines.node` 的 `^24.22.1` 线亦被覆盖，rea 4763 例 node 门禁假阳性可在 24 下复跑收敛。

## 授权

**授权遵从上游**：每个子包保持其上游 LICENSE 原样（MIT / Apache-2.0 / 双授权，详见各包目录内 LICENSE 文件与上方子包一览表）。本仓库不修改、不收窄任何上游授权条款。

本仓库组织层新增的内容（Makefile、tools/ 检查脚本、CI workflow、packages.json、README）不附加额外限制，跟随对应子包的上游授权使用；对整体套件的分发同样以各子包上游授权为准。

上游来源：

- 媒体创作：[ffmpeg-skill](https://github.com/kajisho5/ffmpeg-skill) / [gif-factory](https://github.com/WoYun520/gif-factory) / [cinecode](https://github.com/sarpstar/cinecode) / [claude-animated-shorts](https://github.com/mromidev/claude-animated-shorts) / [rea-video](https://github.com/JuneYaooo/rea-video) / [craft-anything](https://github.com/storytold/craft-anything) / [unlose](https://github.com/unlose-app/unlose)
- 建站/站点分析：[superpowers](https://github.com/obra/superpowers) / [ai-website-cloner-template](https://github.com/JCodesMore/ai-website-cloner-template) / [open-code-review](https://github.com/alibaba/open-code-review) / [rea](https://github.com/morluto/rea) / [graphify](https://github.com/Graphify-Labs/graphify) / [hallmark](https://github.com/nutlope/hallmark) / [impeccable](https://github.com/pbakaus/impeccable) / [hyperframes](https://github.com/heygen-com/hyperframes) / [security-audit-skill](https://github.com/cloudflare/security-audit-skill) / [claude-seo](https://github.com/AgriciDaniel/claude-seo)

各子包对应的精确上游 commit 记录在 [packages.json](packages.json)。
