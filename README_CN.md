# Windows WezTerm 配置

[English](./README.md)

一套面向 Windows 的 [WezTerm](https://wezfurlong.org/wezterm/) 完整配置：包含六套可安装主题、Cmder/Clink 集成、实用的分屏与标签快捷键，以及可靠的中英文字体回退。**默认主题为 Ghostty Frappé。**

![WezTerm 中的 Ghostty Frappé 主题](./Ghostty.png)

## 核心特性

- 六套暗色主题，拥有不同配色与窗口外观
- 智能 `Ctrl+C`：有选区时复制，无选区时发送中断
- 右键粘贴，以及对齐 Windows Terminal 的分屏快捷键
- 粘贴时自动将 CRLF 转为 LF，避免远端终端或编辑器出现空行
- 中英文与符号字体回退
- 无边框标签栏，集成 Windows 窗口控制按钮

## 主题

| 主题 | 外观 |
|---|---|
| `ghostty-frappe` **（默认）** | 柔和的 Catppuccin Frappé 粉彩配色，紧凑、实色、无缝窗口外观 |
| `ghostty-frappe-pill` | Frappé 配色 + tmux 风格圆角胶囊标签，激活标签橙色高亮 |
| `ghostty-mocha` | 更深的 Catppuccin Mocha 黑紫配色，实色无缝窗口外观 |
| `iterm2-solarized-dark` | 低眩光青蓝 Solarized Dark，搭配克制的 Acrylic 模糊 |
| `luna-night` | 深紫色半透明 Acrylic |
| `tabby-darcula` | Tabby / JetBrains Darcula 实心暗色主题 |

> `ghostty-*` 和 `iterm2-*` 表示配色与外观来源。所有主题实际运行在 WezTerm 中，不是对应终端应用，也不代表它们在 macOS 上的默认主题。

## 安装

依赖：

- [WezTerm](https://wezfurlong.org/wezterm/) stable ≥ 20240101
- Python ≥ 3.10
- Git；也可以下载仓库 ZIP，并在解压目录中运行后续命令
- 推荐字体：Source Code Pro、JetBrains Mono 和 Microsoft YaHei；缺失字体会自动回退

> **Shell 路径：**所有主题会按以下顺序自动解析 Cmder：`WEZTERM_CMDER_INIT` → `CMDER_ROOT` → `where cmder` → 常见安装路径 → 普通 `cmd.exe`。把 Cmder 加入 `PATH`，或设置官方变量 `CMDER_ROOT`，即可启用 Clink/Cmder；都找不到时仍会正常启动普通 `cmd.exe`。若希望改用 PowerShell/WSL，请在安装前修改所选主题中的 `config.default_prog`。

```powershell
# 获取项目
git clone https://github.com/cloudy-liu/wezterm-config.git
cd wezterm-config

# 查看主题
python install_theme.py list

# 安装默认的 Ghostty Frappé 主题
python install_theme.py install

# 安装其他主题
python install_theme.py install luna-night

# 查看当前全局主题
python install_theme.py status
```

例如，PowerShell 7 可以将 `config.default_prog` 设为 `{ 'pwsh.exe', '-NoLogo' }`，WSL 可以设为 `{ 'wsl.exe' }`。

默认使用 copy 模式。安装前，脚本会将已有的 `%USERPROFILE%\.wezterm.lua` 备份为 `.wezterm.lua.bak-<时间戳>`。安装完成后，重新加载 WezTerm 或新开窗口即可生效。

如需让仓库修改立即生效，可以使用 link 模式；Windows 可能需要开启开发者模式或使用管理员权限。此时全局配置指向仓库中的主题文件，因此不要移动或删除仓库：

```powershell
python install_theme.py install ghostty-frappe --mode link
```

## 快捷键

| 快捷键 | 功能 |
|---|---|
| `Ctrl+C` | 有选区时复制，无选区时发送 `Ctrl+C` |
| `Ctrl+V` / 右键 | 粘贴剪贴板内容 |
| `Ctrl` + 左键 | 打开链接 |
| `Alt+Shift++` / `Alt+Shift+_` | 水平 / 垂直分屏 |
| `Alt+←/→/↑/↓` | 在分屏间切换 |
| `Alt+Shift+←/→/↑/↓` | 调整当前分屏大小 |
| `` Alt+` `` / `` Alt+Shift+` `` | 轮询下一个 / 上一个分屏 |
| `Ctrl+Shift+W` | 关闭当前分屏 |
| `Ctrl+B` / `Ctrl+Shift+R` | 重命名当前标签 |
| `Ctrl+Shift+←/→` | 左移 / 右移当前标签 |
| `Ctrl+Shift+T` | 新建标签 |

## 自定义

编辑 `themes/<主题名>.lua` 后，在 copy 模式下重新安装。link 模式会直接应用仓库中的修改。

- Shell：`config.default_prog`
- 字体：`config.font` 和 `config.font_rules`
- 配色：`config.color_schemes`
- 快捷键：`config.keys` 和 `config.mouse_bindings`

## 许可证

[MIT](./LICENSE)
