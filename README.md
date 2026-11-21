# Media Suite

一个 monorepo 套件，整合 6 个上游媒体创作项目：本地视频编辑引擎、GIF 工厂、代码生成电影、竖屏动画短片、实时会议转写与同传、原生音乐播放器。

每个子包保持独立可用，保留上游目录结构与许可证；本仓库提供统一的环境说明、验证入口与共享工程设施。

## 子包一览

| 子包 | 语言/运行时 | 功能 | 许可 | 上游 |
|---|---|---|---|---|
| [packages/ffmpeg-skill](packages/ffmpeg-skill) | Python 3.15 (stdlib) + FFmpeg | 本地视频/音频编辑引擎，42 个工具，MCP server | MIT | kajisho5/ffmpeg-skill |
| [packages/gif-factory](packages/gif-factory) | Python 3.15 + Pillow/NumPy/SciPy | GIF 表情包/光栅卡/动态海报/签名/片头/绘本 Agent Skill 合集 | MIT | WoYun520/gif-factory |
| [packages/cinecode](packages/cinecode) | Python 3.15 + Node 22 | 代码生成电影：three.js 无头 Chrome 渲染 + FFmpeg 合成 | MIT | sarpstar/cinecode |
| [packages/claude-animated-shorts](packages/claude-animated-shorts) | Remotion + three.js | 竖屏 2D/3D 动画短片制作 Skill | MIT | mromidev/claude-animated-shorts |
| [packages/cicada](packages/cicada) | Swift 6 + Cloudflare Workers | 实时会议转写/双语字幕/同声传译 | Apache-2.0 | wquguru/cicada |
| [packages/mygo-music](packages/mygo-music) | Go + JS/TS 插件 | 原生桌面音乐播放器（无 WebView） | 见子包 | egoist/mygo-music |

各子包的上游 commit 记录在 [packages.json](packages.json)。

## 工具链基线

- Python: CPython 3.15（源码编译安装于 `/opt/python3.15`，全部 Python 子包以它为基线）
- Go: go1.25+
- Node: 22+
- bun: mygo-music 官网的构建与依赖安装（website 构建时会请求 GitHub API，可设 GH_TOKEN 提高限额）
- FFmpeg/ffprobe: 系统 PATH
- Swift: 6 工具链（cicada 的 macOS 构建在本仓库外的 Mac 环境执行）

## 验证

```bash
make check            # 全部子包
make check-ffmpeg-skill  # 单个子包
```

每个检查脚本给出 PASS / SKIP(原因) / FAIL 结果。

## 目录结构

```
packages/    6 个子包（保持上游结构）
tools/       顶层验证编排脚本
.monkeycode/ 规格文档（需求与技术设计）
```
