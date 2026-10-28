# ProvingGround 环境配置与重建记录

日期：2026-10-27（Asia/Shanghai）。当前由 First Person 蓝图模板起步，用户已自行添加首个 C++ GameModeBase；旧 Blank C++ 的验收记录保留在备份目录中。

## 工程与备份

- 新工程：`E:\ProvingGround\ProvingGround.uproject`。
- 完整旧工程：`E:\ProvingGround_BlankOld`，由用户完成目录改名，没有删除；旧提交 `8c48ece` 仍在旧仓库。
- 已复制 GDD 和两份环境说明；GDD 的 SHA256 与旧目录一致。没有复制旧 `.git`、`.vscode`、Source、构建产物或缓存。
- 首个 C++ 类 ProvingGroundGameModeBase 由用户自行创建。本次环境配置未增改游戏源码、模板蓝图、输入配置或游戏逻辑。

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
- 用户添加首个类后已有 Source 目录和 Runtime 模块；VS Code 工作区已为当前工程重新生成。7 个源码文件的初始哈希已保存并核对不变。F5 必须对当前工程单独验收，不能沿用旧 Blank 工程的结果。
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

## 用户添加首个 C++ 类后的 7 步执行记录

1. **用户已完成**：自行创建 ProvingGroundGameModeBase，头文件位于 Source/ProvingGround/Public，实现文件位于 Private。本次未增改这 7 个游戏模块与规则源码文件。
2. **已完成**：源码编辑器仍为 Visual Studio Code；使用 UE 5.8.4 Build.bat 的 -projectfiles -project=E:\ProvingGround\ProvingGround.uproject -game -engine -vscode 参数重新生成工作区，返回 Succeeded，耗时 7.20 秒。
3. **已完成，后按用户要求切换到 clangd**：保留 UBT 生成的 MSVC 与 includePath 配置；当前语言功能由 clangd 22.1.0 提供，工作区和工程设置均为 clangd.enable=true、C_Cpp.intelliSenseEngine=disabled。微软 C/C++ 扩展继续提供 cppvsdbg 调试，实际构建仍为 MSVC。
4. **已完成并应用**：新窗口日志复现系统 .NET 9 无法分析 net10.0 的 NETSDK1045。工作区现指向引擎内置 .NET 10 SDK，默认 C# 解决方案设为 .vscode/ProvingGround.CSharp.slnx。用户手动重开工作区后，新日志确认配置生效，规则项目加载成功。需要后续刷新时可使用“.NET: 重启语言服务器”。
5. **已完成**：专供编辑器分析的 ProvingGround.Rules.csproj 引用已安装引擎的 UBT 程序集，覆盖当前工程及插件的 Build.cs 和 Target.cs；独立编译检查为 0 错误、0 警告。实际 C++ 编译仍由 UnrealBuildTool 完成。没有复制旧工作区替代新工作区。
6. **F5 验收已通过**：用户选择 Launch ProvingGroundEditor (Development) 并按 F5，终端截图确认执行 ProvingGroundEditor Win64 Development Build，返回 Result: Succeeded，耗时 1.61 秒、0 个增量编译动作；随后用户截图确认 ProvingGround 编辑器已自动打开 Lvl_FirstPerson 场景。此前完整命令行预检的 9 个编译链接步骤耗时 47.82 秒。官方教程的“用 Visual Studio 编译”一节由此 VS Code F5 流程替代。
7. **已遵守**：没有重载当前 VS Code／Codex 窗口，没有安装或禁用扩展；相关操作由用户手动完成。

验证记录：Saved/EnvironmentSetup/CppWorkspaceGeneration.log、CppRulesAnalysisValidation.log、FirstCppBuildPreflight.log、AfterFirstClassSourceHashes.json。首次预检被正在运行的 Live Coding 拦截，原日志保存在 CppBuildPreflight-LiveCodingBlocked.log；用户关闭 UE 后重新预检。

构建提示：用户生成的 Editor.Target.cs 当前为 Unreal5_6 兼容包含顺序；UBT 建议 Unreal5_8。该提示不表示引擎版本变为 5.6。本次保持用户源码不动，不为消除提示修改规则文件。

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

## 当前扩展弹窗处理状态

工作区设置文件及工程 .vscode/settings.json 均已指定专用 C# 解决方案和引擎内置 .NET 10 环境。磁盘路径与 SDK 已验证。用户重新打开工作区后，2026-10-27 21:39 的新日志确认使用引擎内置 .NET 10，并成功加载 ProvingGround.Rules.csproj；本轮日志未再出现原来的 C# 加载错误。

后续用户已明确要求改用 clangd：当前配置改为 clangd.enable=true，并只关闭微软 IntelliSense。微软 C/C++ 扩展需保持启用，以保留 F5 的 cppvsdbg 调试器；如之前手动禁用了 clangd，用户需手动在当前工作区重新启用。

## clangd 切换记录（2026-10-27）

本次仅切换代码补全、跳转、语义诊断。实际编译仍由 UBT 调用 MSVC 14.50.35739，F5 的 cppvsdbg 启动配置保持原样。没有安装软件、没有代为启用或禁用扩展、没有修改用户游戏源码、蓝图或工程逻辑。

