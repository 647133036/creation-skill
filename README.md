# Media Suite

4 个媒体创作工具整合在一个 monorepo 里，覆盖视频编辑、动态图合成、代码生成电影、动画短片。每个子包独立可用，保留上游目录结构与许可证；本仓库提供统一的环境基线、验证入口与共享工程设施。

## 子包一览

| 子包 | 能做什么 | 技术栈 | 上游 |
|---|---|---|---|
| [packages/ffmpeg-skill](packages/ffmpeg-skill) | 给 coding agent 本地视频/音频编辑器：裁剪、拼接、转码、字幕烧录、音频分离等 42 个工具。无云、无 API key，agent 自己检查输出。 | Python 3.15（纯标准库）+ FFmpeg 9 | kajisho5/ffmpeg-skill |
| [packages/gif-factory](packages/gif-factory) | GIF 表情包、光栅变画卡、动态海报、动态签名、电影片头、动态绘本、品牌短片。有素材就能合成，不需要文生图模型。 | Python 3.15 + Pillow / NumPy / SciPy | WoYun520/gif-factory |
| [packages/cinecode](packages/cinecode) | 代码生成电影：AI 写剧本，three.js 在无头 Chrome 逐帧渲染 3D 场景，FFmpeg 合成 MP4。短片、长视频、广告、解说、MV。 | Python 3.15 + Node 22 + three.js + FFmpeg | sarpstar/cinecode |
| [packages/claude-animated-shorts](packages/claude-animated-shorts) | 竖屏 55–70s 动画故事短片：2D 角色 + 彩色 3D 世界，墨线轮廓、镜头运动、配乐音效。纯本地渲染，不用 AI 视频生成器。 | Remotion 4.0.545 + three.js + Node 22 + Python 3.15 | mromidev/claude-animated-shorts |

各子包的上游 commit 记录在 [packages.json](packages.json)。

## 工具链基线

| 工具 | 版本 | 说明 |
|---|---|---|
| Python | CPython 3.15.2 | 源码编译安装于 `/opt/python3.15`，全部 Python 子包以它为基线 |
| FFmpeg / ffprobe | 9.0.2 | 系统 PATH，BtbN 静态构建 |
| Node.js | 22 | cinecode、claude-animated-shorts |

## 验证

```bash
make check                # 全部 4 个子包
make check-ffmpeg-skill   # 单个子包
# …
```

每个检查脚本给出 `PASS` / `SKIP(原因)` / `FAIL`。

当前 `make check` 全部通过（Python 3.15.2 + FFmpeg 9.0.2 + Node 22）。

## 目录结构

```
packages/       4 个子包（保持上游结构）
tools/          顶层验证编排脚本
.monkeycode/    规格文档（需求与技术设计）
.github/        CI workflow（GitHub Actions 跑全量 check）
packages.json   子包 manifest（名称、语言、上游 commit、构建/测试命令）
```

## 已知限制

- **ffmpeg-skill**：纯 Python 标准库，无第三方依赖，但需要 FFmpeg ≥ 6.1 在 PATH 上。
