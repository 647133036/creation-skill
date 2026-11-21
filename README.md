# Media + Site-Tool Suite

一个 monorepo，整合 16 个上游工具：**媒体创作 7 个**（本地视频/音频编辑、动态图合成、代码生成电影、竖屏动画短片、视频逆向拆解、软件逆向重建、AI agent 数据防护）+ **建站/站点分析工具 9 个**（软件开发方法论、AI 代码审查、逆向工程 MCP、代码知识图谱、反 AI 套路设计、设计语言引擎、HTML→视频框架、安全审计编排、SEO 审计技能集）。每个子包独立可用，保留上游目录结构与许可证；本仓库提供统一的环境基线、验证入口与共享工程设施。

## 子包一览

### 媒体创作

| 子包 | 能做什么 | 技术栈 | 许可证 | 上游 |
|---|---|---|---|---|
| [packages/ffmpeg-skill](packages/ffmpeg-skill) | 给 coding agent 的本地视频/音频编辑器：42 个工具覆盖裁剪、拼接、转码、字幕烧录、音频分离、静默检测、响度标准化、HDR→SDR、多机位、平台导出检查。无云、无 API key。 | Python 3.15（纯标准库）+ FFmpeg 9 | MIT | kajisho5/ffmpeg-skill |
| [packages/gif-factory](packages/gif-factory) | 动态图创作工厂：表情包、光栅变画卡、动态海报、动态签名、电影片头、文章封面配色、动态绘本、品牌短片、vibe 知识大赏。有素材就能合成，不需要文生图模型。 | Python 3.15 + Pillow 13 / NumPy 2.5 / SciPy 1.18 | MIT | WoYun520/gif-factory |
| [packages/cinecode](packages/cinecode) | 代码生成电影：AI 写剧本，three.js 在无头 Chrome 逐帧渲染 3D 场景，FFmpeg 合成 MP4。短片、YouTube 长视频、广告、科普视频、MV。 | Python 3.15 + Node 22 + three.js + FFmpeg | MIT | sarpstar/cinecode |
| [packages/claude-animated-shorts](packages/claude-animated-shorts) | 竖屏 55–70s 动画故事短片：2D 角色 + 彩色 3D 世界，墨线轮廓、镜头运动、配乐音效。纯本地渲染，不用 AI 视频生成器。 | Remotion 4.0.545 + three.js + Node 22 + Python 3.15 | MIT | mromidev/claude-animated-shorts |
| [packages/rea-video](packages/rea-video) | 视频逆向拆解：逐镜头判断实拍/AI 生成/3D 渲染/代码模板/录屏，输出 VIDEO.md 格式报告 + 复刻方案（Remotion / Blender / 拍摄计划）。配合 capsule-cinema 可自动复刻 AI 镜头。 | Python ≥3.10 + OpenCV + NumPy + ffmpeg | Apache-2.0 | JuneYaooo/rea-video |
| [packages/craft-anything](packages/craft-anything) | 软件逆向重建引擎：看懂任意网站/应用/游戏怎么做的（clean-room 或 deep 模式），再用 coding agent 在你的目标栈里重建。320 工具 + CLI + MCP server。 | Rust 1.97+ + wgpu + egui | MIT / Apache-2.0 | storytold/craft-anything |
| [packages/unlose](packages/unlose) | AI agent 数据防护：agent 开工前自动做全盘 VSS 快照，删错/损坏/加密后拖时间线恢复。176 单测 + 16 UI 测试 + VM e2e 通过。 | C# / .NET 8 + WPF + Windows VSS | Apache-2.0 | unlose-app/unlose |

### 建站 / 站点分析

| 子包 | 能做什么 | 技术栈 | 许可证 | 上游 |
|---|---|---|---|---|
| [packages/superpowers](packages/superpowers) | 给 coding agent 的软件开发方法论技能集：15 个 markdown 技能（brainstorming、TDD、systematic-debugging、code-review、subagent-driven-development 等），跨多宿主安装。无构建。 | TypeScript + 15 个技能目录 | MIT | obra/superpowers |
| [packages/open-code-review](packages/open-code-review) | AI 代码审查 CLI（ocr）：读 git diff，确定性文件分组 + LLM agent，行级精准评论，内置 NPE/线程安全/XSS/SQL 注入规则集，OpenAI/Anthropic 兼容。 | Go 1.26 + Node launcher | Apache-2.0 | alibaba/open-code-review |
| [packages/rea](packages/rea) | 逆向工程 MCP 框架：agent 调用本地工具分析 native 二进制 / JS / Electron / .NET / APK / 固件，输出带证据的结论；可把录制的 Web 会话变成 RL 环境。 | Node.js 22+/24+/26 + TypeScript + turbo | MIT | morluto/rea |
| [packages/graphify](packages/graphify) | 代码知识图谱：tree-sitter AST 本地解析 40+ 语言 + 文档/PDF/音视频，生成可查询图谱（graph.html / graph.json），agent 查图代替 grep。无向量库。 | Python 3.15 + tree-sitter + networkx | Apache-2.0 + MIT | Graphify-Labs/graphify |
| [packages/hallmark](packages/hallmark) | 反 AI 套路设计技能：50 套材质主题 + 真实素材截图 + 浏览器 sloplint 门禁（对比度/焦点环/首屏/动效），拒绝"一眼 AI"的页面；支持 build / audit / redesign / study 四动词。 | TypeScript + 50 主题 + 可选 Chrome/puppeteer-core | MIT | nutlope/hallmark |
| [packages/impeccable](packages/impeccable) | 设计语言引擎：`polish`/`bolder`/`critique`/`audit` 引导 coding agent 设计，Rust engine 二进制做 62 条确定性检测（拦截 AI 前端套路如过度 Inter、紫蓝渐变、卡片嵌套）。 | Rust 1.97+ engine + TypeScript launcher | Apache-2.0 | pbakaus/impeccable |
| [packages/hyperframes](packages/hyperframes) | agent 原生 HTML→视频框架：HTML/CSS + 可寻址动画写成确定性 MP4，"Write HTML. Render video. Built for agents." 9 个技能路由 + bun 多包 monorepo。 | TypeScript (bun workspaces) + Node | Apache-2.0 | heygen-com/hyperframes |
| [packages/security-audit-skill](packages/security-audit-skill) | 6 阶段安全审计编排技能（Cloudflare）：侦察→覆盖驱动狩猎→候选验证→结构化输出→独立记录核验→目标中性报告；prompt 文件 + 2 个零依赖 node 校验器，产出机器可读 findings。 | markdown + JS（零依赖） | MIT | cloudflare/security-audit-skill |
| [packages/claude-seo](packages/claude-seo) | 通用 SEO 审计插件：29 子技能 + 20 专家 agent 覆盖技术 SEO / E-E-A-T / Schema.org / AI 搜索(GEO/AEO) / 本地 / 电商 / 国际化 / Google API / PDF+Excel 报告。 | Python ≥3.11 + pytest | MIT | AgriciDaniel/claude-seo |

