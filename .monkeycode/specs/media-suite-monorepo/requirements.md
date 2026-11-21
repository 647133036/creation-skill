# Requirements Document: media-suite-monorepo

## Introduction

将 6 个上游开源媒体创作项目整合为一个统一 monorepo 套件：

| # | 项目 | 上游 | 语言/运行时 | 功能 |
|---|------|------|------------|------|
| 1 | ffmpeg-skill | kajisho5/ffmpeg-skill | Python (stdlib only) + FFmpeg | 本地视频/音频编辑引擎，42 个工具，MCP server |
| 2 | gif-factory | WoYun520/gif-factory | Python + Pillow/NumPy + FFmpeg | GIF 表情包/海报/签名/片头/绘本 Agent Skill 合集 |
| 3 | cinecode | sarpstar/cinecode | Python + Node + three.js 无头渲染 + FFmpeg | 代码生成电影（短片/广告/解说/音乐视频）|
| 4 | claude-animated-shorts | mromidev/claude-animated-shorts | Remotion + three.js + Node + Python | 竖屏 2D/3D 动画短片制作 |
| 5 | cicada | wquguru/cicada | Swift 6 + Cloudflare Workers (JS) | 跨平台实时会议转写/双语字幕/同声传译 |
| 6 | mygo-music | egoist/mygo-music | Go + MyGo GUI + JS/TS 插件 | 原生桌面音乐播放器 |

改造目标：Python 子包基于 Python 3.15 改造；其余子包依赖全部升级到最新稳定版本。

## Glossary

- **Suite（套件）**: 本 monorepo 整体，含全部子包与共享工程设施
- **子包（package）**: monorepo 内一个上游项目对应的目录单元
- **Python 3.15 基线**: 所有 Python 代码以 CPython 3.15 为目标运行时
- **依赖最新版**: 各语言包管理器在改造时可解析到的最新稳定版本（排除 alpha/beta/rc 预发布）
- **上游保留（upstream fidelity）**: 子包功能、工具命名、对外接口与上游保持兼容

## Requirements

### R1: Monorepo 组织

**User Story:** AS 套件使用者, I want 在一个仓库里获得全部 6 个项目, so that 我可以统一克隆、构建和更新。

#### Acceptance Criteria

1. The suite SHALL 包含 6 个子包目录，每个子包保留上游的功能与相对目录结构。
2. The suite SHALL 在仓库根提供 README，说明各子包用途、语言栈与构建入口。
3. WHEN 子包间存在共享设施（lint 配置、CI、文档模板）, the suite SHALL 将其置于独立的共享目录而与子包代码隔离。

### R2: Python 3.15 改造

**User Story:** AS Python 开发者, I want 全部 Python 组件运行在 Python 3.15 上, so that 我可以使用最新语言特性与标准库。

#### Acceptance Criteria

1. The suite SHALL 使每个含 Python 代码的子包（ffmpeg-skill、gif-factory、cinecode、claude-animated-shorts）在 Python 3.15 解释器下通过其自带测试或冒烟验证。
2. The suite SHALL 为 Python 子包声明 `requires-python >= 3.15` 的包元数据。
3. IF Python 源码使用了 3.12+ 已弃用或已移除的 API, the suite SHALL 完成等效迁移并保持行为一致。

### R3: 依赖升级到最新稳定版

**User Story:** AS 维护者, I want 各子包依赖全部处于最新稳定版本, so that 我获得安全修复与新特性。

#### Acceptance Criteria

1. The suite SHALL 将 Go 子包（mygo-music）的全部依赖升级到最新稳定版本并通过 `go build ./...`。
2. The suite SHALL 将 Node/前端子包（claude-animated-shorts 的 Remotion 栈、cinecode 的渲染栈、mygo-music website）依赖升级到最新稳定版本。
3. The suite SHALL 将 Swift 子包（cicada）的 swift-tools-version 与平台要求保持在 Swift 6 工具链支持的最新状态。
4. The suite SHALL 将 gif-factory 的 Python 第三方依赖（Pillow、NumPy、SciPy）升级到支持 Python 3.15 的最新稳定版本。
5. IF 升级引入破坏性 API 变更, the suite SHALL 按新 API 改写调用代码并在验收记录中列出变更点。

### R4: 共享工程设施

**User Story:** AS CI 使用者, I want 一个统一的构建与测试入口, so that 一次命令可以验证全部子包。

#### Acceptance Criteria

1. The suite SHALL 提供顶层脚本（如 `make check` 或等价命令）逐个调用各子包的构建/测试。
2. WHEN 某子包缺少测试, the suite SHALL 记录该子包的验证方式（构建通过、CLI 冒烟）作为替代验收。
3. The suite SHALL 提供统一的 CODEOWNERS 式子包清单（packages manifest），列出名称、路径、语言、构建命令。

### R5: 许可与归属

**User Story:** AS 合规使用者, I want 保留各上游项目的许可与归属, so that 整合仓库可合法分发。

#### Acceptance Criteria

1. The suite SHALL 在每个子包目录保留上游 LICENSE 文件。
2. The suite SHALL 在根 README 与子包文档标注上游仓库地址与许可类型。

## Confirmed Decisions

1. **组织形态**: 仅物理组织。各子包独立使用原有命令，不新增统一 CLI；共享构建/测试/文档设施。
2. **gif-factory 素材**: 全量迁入（约 1.7GB 素材资产完整保留）。
3. **cicada 验证策略**: 代码迁入 + Swift 依赖声明升级到最新，Cloudflare Workers 部分本地验证，Swift GUI 构建留待 macOS 环境。
