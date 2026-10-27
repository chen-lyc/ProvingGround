# ProvingGround 环境配置与重建记录

日期：2026-10-27（Asia/Shanghai）。当前为 First Person 蓝图工程；旧 Blank C++ 的验收记录保留在备份目录中。

## 工程与备份

- 新工程：`E:\ProvingGround\ProvingGround.uproject`。
- 完整旧工程：`E:\ProvingGround_BlankOld`，由用户完成目录改名，没有删除；旧提交 `8c48ece` 仍在旧仓库。
- 已复制 GDD 和两份环境说明；GDD 的 SHA256 与旧目录一致。没有复制旧 `.git`、`.vscode`、Source、构建产物或缓存。
- 未创建 C++ 类，未修改模板蓝图、输入配置或游戏逻辑。

## 模板和选项

依据 [Epic 官方教程的建工程部分](https://dev.epicgames.com/documentation/unreal-engine/coder-01-set-up-and-compile-a-cplusplus-project-in-unreal-engine)。后续创建 GameMode、Character 等 C++ 类的步骤由用户完成。

| 选项 | 实际结果 |
| --- | --- |
| 引擎 | Epic 启动器二进制版 UE 5.8.4，CL 58902052；E:\UE\UE_5.8 |
| 分类 / 模板 | Games / First Person |
| 工程类型 / 变体 | Blueprint / Arena Shooter（竞技场射击游戏模板） |
| 名称 / 位置 | ProvingGround / E:\ProvingGround |
| 目标平台 | Desktop，保存配置已确认 |
| 画质 | Maximum，保存配置已确认 |
| 光线追踪 | 开启，保存配置 r.RayTracing=True |
| 其余选项 | 用户按要求保留界面默认值，未额外添加内容包或安装组件 |

变体核对依据：引擎 Templates/TP_FirstPersonBP/Config/TemplateDefs.ini 中 ArenaShooter 对应 Weapons 和 Variant_Shooter 内容包；新工程包含二者，没有 Variant_Horror 目录。

模板默认启动地图为 /Game/FirstPerson/Lvl_FirstPerson；竞技场地图另位于 /Game/Variant_Shooter/Lvl_ArenaShooter。保持模板默认，没有代改地图或游戏模式。

## 验证

- 日志确认 UE 5.8.4-58902052+++UE5+Release-5.8 初始化成功，启动约 22.467 秒。
- 用户在编辑器中运行并确认：WASD 移动、鼠标转视角均正常。当前会话没有桌面操控工具，此项由用户操作验证。
- 编辑器偏好已核对：PreferredAccessor=VisualStudioCode。
- 新工程没有 Source 目录、C++ 模块或 VS Code 工作区，不沿用旧 C++ 工程的 F5 验收结果。
- **13 条 LogAutomationTest: Error: Condition failed 仍复现，未尝试修复。** 原日志如下：

```text
[2026.10.27-12.39.42:017][  0]LogAutomationTest: Error: Condition failed
[2026.10.27-12.39.42:017][  0]LogAutomationTest: Error: Condition failed
[2026.10.27-12.39.42:017][  0]LogAutomationTest: Error: Condition failed
[2026.10.27-12.39.42:017][  0]LogAutomationTest: Error: Condition failed
[2026.10.27-12.39.42:017][  0]LogAutomationTest: Error: Condition failed
[2026.10.27-12.39.42:017][  0]LogAutomationTest: Error: Condition failed
[2026.10.27-12.39.42:017][  0]LogAutomationTest: Error: Condition failed
[2026.10.27-12.39.42:017][  0]LogAutomationTest: Error: Condition failed
[2026.10.27-12.39.42:017][  0]LogAutomationTest: Error: Condition failed
[2026.10.27-12.39.42:017][  0]LogAutomationTest: Error: Condition failed
[2026.10.27-12.39.42:017][  0]LogAutomationTest: Error: Condition failed
[2026.10.27-12.39.42:017][  0]LogAutomationTest: Error: Condition failed
[2026.10.27-12.39.42:017][  0]LogAutomationTest: Error: Condition failed
```

原始日志：Saved/Logs/ProvingGround.log；提取记录：Saved/EnvironmentSetup/ConditionFailed-OriginalLines.log；资产校验清单：Saved/EnvironmentSetup/BlueprintTemplateAssets.json。这些记录位于 Saved，按规则不提交。

## 软件版本与安装路径

| 软件 | 实际版本 | 路径 |
| --- | --- | --- |
| Unreal Engine，Epic 启动器二进制版 | 5.8.4，CL 58902052 | `E:\UE\UE_5.8` |
| Epic Games Launcher | 20.3.6-0+UE5 | `C:\Program Files\Epic Games\Launcher` |
| Visual Studio Build Tools 2026 | 18.11.2，18.11.12324.101 | `C:\BuildTools\2026` |
| 本次使用的 MSVC | 产品版本 14.50.35739.0；cl.exe 文件版本 19.50.35739.0 | `C:\BuildTools\2026\VC\Tools\MSVC\14.50.35717` |
| Windows SDK | API 10.0.26100.0；rc.exe 修订版本 10.0.26100.9457 | `C:\Program Files (x86)\Windows Kits\10` |
| VS Code，x64 | 1.143.1 | `E:\vscode\Microsoft VS Code` |
| Git for Windows | 2.52.0.windows.1 | `E:\vscode\git\Git` |
| Git LFS | 3.7.1 | `E:\vscode\git\Git\mingw64\bin\git-lfs.exe` |
| 引擎内置 .NET SDK | 10.0.203 | `E:\UE\UE_5.8\Engine\Binaries\ThirdParty\DotNet\10.0\win-x64` |

MSVC 安装目录中的 `14.50.35717` 是工具集目录名；实际编译器已修订为 `14.50.35739`。版本以编译器产品信息和 UBT 构建日志为准。

另有 `14.51.36231` 工具集目录，由 Build Tools 一并安装；本次构建未使用它。

电脑原来已有 Visual Studio Community 2022 17.14.13，位于 `C:\Program Files\Microsoft Visual Studio\2022\Community`。本次保留原有安装，只新增独立 Build Tools，没有安装完整 Visual Studio IDE。

## VS Code 扩展

以下路径均相对于 `C:\Users\23242\.vscode\extensions`：

| 扩展 | 版本 | 安装目录 |
| --- | --- | --- |
| C/C++ Extension Pack | 1.5.1 | `ms-vscode.cpptools-extension-pack-1.5.1` |
| C/C++ | 1.34.4 | `ms-vscode.cpptools-1.34.4-win32-x64` |
| C# | 2.160.4 | `ms-dotnettools.csharp-2.160.4-win32-x64` |
| .NET Install Tool | 3.2.0 | `ms-dotnettools.vscode-dotnet-runtime-3.2.0` |
| CMake Tools | 1.24.42 | `ms-vscode.cmake-tools-1.24.42` |
| C++ Developer Tools | 0.6.18 | `ms-vscode.cpp-devtools-0.6.18` |
| C/C++ Themes | 2.0.0 | `ms-vscode.cpptools-themes-2.0.0` |



以上版本来自上一阶段的实际安装和构建核验，本次未重新安装或升级。MSVC 目录名 14.50.35717 与已修订编译器实际版本 14.50.35739 不同，以实际版本为准。原有完整 VS Community 安装保留，本次没有安装完整 IDE。

## 用户添加首个 C++ 类后再做

1. 用户自行按教程创建第一个 C++ 类；本次不代建。
2. 确认源码编辑器为 VS Code，执行 Tools > Refresh Visual Studio Code Project；也可用引擎 Build.bat 的 -projectfiles -project=... -game -engine -vscode 参数生成工作区。
3. 在新生成的 c_cpp_properties.json 中补充 Intermediate、Plugins、Source 的 includePath，保留编译命令配置。使用微软 C/C++ 默认 IntelliSense；旧文档中的 Engine Fallback 已被当前扩展移除。
4. 如果 C# 再次扫描整个引擎并报 AndroidPortForwarder / SwarmInterface 加载错误，为新工程重配 C# 默认解决方案与引擎内置 .NET 10 SDK。参考旧目录的 .vscode/ProvingGround.CSharp.slnx、ProvingGround.Rules.csproj 和旧工作区的 dotnet.server.environmentVariables，根据新工程实际规则文件重新核对。
5. 可为规则补全创建专供编辑器分析的 C# 项目，引用已安装引擎的 UBT 程序集；实际 C++ 编译仍由 UnrealBuildTool 完成。不要把旧工作区直接当成新工程配置。
6. 关闭 UE，在 VS Code 选择 Launch ProvingGroundEditor (Development)，按 F5 重新做 C++ 构建和编辑器启动验收。
7. Codex 在 VS Code 插件中运行时避免重载整个窗口。需要刷新 C# 时使用“.NET: 重启语言服务器”。安装、禁用扩展由用户手动操作。

## Git 与 LFS

新仓库独立初始化，分支 main；已对现有 Git LFS 执行 git lfs install --local。用户已确认：GDD 和两份环境说明全部纳入本次本地首次提交；不配置远程或推送。

.gitignore 依据 [GitHub 官方 UnrealEngine 模板](https://github.com/github/gitignore/blob/main/UnrealEngine.gitignore)，保留其规则，另加 /.ignore 排除搜索工具生成的配置。.ignore 本身不能控制 Git。Content 模板资产、Config 和 .uproject 纳入仓库；Binaries、Intermediate、Saved、DerivedDataCache 等生成目录忽略。

.gitattributes 按 [GitHub 官方 LFS 配置方式](https://docs.github.com/en/repositories/working-with-files/managing-large-files/configuring-git-large-file-storage) 设置 filter=lfs diff=lfs merge=lfs -text。该官方页面说明机制，未规定统一的 UE 文件清单；以下是本工程按二进制格式制定的追踪策略。资产、关卡和配置文件的版本控制范围另参照 [Epic 官方说明](https://dev.epicgames.com/documentation/en-us/unreal-engine/using-source-control-in-the-unreal-editor)。

- UE 资产：.uasset、.umap、.ubulk、.uexp、.uptnl。
- 模型及创作文件：.fbx、.blend、.psd、.psb。
- 图像：.tga、.png、.jpg、.jpeg、.tif、.tiff、.bmp、.exr、.hdr、.dds。
- 音频：.wav、.mp3、.ogg、.flac。
- 视频：.mp4、.mov、.avi。
- 字体：.ttf、.otf。

共 28 类，模式按列出的扩展名匹配。当前 Content 含 454 个 .uasset、2 个 .umap 和 2 个 .ini。二进制资产原始大小 157,155,990 字节；.ini 使用普通 Git 文本。首次提交前已列出候选大小并获用户确认：全部内容约 157.22 MB，469 个文件（含 456 个 LFS 资产，大小包含 LFS 原始资产，不只计算指针文件）。

