# Creation Skill Suite

![version](https://img.shields.io/badge/version-0.1.0-blue) ![packages](https://img.shields.io/badge/packages-16-green) ![python](https://img.shields.io/badge/Python-3.15.2-blue) ![node](https://img.shields.io/badge/Node-22.23.4-green)

**v0.1.0** — 一个 monorepo，收拢 **16 个上游创作工具**：**媒体创作 7 个** + **建站/站点分析 9 个**。每个子包保持上游目录结构与许可证、独立可用；本仓库在其上提供统一的环境基线、验证入口与共享工程设施（Makefile / 检查脚本 / CI）。

## 功能描述

本套件面向 coding agent 与开发者，覆盖三类能力：

1. **媒体创作（7 包）**：视频/音频编辑（ffmpeg-skill）、动态图与海报（gif-factory）、代码生成电影（cinecode）、动画短片（claude-animated-shorts）、视频逆向拆解（rea-video）、软件逆向重建（craft-anything）、agent 数据防护（unlose）。
2. **建站 / 站点分析（9 包）**：开发方法论技能集（superpowers）、AI 代码审查（open-code-review）、逆向工程 MCP 框架（rea）、代码知识图谱（graphify）、反 AI 套路设计（hallmark）、设计语言引擎（impeccable）、HTML→视频（hyperframes）、安全审计编排（security-audit-skill）、SEO 审计（claude-seo）。
3. **统一工程设施**：全部 Python 子包统一跑在 **CPython 3.15.2**（claude-seo 为此做了基于 3.15 的改写）；`make check` 一键验证 16 个子包，结果为 `PASS` / `SKIP(原因)` / `FAIL` 三态；上游 commit、构建/测试命令记录在 [packages.json](packages.json)。

### 媒体创作（7）

| 子包 | 能做什么 | 技术栈 | 许可证 | 上游 |
|---|---|---|---|---|
| [ffmpeg-skill](packages/ffmpeg-skill) | 给 coding agent 的本地视频/音频编辑器：42 个工具覆盖裁剪、拼接、转码、字幕烧录、音频分离、静默检测、响度标准化、HDR→SDR、多机位、平台导出检查。无云、无 API key。 | Python 3.15（纯标准库）+ FFmpeg 9 | MIT | kajisho5/ffmpeg-skill |
| [gif-factory](packages/gif-factory) | 动态图创作工厂：表情包、光栅变画卡、动态海报、动态签名、电影片头、文章封面配色、动态绘本、品牌短片。有素材就能合成，不需要文生图模型。 | Python 3.15 + Pillow 13 / NumPy 2.5 / SciPy 1.18 | MIT | WoYun520/gif-factory |
| [cinecode](packages/cinecode) | 代码生成电影：AI 写剧本，three.js 在无头 Chrome 逐帧渲染 3D 场景，FFmpeg 合成 MP4。短片、YouTube 长视频、广告、科普视频、MV。 | Python 3.15 + Node 22 + three.js + FFmpeg | MIT | sarpstar/cinecode |
| [claude-animated-shorts](packages/claude-animated-shorts) | 竖屏 55–70s 动画故事短片：2D 角色 + 彩色 3D 世界，墨线轮廓、镜头运动、配乐音效。纯本地渲染，不用 AI 视频生成器。 | Remotion 4.0.545 + three.js + Node 22 + Python 3.15 | MIT | mromidev/claude-animated-shorts |
| [rea-video](packages/rea-video) | 视频逆向拆解：逐镜头判断实拍/AI 生成/3D 渲染/代码模板/录屏，输出 VIDEO.md 格式报告 + 复刻方案（Remotion / Blender / 拍摄计划）。 | Python ≥3.10 + OpenCV + NumPy + ffmpeg | Apache-2.0 | JuneYaooo/rea-video |
| [craft-anything](packages/craft-anything) | 软件逆向重建引擎：看懂任意网站/应用/游戏怎么做的，再用 coding agent 在你的目标栈里重建。320 工具 + CLI + MCP server。 | Rust 1.97+ + wgpu + egui | MIT / Apache-2.0 | storytold/craft-anything |
| [unlose](packages/unlose) | AI agent 数据防护：agent 开工前自动做全盘 VSS 快照，删错/损坏/加密后拖时间线恢复。 | C# / .NET 8 + WPF + Windows VSS | Apache-2.0 | unlose-app/unlose |

### 建站 / 站点分析（9）

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

## 依赖描述

### 工具链基线

| 工具 | 版本 | 用于 |
|---|---|---|
| Python | CPython 3.15.2 | ffmpeg-skill / gif-factory / cinecode / claude-animated-shorts / rea-video / graphify / claude-seo（统一基线） |
| FFmpeg / ffprobe | ≥ 6.1（实测 9.0.2） | 媒体管线（系统 PATH，BtbN 静态构建） |
| Node.js | 22.23.4 | cinecode 渲染、claude-animated-shorts / superpowers / rea / hallmark / security-audit-skill 脚本 |
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
make check          # 验证全部 16 个子包（build + smoke/test）
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

## 验证状态（Linux，Python 3.15.2 / Node 22.23.4 / bun 1.3.5 / go 1.25.6）

逐包单元/集成测试实测（2026-11）：

| 子包 | 结果 |
|---|---|
| ffmpeg-skill | PASS：契约测试 486 项通过（skipped 4） |
| gif-factory | PASS：27 项测试 + 11 subtests 通过 |
| cinecode | PASS：231 tests passed / 21 skipped（纯标准库 unittest） |
| claude-animated-shorts | 无测试套件（纯 Remotion 模板 + 文档），结构验证通过 |
| rea-video | 无单元测试，核心依赖 + rea_video import 验证 PASS |
| craft-anything | SKIP：环境无 cargo/rustc，5083 个 `#[test]` 需 Rust 工具链（CI 覆盖） |
| unlose | SKIP：Windows-only（Pester + VSS；CI 覆盖） |
| superpowers | PASS：brainstorm-server 124 项 node 测试 + 28 项 shell 检查全过 |
| open-code-review | PASS（带环境标注）：34/37 包 go 测试 ok；3 包 26 个 git e2e 用例因沙箱 git 2.39.5 + 预置 `GIT_CONFIG_COUNT` 报 `git exit 129` 失败，属环境限制而非代码缺陷 |
| rea | PASS（带环境标注）：src 层 31303 tests → 31221 passed / 4 failed / 78 skipped；4 个失败为大文件/边界资源测试（7G 内存 cgroup 限制） |
| graphify | PASS（带环境标注）：全量 11533 tests → 10996 passed / 92 failed / 544 skipped；92 个失败集中在 Terraform 模块(23)与 YAML 合并键(1)两个可选扩展 |
| hallmark | PASS：5 个 .test.mjs 28 项全过（浏览器相关项自动 SKIP） |
| impeccable | PASS：core 306 tests（300 pass / 0 fail / 6 skipped）+ detector 475 tests（475 pass / 0 fail） |
| hyperframes | scripts/ 已从上游 af0664c 补齐（167 项：build 后处理 + test:scripts 依赖）；完整构建/测试需 `bun install` + Chrome headless（`HYPERFRAMES_FULL=1`） |
| security-audit-skill | PASS：2 个测试文件全过 + 4 个校验器语法通过 |
| claude-seo | PASS（带环境标注）：全量 3902 tests → 3894 passed / 1 failed / 7 skipped；1 个失败为访问 example.com 的 live 网络测试（沙箱无外网） |

## 目录结构

```
packages/       16 个子包（保持上游结构）
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
- **open-code-review**：go.mod 要求 Go 1.26，系统 1.25 时由 `GOTOOLCHAIN=auto` 在 CI 拉取。测试环境受限项：沙箱 git 2.39.5 + 预置 `GIT_CONFIG_COUNT` 环境变量（credential.helper 配置）导致 3 个包 26 个 git e2e 用例报 `git exit 129`，属环境限制而非代码缺陷；本地验证时可 `env -u GIT_CONFIG_COUNT -u GIT_CONFIG_KEY_0 -u GIT_CONFIG_VALUE_0 -u GIT_CONFIG_KEY_1 -u GIT_CONFIG_VALUE_1` 清除后重试。
- **rea**：native 分析需 Hopper/Ghidra/IDA 之一；静态 JS/.NET 分析无需引擎。测试环境受限项：4 个大文件/边界测试（NodeSeaArtifactReader、ReleaseExposureReader、PyInstallerBoundaries、javascript alias write bounds）在 7G 内存 cgroup 限制下失败，资源充足时可过；全量 vitest（tests/ + src/，2241 文件）耗时长，src 层已覆盖核心单元测试。
- **graphify**：pyproject `requires-python` 上限已放开（tree-sitter 0.26.1 支持 3.15）；92 个失败集中在 Terraform 模块 / YAML 合并键两个可选扩展，核心图谱功能不受影响。
- **hallmark**：浏览器检查（sloplint --render、截图）需 Chrome + puppeteer-core；缺失时静态检查仍可跑。
- **impeccable**：Rust engine 需 `cargo build --release -p impeccable`；引擎缺失时 skill 退化为纯提示词。
- **hyperframes**：完整构建/测试需 `bun install`；默认 check 只做 manifest + 技能目录验证。迁移时曾遗漏上游 `scripts/` 目录（build 后处理 + test:scripts 全部脚本测试依赖它），已从上游 `af0664c` 补齐（167 项）；上游另有的 `releases/`、`server.json`、`skills-manifest.json` 仅 CI 发布流程引用，未随迁。测试环境受限项：Chrome headless 缺失时浏览器相关测试自动降级。
- **security-audit-skill**：实际审计需 coding agent 基础设施（agent runtime + 并行 subagent + 沙箱）。
- **claude-seo**：已基于 3.15 改写——google-ads 全系 ≤35.1.0 元数据声明 `<3.15`，实测 35.1.0 在 3.15.2 import 通过，setup 以 `--ignore-requires-python` 安装并纳入安装验证，8 处版本边界副本同步改写；PDF 报告需系统 pango；实际审计需 Claude Code 运行环境。测试环境受限项：`test_render_page_never_mode_against_example_com` 需访问 example.com（沙箱无外网时失败），属 live 网络测试。

## 授权

**授权遵从上游**：每个子包保持其上游 LICENSE 原样（MIT / Apache-2.0 / 双授权，详见各包目录内 LICENSE 文件与上方子包一览表）。本仓库不修改、不收窄任何上游授权条款。

本仓库组织层新增的内容（Makefile、tools/ 检查脚本、CI workflow、packages.json、README）不附加额外限制，跟随对应子包的上游授权使用；对整体套件的分发同样以各子包上游授权为准。

上游来源：

- 媒体创作：[ffmpeg-skill](https://github.com/kajisho5/ffmpeg-skill) / [gif-factory](https://github.com/WoYun520/gif-factory) / [cinecode](https://github.com/sarpstar/cinecode) / [claude-animated-shorts](https://github.com/mromidev/claude-animated-shorts) / [rea-video](https://github.com/JuneYaooo/rea-video) / [craft-anything](https://github.com/storytold/craft-anything) / [unlose](https://github.com/unlose-app/unlose)
- 建站/站点分析：[superpowers](https://github.com/obra/superpowers) / [open-code-review](https://github.com/alibaba/open-code-review) / [rea](https://github.com/morluto/rea) / [graphify](https://github.com/Graphify-Labs/graphify) / [hallmark](https://github.com/nutlope/hallmark) / [impeccable](https://github.com/pbakaus/impeccable) / [hyperframes](https://github.com/heygen-com/hyperframes) / [security-audit-skill](https://github.com/cloudflare/security-audit-skill) / [claude-seo](https://github.com/AgriciDaniel/claude-seo)

各子包对应的精确上游 commit 记录在 [packages.json](packages.json)。
