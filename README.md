# Media + Site-Tool Suite

一个 monorepo，整合 11 个上游工具：**媒体创作 7 个**（本地视频/音频编辑、动态图合成、代码生成电影、竖屏动画短片、视频逆向拆解、软件逆向重建、AI agent 数据防护）+ **建站/站点分析工具 4 个**（软件开发方法论技能集、AI 代码审查 CLI、逆向工程 MCP 框架、代码知识图谱）。每个子包独立可用，保留上游目录结构与许可证；本仓库提供统一的环境基线、验证入口与共享工程设施。

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
| [packages/superpowers](packages/superpowers) | 给 coding agent 的软件开发方法论技能集：15 个 markdown 技能（brainstorming、TDD、systematic-debugging、code-review、subagent-driven-development 等），跨 Claude/Codex/Cursor/Gemini/Devin 等多宿主安装。无构建。 | TypeScript + 15 个技能目录 | MIT | obra/superpowers |
| [packages/open-code-review](packages/open-code-review) | AI 代码审查 CLI（ocr）：读 git diff，确定性文件分组 + LLM agent，行级精准评论，内置 NPE/线程安全/XSS/SQL 注入规则集，OpenAI/Anthropic 兼容。 | Go 1.26 + Node launcher | Apache-2.0 | alibaba/open-code-review |
| [packages/rea](packages/rea) | 逆向工程 MCP 框架：agent 调用本地工具分析 native 二进制 / JS / Electron / .NET / APK / 固件，输出带证据的结论；可把录制的 Web 会话变成 RL 环境。 | Node.js 22+/24+/26 + TypeScript + turbo | MIT | morluto/rea |
| [packages/graphify](packages/graphify) | 代码知识图谱：tree-sitter AST 本地解析 40+ 语言 + 文档/PDF/音视频，生成可查询图谱（graph.html / graph.json），agent 查图代替 grep。无向量库。 | Python 3.11.5–3.14 + tree-sitter + networkx | Apache-2.0 + MIT | Graphify-Labs/graphify |

各子包的上游 commit 记录在 [packages.json](packages.json)。

## 工具链基线

| 工具 | 版本 | 说明 |
|---|---|---|
| Python | CPython 3.15.2 | 源码编译安装于 `/opt/python3.15`，全 monorepo 统一基线（ffmpeg-skill / gif-factory / cinecode / rea-video / graphify 均以它为基线） |
| FFmpeg / ffprobe | 9.0.2 | 系统 PATH，BtbN 静态构建 |
| Node.js | 22 | cinecode 渲染管线、claude-animated-shorts / superpowers / rea 辅助脚本 |
| Rust | 1.97+ | craft-anything cargo check / build |
| .NET | 8.0 | unlose 构建（仅 Windows） |
| Go | 1.25（GOTOOLCHAIN=auto 取 1.26） | open-code-review go vet |

## 验证

```bash
make check                      # 全部 11 个子包
make check-ffmpeg-skill        # 单个子包
make check-open-code-review
make check-rea
make check-graphify
make check-superpowers
# …
```

每个检查脚本给出 `PASS` / `SKIP(原因)` / `FAIL`。

当前 `make check` 在 Linux 环境通过：Python 媒体子包 + rea-video 核心依赖 + craft-anything SKIP（无 cargo）+ unlose SKIP（无 dotnet）+ superpowers PASS（node 在）+ open-code-review 视 go/GOTOOLCHAIN + rea 视 tsc + graphify SKIP（Python 版本地板 3.11.5，系统 3.11.2）。

## 目录结构

```
packages/       11 个子包（保持上游结构）
tools/          顶层验证编排脚本
.monkeycode/    规格文档（需求与技术设计）
.github/        CI workflow（GitHub Actions 跑全量 check）
packages.json   子包 manifest（名称、语言、上游 commit、构建/测试命令）
```

## 已知限制

- **ffmpeg-skill**：纯 Python 标准库，无第三方依赖，但需要 FFmpeg ≥ 6.1 在 PATH 上。
- **rea-video**：onnxruntime（音频分离 UVR MDX-Net + BandIt v2）在 Python 3.15 无 wheel，核心视频取证（镜头切分/实拍-AI 判定/字幕/复刻规划）不依赖它；需 VLM 可配置 Gemini / Doubao 端点。
- **craft-anything**：Rust 工作区，完整桌面 app 构建需 libgtk-3-dev；CLI 和 MCP server 是 headless 路径。early alpha 状态。
- **unlose**：Windows-only（VSS + WPF + .NET service），Linux/macOS 上只做源码验证，构建和运行需 Windows 10/11 x64。
- **open-code-review**：go.mod 要 Go 1.26，系统 Go 1.25 用 `GOTOOLCHAIN=auto` 自动拉取；CI 上由 check 脚本处理。
- **rea**：Node.js 22.x/24.x/26.x；native 分析需 Hopper/Ghidra/IDA 之一；静态 JS/.NET 分析无需引擎。
- **graphify**：统一走 Python 3.15（pyproject `requires-python` 上限已放开；tree-sitter 0.26.1 支持 3.15）；tree-sitter grammars 是 heavy 依赖，核心 import 验证走轻量依赖。
