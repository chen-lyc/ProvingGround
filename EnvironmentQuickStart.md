# ProvingGround 使用说明

更新：2026-10-27。

## 当前状态

- 引擎：UE 5.8.4 启动器二进制版，E:\UE\UE_5.8。
- 工程：Games → First Person → Blueprint → Arena Shooter。
- 路径：E:\ProvingGround\ProvingGround.uproject。
- 其他配置：Desktop、Maximum、光线追踪开启；其余保持默认。
- 用户已运行验证：WASD 移动、鼠标转视角正常。
- 编辑器源码编辑器仍为 Visual Studio Code。
- 没有 C++ 源码、VS Code 工作区，也没有修改模板蓝图或游戏逻辑。
- 旧工程完整保留在 E:\ProvingGround_BlankOld；GDD 和两份说明已复制到新工程。

## 现在怎样使用

双击 ProvingGround.uproject，在 UE 中点击“运行”，点击游戏画面捕获鼠标后使用 WASD 和鼠标。模板默认打开 FirstPerson/Lvl_FirstPerson；Arena Shooter 的竞技场关卡位于 Content/Variant_Shooter/Lvl_ArenaShooter，可在内容浏览器中打开。

暂不使用旧工作区按 F5，也不为生成工作区而代建 C++ 类。

## 用户创建第一个 C++ 类后

刷新 VS Code 项目，重新生成工作区；核对 IntelliSense includePath 和编译命令。若 C# 再报引擎工具加载问题，再为新工程配置内置 .NET 10 和规则分析项目。旧目录中保留了修复配置作为参考，不能直接套用旧工作区。随后关闭 UE，用 Development Editor 的 F5 重新验收。具体步骤、版本与路径见 EnvironmentSetup.md。

Codex 在 VS Code 插件中运行时，不主动重载整个窗口；刷新 C# 可使用“.NET: 重启语言服务器”。安装、禁用扩展由用户手动操作。

## 日志与版本控制

- 新工程启动仍出现 13 条 LogAutomationTest: Error: Condition failed，未尝试修复，原样记录在 EnvironmentSetup.md。
- 新 Git 仓库和本地 LFS hook 已初始化；Content 必须入库，缓存和编译产物忽略。
- .gitignore 来源：GitHub 官方 github/gitignore 的 UnrealEngine 模板；.ignore 是搜索工具规则，不能替代它。
- LFS 追踪 UE 资产及常见二进制素材，共 28 类，完整列表和来源见 EnvironmentSetup.md。
- 用户已确认 GDD 和两份说明全部纳入首次本地提交：约 157.22 MB，469 个文件，含 456 个 LFS 资产；不推送。

