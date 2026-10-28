# ProvingGround 使用说明

更新：2026-10-27。

## 当前状态

- 引擎：UE 5.8.4 启动器二进制版，E:\UE\UE_5.8。
- 工程：Games → First Person → Blueprint → Arena Shooter。
- 路径：E:\ProvingGround\ProvingGround.uproject。
- 其他配置：Desktop、Maximum、光线追踪开启；其余保持默认。
- 用户已运行验证：WASD 移动、鼠标转视角正常。
- 编辑器源码编辑器仍为 Visual Studio Code。
- 用户已创建首个 C++ 类 ProvingGroundGameModeBase；当前工程的 VS Code 工作区、IntelliSense 和 C# 规则分析已配置。未改动用户源码、模板蓝图或游戏逻辑。
- 旧工程完整保留在 E:\ProvingGround_BlankOld；GDD 和两份说明已复制到新工程。

## 现在怎样使用

双击 ProvingGround.uproject，在 UE 中点击“运行”，点击游戏画面捕获鼠标后使用 WASD 和鼠标。模板默认打开 FirstPerson/Lvl_FirstPerson；Arena Shooter 的竞技场关卡位于 Content/Variant_Shooter/Lvl_ArenaShooter，可在内容浏览器中打开。

编辑 C++ 时打开当前工程的 ProvingGround.code-workspace；使用 Launch ProvingGroundEditor (Development) 配置按 F5，不使用旧备份工程的工作区。Development Editor 验收已通过：完整预检 9 个步骤、47.82 秒；随后 F5 构建检查成功（1.61 秒、无需增量编译），并自动打开 ProvingGround 的 Lvl_FirstPerson 场景。

## 当前 C++ 构建方式

先关闭 UE，在当前 ProvingGround.code-workspace 的“运行和调试”里选择 Launch ProvingGroundEditor (Development)，再按 F5。它会先调用 UBT 构建 Development Editor，再自动打开当前工程。这一步替代官方教程的“用 Visual Studio 编译”一节。

工作区已使用引擎自带 .NET 10 和专用 C# 规则解决方案。配置改动后，可运行“.NET: 重启语言服务器”应用，不主动重载整个 VS Code／Codex 窗口。安装、禁用扩展仍由用户手动操作。

首次外部构建被 Live Coding 拦截过，关闭 UE 后再构建；不要在编辑器仍运行时重复 F5 构建。完整步骤和当前验收状态见 EnvironmentSetup.md。

## 日志与版本控制

- 新工程启动仍出现 13 条 LogAutomationTest: Error: Condition failed，未尝试修复，原样记录在 EnvironmentSetup.md。
- 新 Git 仓库和本地 LFS hook 已初始化；Content 必须入库，缓存和编译产物忽略。
- .gitignore 来源：GitHub 官方 github/gitignore 的 UnrealEngine 模板；.ignore 是搜索工具规则，不能替代它。
- LFS 追踪 UE 资产及常见二进制素材，共 28 类，完整列表和来源见 EnvironmentSetup.md。
- 用户已确认 GDD 和两份说明全部纳入首次本地提交：约 157.22 MB，469 个文件，含 456 个 LFS 资产；不推送。

当前工作区的启动配置已简化为唯一入口 Launch ProvingGroundEditor (Development)，对应引擎的 UnrealEditor.exe；原始启动配置备份在 Saved/EnvironmentSetup/LaunchConfigurations-BeforeSimplifying.json。重新生成工作区可能恢复其他配置，届时仍需选择名称带 Editor 的 Development 项。

7 步环境配置与验收现已完成：C# 最新会话已加载专用规则项目，无 SDK 版本冲突或截图中的 C# 加载错误；Development Editor 的 F5 构建检查和自动打开场景已通过。本轮配置改动尚未另做 Git 提交。

## 当前 C++ 编辑功能：clangd

补全、跳转和诊断已配置为 clangd 22.1.0；微软 C/C++ 扩展保留，只关闭其 IntelliSense，F5 调试继续使用 cppvsdbg；编译继续使用 MSVC。

如先前禁用了 clangd，请手动选择“启用（工作区）”，然后运行 clangd: Restart language server，无需由 Codex 重载整个窗口。

在 ProvingGround.code-workspace 中使用 F5（Launch ProvingGroundEditor (Development)）或 Ctrl+Shift+B：先构建，再按需更新 clangd 编译数据库。新增/删除源码文件、修改 Build.cs、Target.cs 或插件/工程描述后会刷新；仅编辑现有代码正文时跳过刷新。新增反射类仍需构建成功，才能获得 UHT 生成头；已有编译错误需要先解决。无需每次让 Codex 修改配置。需要强制刷新时，仍可运行 Refresh clangd compilation database。

微软 C/C++ 的 IntelliSense、补全和红线均已关闭，保留 cppvsdbg 调试器，代码分析由 clangd 提供。重新生成 UE 工作区可能覆盖自定义任务，之后需核对 F5 的 preLaunchTask 是否仍为 Build ProvingGroundEditor and update clangd。

clangd 现在使用独立的响应文件副本（包含嵌套参数文件），避免 F5 的 MSVC 构建覆盖分析参数；并发数为 2。首次打开 UE 头文件仍需数秒预解析。若补全/快速修复持续卡住，先查看 clangd 输出和进程内存，再手动执行 clangd: Restart language server；不必重载整个 VS Code，也不要用屏蔽诊断代替定位问题。

当前源码诊断验证通过。clangd 与 MSVC 可能有诊断差异，最终构建以 UBT/UHT/MSVC 结果为准。GameModeBase 头文件的 SpecialMembers 自动重构自测有限制，详见 EnvironmentSetup.md；本次没有修改用户游戏代码或做 Git 提交。
