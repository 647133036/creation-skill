# Media Suite

6 个媒体创作工具整合在一个 monorepo 里，覆盖视频编辑、动态图合成、代码生成电影、动画短片、会议转写与音乐播放。每个子包独立可用，保留上游目录结构与许可证；本仓库提供统一的环境基线、验证入口与共享工程设施。

## 子包一览

| 子包 | 能做什么 | 技术栈 | 上游 |
|---|---|---|---|
| [packages/ffmpeg-skill](packages/ffmpeg-skill) | 给 coding agent 本地视频/音频编辑器：裁剪、拼接、转码、字幕烧录、音频分离等 42 个工具。无云、无 API key，agent 自己检查输出。 | Python 3.15（纯标准库）+ FFmpeg 9 | kajisho5/ffmpeg-skill |
| [packages/gif-factory](packages/gif-factory) | GIF 表情包、光栅变画卡、动态海报、动态签名、电影片头、动态绘本、品牌短片。有素材就能合成，不需要文生图模型。 | Python 3.15 + Pillow / NumPy / SciPy | WoYun520/gif-factory |
| [packages/cinecode](packages/cinecode) | 代码生成电影：AI 写剧本，three.js 在无头 Chrome 逐帧渲染 3D 场景，FFmpeg 合成 MP4。短片、长视频、广告、解说、MV。 | Python 3.15 + Node 22 + three.js + FFmpeg | sarpstar/cinecode |
| [packages/claude-animated-shorts](packages/claude-animated-shorts) | 竖屏 55–70s 动画故事短片：2D 角色 + 彩色 3D 世界，墨线轮廓、镜头运动、配乐音效。纯本地渲染，不用 AI 视频生成器。 | Remotion 4.0.545 + three.js + Node 22 + Python 3.15 | mromidev/claude-animated-shorts |
| [packages/cicada](packages/cicada) | 实时会议转写、双语字幕、同声传译、结构化纪要、说话人识别。Mac / Windows / Linux / Android 全平台。Linux 版用 Python + GTK3，本环境可直接验证。 | Swift 6（macOS GUI）+ Cloudflare Workers + Python 3 / C | wquguru/cicada |
| [packages/mygo-music](packages/mygo-music) | Go 原生桌面音乐播放器（无 WebView）：本地文件、播放列表、歌词、均衡器、播客字幕、插件系统。官网用 solid-js 2.0 + Vite 构建，部署 Cloudflare。 | Go 1.27 + solid-js 2.0 + Vite 8 | egoist/mygo-music |

各子包的上游 commit 记录在 [packages.json](packages.json)。

## 工具链基线

| 工具 | 版本 | 说明 |
|---|---|---|
| Python | CPython 3.15.2 | 源码编译安装于 `/opt/python3.15`，全部 Python 子包以它为基线 |
| FFmpeg / ffprobe | 9.0.2 | 系统 PATH，BtbN 静态构建 |
| Go | 1.27.3（GOTOOLCHAIN=auto） | mygo-music 构建与测试 |
| Node.js | 22 | cinecode、cicada server、claude-animated-shorts |
| bun | 1.4.5 | mygo-music website 构建与依赖安装 |
| swift | 6.4 工具链 | cicada 的 macOS 构建在本仓库外的 Mac 环境执行 |

## 验证

```bash
make check                # 全部 6 个子包
make check-ffmpeg-skill   # 单个子包
make check-cicada
make check-mygo-music
# …
```

每个检查脚本给出 `PASS` / `SKIP(原因)` / `FAIL`。

当前 `make check` 全部通过（Python 3.15.2 + FFmpeg 9.0.2 + Node 22 + Go 1.27.3 + bun）。

## 目录结构

```
packages/       6 个子包（保持上游结构）
tools/          顶层验证编排脚本
.monkeycode/    规格文档（需求与技术设计）
.github/        CI workflow（GitHub Actions 跑全量 check）
packages.json   子包 manifest（名称、语言、上游 commit、构建/测试命令）
```

## 已知限制

- **cicada**：Swift 6 的 macOS GUI 部分（AppKit / SwiftUI / AVFoundation）无法在 Linux 上构建或验证，只能在 macOS 环境执行；本环境验证的是 Linux Python 引擎（356 单测）+ C 声纹推理库 + Workers server 单测。
- **mygo-music website**：`@tanstack/solid-start` pin 到 2.0.0-rc.10（2.0 rc 系列中最新可用版本；rc.11 的 SSR 构建引用了 `start-server-core` 未发布的导出）。构建时会请求 GitHub API（latest release + 插件搜索），可设 `GH_TOKEN` 或 `GITHUB_TOKEN` 提高限额。
- **ffmpeg-skill**：纯 Python 标准库，无第三方依赖，但需要 FFmpeg ≥ 6.1 在 PATH 上。
