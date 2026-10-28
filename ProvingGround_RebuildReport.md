# ProvingGround 第一人称模板重建报告

日期：2026-10-27。以下区分“重建任务完成时的结果”和之后用户添加首个 C++ 类产生的变化。

## 重建结果

| 项目 | 实际结果 |
| --- | --- |
| 引擎 | Epic 启动器二进制版 UE 5.8.4，CL 58902052 |
| 引擎路径 | E:\UE\UE_5.8 |
| 分类 / 模板 | Games / First Person |
| 创建时类型 / 变体 | Blueprint / Arena Shooter |
| 项目名 / 路径 | ProvingGround / E:\ProvingGround |
| 平台 / 画质 | Desktop / Maximum |
| 光线追踪 | 开启 |
| 其他选项 | 保持创建界面默认值，未额外安装内容包或开发组件 |
| IDE | Visual Studio Code + MSVC Build Tools；未安装新的完整 Visual Studio IDE |

建工程依据：[Epic 官方教程 Start From a Template](https://dev.epicgames.com/documentation/unreal-engine/coder-01-set-up-and-compile-a-cplusplus-project-in-unreal-engine)。模板保留默认启动地图 FirstPerson/Lvl_FirstPerson；竞技场地图另在 Variant_Shooter/Lvl_ArenaShooter，没有代改地图、蓝图、输入或玩法逻辑。

## 旧文件保护

- 旧工程完整保存在 E:\ProvingGround_BlankOld，没有删除；旧仓库提交 8c48ece 保留在旧目录。
- GDD 和两份环境说明已复制到新工程根目录，说明已按新工程状态更新。
- GDD 文件 SHA256 与旧目录一致：5AFF7F72BC52449472CEB782C3B34DED674D4A5A67AFA2EB705DEFA31A1267A4。
- 未把旧 Source、旧工作区、旧 Git 仓库、编译产物或缓存复制到新工程。

## 验证结果

- 用户在编辑器中运行，确认 WASD 移动和鼠标转视角均正常。
- 编辑器源码编辑器仍为 VisualStudioCode。
- 启动日志确认 UE 5.8.4 初始化成功。
- 13 条错误在新工程中仍复现，未尝试修复：`LogAutomationTest: Error: Condition failed`。逐行原文见 EnvironmentSetup.md 和 Saved/EnvironmentSetup/ConditionFailed-OriginalLines.log。
- 重建任务完成时没有 C++ 源码或 VS Code 工作区，没有代建 GameMode、Character 等类。

## Git 与 LFS

.gitignore 基于 [GitHub 官方 UnrealEngine 模板](https://github.com/github/gitignore/blob/main/UnrealEngine.gitignore)，补充排除搜索工具生成的 /.ignore；.ignore 不能替代 Git 规则。Content 的 458 个文件均纳入首提，缓存和编译产物排除。

LFS 使用 [GitHub 官方配置方式](https://docs.github.com/en/repositories/working-with-files/managing-large-files/configuring-git-large-file-storage)，通过 .gitattributes 设置 filter=lfs diff=lfs merge=lfs -text。具体文件类型是本工程按 UE 资产与常见二进制素材制定的策略，不是官方发布的统一 UE LFS 清单。

共追踪 28 类：

- UE 资产：.uasset、.umap、.ubulk、.uexp、.uptnl。
- 模型及创作文件：.fbx、.blend、.psd、.psb。
- 图片：.tga、.png、.jpg、.jpeg、.tif、.tiff、.bmp、.exr、.hdr、.dds。
- 音频：.wav、.mp3、.ogg、.flac。
- 视频：.mp4、.mov、.avi。
- 字体：.ttf、.otf。

首次提交前已列出文件大小，并获得用户“GDD 和两份说明全部纳入，并提交”的确认。

| 首次提交项目 | 结果 |
| --- | --- |
| 分支 / 提交 | main / 4c6ed1a |
| 提交说明 | Initialize ProvingGround First Person Arena Shooter blueprint project |
| 文件总数 | 469 |
| 原始内容总大小 | 157,223,976 字节，约 157.22 MB，含 LFS 原始资产 |
| LFS 资产 | 456 个：454 个 .uasset、2 个 .umap |
| LFS 原始数据大小 | 157,155,990 字节 |
| GDD / 两份环境说明 | 全部纳入 |
| 完整性检查 | Git LFS fsck OK |
| 提交范围 | 本次仅本地提交，没有执行 push |

## 后续状态（不属于重建首提）

- 用户后来已自行创建 ProvingGroundGameModeBase；新增 Source、.uproject 修改及 VS Code 配置尚未提交，当前工作区有未提交改动。
- 当前已另行配置 origin=https://github.com/chen-lyc/ProvingGround.git；本次报告过程没有推送。
- 当前工程的工作区、IntelliSense 和 C# 规则配置已重建。Development Editor 构建预检 9 步成功，耗时 47.82 秒；C# 规则检查 0 错误、0 警告。构建预检不直接当作 F5 验收。
- 用户重新打开工作区后，21:39 的 C# 日志确认已使用引擎内置 .NET 10，并成功加载 ProvingGround.Rules.csproj，没有再出现此前的加载错误。
- 最新启动日志显示模块 UnrealEditor-ProvingGround.dll 已加载、编辑器初始化完成；完整 F5 验收记录仍需结合用户启动确认，详见 EnvironmentSetup.md。
- 官方教程中“用 Visual Studio 编译”的步骤已改为当前工程的 Development Editor / F5 流程；不会安装完整 Visual Studio。
- 本报告为本次新生成文件，未自动追加提交。