- 现有 clangd 可执行文件版本：22.1.0；VS Code 扩展 llvm-vs-code-extensions.vscode-clangd 0.6.0。
- 工程 .vscode/settings.json 和 ProvingGround.code-workspace 同时设置 clangd.enable=true、C_Cpp.intelliSenseEngine=disabled，避免不同作用域互相覆盖。
- clangd.arguments 指向 E:/ProvingGround/.vscode/clangd 编译数据库，header-insertion=never，防止自动补全插入 include 干扰 UE 生成头的包含顺序。
- 使用 UE 自带 UBT GenerateClangDatabase 模式生成标准 compile_commands.json，显式沿用 VisualStudio2026 工具链；筛选本工程 Source 和 Plugins 源文件，不编译引擎源码。
- clangd 默认模拟的 MSVC 版本为 19.33，低于 UE 最低要求，最初检查因此报静态断言。刷新脚本读取已安装 cl.exe 的版本，将 /clang:-fms-compatibility-version=19.50 只追加到 JSON 分析命令，不修改 UBT 的真实编译响应文件，也不改变实际编译器。
- VS Code 的 F5 预启动任务和默认构建任务现为 Build ProvingGroundEditor and update clangd，依次运行 Development Editor 构建与 Update clangd if needed。刷新脚本通过源码文件列表、Build.cs/Target.cs、插件/工程描述及工具配置的指纹判断是否需要更新，并校验数据库哈希；普通代码正文修改跳过刷新。构建失败时不继续刷新或启动。手动任务 Refresh clangd compilation database 仍可强制刷新。UE 重新生成工作区可能覆盖自定义任务，届时需核对预启动任务。
- 数据库和 clangd 索引是本地生成数据，.vscode/clangd/ 已加入 .gitignore；刷新脚本可纳入版本控制，本次没有代做提交。

2026-10-28 修正：原数据库引用了正常 MSVC 构建也会改写的响应文件。构建后 clangd 会意外读到 SharedPCH.UnrealEd，现场出现约 17 GB 内存占用、单次预解析 172–205 秒、快速修复请求等待约 396 秒后取消。刷新脚本现递归保存独立的响应文件副本（含嵌套 Shared.rsp），并校验副本哈希；UBT 原始输出先写入临时数据库，处理完成后再替换正式数据库。实际 MSVC 构建选项不变。clangd 并发限制为 -j=2，以减少同时解析多个 UE 文件时的资源争用。用户已手动重启 clangd，无需重载 VS Code。

修正后验证：3 个编译单元引用 4 份独立响应文件，包含嵌套引用，均不含 MSVC 的 SharedPCH/Yu/Fp 参数；重复刷新能正确跳过。Character 头文件解析为 0 错误，预解析约 5–8 秒（冷启动）；重启后 VS Code 实际日志已有约 122–182 毫秒的补全响应、0–219 毫秒的快速修复响应。这些是服务端响应时间，不等于完整界面显示延迟；本次未重新执行完整 F5 构建或修改用户游戏源码。

同日下午继续排查：ULocalPlayer 的具体诊断为 incomplete type，当前使用 ULocalPlayer::GetSubsystem 的 .cpp 缺少 Engine/LocalPlayer.h；用户自行补上后，独立语言服务器检查为 0 错误，补全能返回 GetSubsystem。现场日志记录包含区反复修改时预解析约 5–17 秒、部分快速修复等待约 30 秒后取消。稳定状态 clangd 约占 0.7 GB，系统约有 14 GB 可用内存，没有复现先前的 17 GB 异常。独立 LSP 对照测量（仅使用内存缓冲，不改源码）：最后一次磁盘缓存测试初次分析约 7 秒、补全 196 毫秒、正文编辑后快速修复 262 毫秒；内存缓存对应约 7.9 秒、203 毫秒、263 毫秒，未显示稳定收益，因此未修改缓存配置。此前初次分析另有 14–19 秒样本，冷分析与包含区变化仍存在明显延迟，不能把热缓存响应时间当成所有场景均已解决。测试脚本和记录位于 Saved/EnvironmentSetup/PerformanceResearch/localplayer-lsp-probe*。

验证结果：两个实际 .cpp 文件及引擎 CoreMinimal.h 的完整 clangd --check 均为 0 错误；用户 GameModeBase 头文件的完整解析、AST 构建与语义诊断也为 0 错误。

已知限制：头文件完整 --check 会在遍历代码操作时，对 UE GENERATED_BODY 展开的成员触发 7 条 SpecialMembers / Class body in wrong file 自测失败。它们来自自动生成特殊成员函数的重构动作，不是 C++ 语义诊断。单独以 --check-locations=false 检查解析得到 0 错误；没有在日常运行配置中隐藏诊断或关闭重构功能。该类自动重构动作不应视为已通过验证，使用前需检查预览。原始失败与单独解析日志均保留。

clangd 使用 Clang 解析器，实际编译使用 MSVC，两者诊断可能不同，尤其是 MSVC 扩展、UE 反射宏和未更新的生成头。因此 clangd 无红线不能代替 UBT/UHT/MSVC 构建；遇到疑似误报先刷新编译数据库并检查实际构建结果，不盲目修改游戏代码以迎合分析器。

来源：[clangd 编译参数](https://clangd.llvm.org/design/compile-commands)、[clangd 配置](https://clangd.llvm.org/config)、[clangd 自诊断实现](https://github.com/llvm/llvm-project/blob/main/clang-tools-extra/clangd/tool/Check.cpp)。验证日志均在 Saved/EnvironmentSetup/Clangd 下。