各子包的上游 commit 记录在 [packages.json](packages.json)。

## 工具链基线

| 工具 | 版本 | 说明 |
|---|---|---|
| Python | CPython 3.15.2 | 源码编译安装于 `/opt/python3.15`，全 monorepo 统一基线（ffmpeg-skill / gif-factory / cinecode / rea-video / graphify / claude-seo 均以它或 ≥3.11 为基线） |
| FFmpeg / ffprobe | 9.0.2 | 系统 PATH，BtbN 静态构建 |
| Node.js | 22.23.4 | cinecode 渲染管线、hallmark / superpowers / rea / security-audit-skill / hyperframes 辅助脚本 |
| Rust | 1.97+ | craft-anything / impeccable cargo check / build |
| .NET | 8.0 | unlose 构建（仅 Windows） |
| Go | 1.25（GOTOOLCHAIN=auto 取 1.26） | open-code-review go vet |
| bun | latest | hyperframes 工作区构建与测试 |

## 验证

```bash
make check                      # 全部 16 个子包
make check-hallmark            # 单个子包
make check-hyperframes
make check-claude-seo
make check-security-audit-skill
# …
```

每个检查脚本给出 `PASS` / `SKIP(原因)` / `FAIL`。

纯技能/提示词类子包（hallmark、impeccable、security-audit-skill）无构建依赖，无需 Python 即可验证；Python 类子包缺解释器时自动 `SKIP` 而非报错。

## 目录结构

```
packages/       16 个子包（保持上游结构）
tools/          顶层验证编排脚本
.monkeycode/    规格文档（需求与技术设计）
.github/        CI workflow（GitHub Actions 跑全量 check）
packages.json   子包 manifest（名称、语言、上游 commit、构建/测试命令）
```

## 已知限制

- **ffmpeg-skill**：纯 Python 标准库，无第三方依赖，但需要 FFmpeg ≥ 6.1 在 PATH 上。
- **rea-video**：onnxruntime（音频分离 UVR MDX-Net + BandIt v2）在 Python 3.15 无 wheel，核心视频取证不依赖它；需 VLM 可配置 Gemini / Doubao 端点。
- **craft-anything**：Rust 工作区，完整桌面 app 构建需 libgtk-3-dev；CLI 和 MCP server 是 headless 路径。early alpha 状态。
- **unlose**：Windows-only（VSS + WPF + .NET service），Linux/macOS 上只做源码验证，构建和运行需 Windows 10/11 x64。
- **open-code-review**：go.mod 要 Go 1.26，系统 Go 1.25 用 `GOTOOLCHAIN=auto` 自动拉取；CI 上由 check 脚本处理。
- **rea**：Node.js 22.x/24.x/26.x；native 分析需 Hopper/Ghidra/IDA 之一；静态 JS/.NET 分析无需引擎。
- **graphify**：统一走 Python 3.15（pyproject `requires-python` 上限已放开；tree-sitter 0.26.1 支持 3.15）；tree-sitter grammars 是 heavy 依赖，核心 import 验证走轻量依赖。
- **hallmark**：浏览器检查（sloplint --render、截图）需 Chrome + puppeteer-core；没有它们静态检查仍可跑。
- **impeccable**：Rust engine 二进制需 `cargo build --release -p impeccable`；skill 脚本可直接跑，引擎缺失时退化为纯提示词。
- **hyperframes**：bun workspaces 多包，完整构建/测试需 `bun install`；默认 check 只做 manifest + skill 目录验证，`HYPERFRAMES_FULL=1` 触发全量测试。
- **security-audit-skill**：纯 prompt + 零依赖校验器，无构建无安装；实际审计需 coding agent 基础设施（agent runtime + 并行 subagent + 沙箱）。
- **claude-seo**：Claude Code 插件，安装 Python 依赖后需 Claude Code 运行环境才能跑 29 项审计；pytest 套件可独立验证 skill 结构。
