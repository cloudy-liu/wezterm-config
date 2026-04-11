# WezTerm Config

[English](#english) | [中文](#中文)

---

<a id="english"></a>

## English

A carefully tuned [WezTerm](https://wezfurlong.org/wezterm/) terminal configuration for Windows, inspired by **Tabby** and **JetBrains Darcula**.

### Highlights

- **Custom color scheme** `Tabby-JetBrains-Darcula` — dark theme with soft ANSI colors
- **CJK-aware font fallback chain** — Source Code Pro → JetBrains Mono → Consolas → Microsoft YaHei → Segoe UI Symbol → Noto Sans Symbols 2
- **Half-intensity text softening** — dimmed text renders in OneDark comment gray (`#5C6370`) instead of ultra-thin font weight
- **Smart Ctrl+C** — copies when text is selected, sends interrupt when nothing is selected
- **Copy toast** — "Copied" badge appears in the status bar for 2 seconds after copying
- **Right-click to paste** — just like Tabby
- **Ctrl + left-click** to open hyperlinks
- **Pane splits** — create, navigate, and resize panes with Windows Terminal-style shortcuts
- **Tab rename** — Ctrl+B or Ctrl+Shift+R
- **Centered tab titles** — with Windows admin prefix stripped
- **CRLF → LF paste fix** — prevents double-spacing when pasting into vim/git on remote machines
- **Integrated window buttons** — borderless title bar with min/max/close buttons

### Key Bindings

| Shortcut | Action |
|----------|--------|
| `Ctrl+B` / `Ctrl+Shift+R` | Rename current tab |
| `Ctrl+Shift+D` | Show debug overlay |
| `Ctrl+Shift+←/→` | Move tab left/right |
| `Ctrl+V` | Paste from clipboard |
| `Ctrl+C` | Copy selection / Send Ctrl+C |
| `Alt+Shift++` | Split pane horizontally |
| `Alt+Shift+_` | Split pane vertically |
| `Alt+←/→/↑/↓` | Navigate between panes |
| `Alt+Shift+←/→/↑/↓` | Resize pane |
| `Ctrl+Shift+W` | Close current pane |
| `Ctrl+Shift+T` | New tab |
| Right-click | Paste from clipboard |
| `Ctrl` + Left-click | Open hyperlink |

### Installation

**Option 1: Symlink (recommended)**

Open an elevated Command Prompt and run:

```cmd
mklink "%USERPROFILE%\.wezterm.lua" "C:\path\to\wezterm-config\.wezterm.lua"
```

**Option 2: Copy**

```powershell
copy C:\path\to\wezterm-config\.wezterm.lua %USERPROFILE%\.wezterm.lua
```

### Customization

- **Font**: Edit the `config.font` and `config.font_rules` sections
- **Color scheme**: Modify the `Tabby-JetBrains-Darcula` table in `config.color_schemes`
- **Shell**: Change `config.default_prog` to your preferred shell (e.g. PowerShell, WSL)
- **Key bindings**: Add or modify entries in `config.keys` and `config.mouse_bindings`

### Requirements

- [WezTerm](https://wezfurlong.org/wezterm/) nightly or stable ≥ 20240101
- Fonts installed: Source Code Pro, JetBrains Mono, Microsoft YaHei (optional but recommended)

### License

[MIT](LICENSE)

---

<a id="中文"></a>

## 中文

一套精心调校的 [WezTerm](https://wezfurlong.org/wezterm/) 终端配置，适配 Windows，灵感来自 **Tabby** 和 **JetBrains Darcula**。

### 功能亮点

- **自定义配色** `Tabby-JetBrains-Darcula` — 柔和暗色主题，ANSI 色彩舒适不刺眼
- **中英文字体回退链** — Source Code Pro → JetBrains Mono → Consolas → Microsoft YaHei → Segoe UI Symbol → Noto Sans Symbols 2
- **Half-intensity 文本柔和显示** — 暗淡文本使用 OneDark 注释灰（`#5C6370`），而非超细字重
- **智能 Ctrl+C** — 有选中内容时复制，无选中时发送中断信号
- **复制提示** — 复制后状态栏显示"已复制"徽标，2 秒后自动消失
- **右键粘贴** — 体验与 Tabby 一致
- **Ctrl + 左键** 打开超链接
- **分屏** — 创建、导航、调整分屏，快捷键对齐 Windows Terminal
- **Tab 重命名** — Ctrl+B 或 Ctrl+Shift+R
- **Tab 标题居中** — 自动去除 Windows 管理员前缀
- **CRLF → LF 粘贴修正** — 避免在远端 vim/git 中粘贴出现隔行空行
- **集成窗口按钮** — 无边框标题栏，保留最小化/最大化/关闭按钮

### 键绑定速查

| 快捷键 | 功能 |
|--------|------|
| `Ctrl+B` / `Ctrl+Shift+R` | 重命名当前标签 |
| `Ctrl+Shift+D` | 调试面板 |
| `Ctrl+Shift+←/→` | 左移/右移标签 |
| `Ctrl+V` | 粘贴 |
| `Ctrl+C` | 复制选中内容 / 发送 Ctrl+C |
| `Alt+Shift++` | 水平分屏 |
| `Alt+Shift+_` | 垂直分屏 |
| `Alt+←/→/↑/↓` | 切换分屏 |
| `Alt+Shift+←/→/↑/↓` | 调整分屏大小 |
| `Ctrl+Shift+W` | 关闭当前分屏 |
| `Ctrl+Shift+T` | 新建标签 |
| 右键 | 粘贴 |
| `Ctrl` + 左键 | 打开超链接 |

### 安装

**方式一：符号链接（推荐）**

以管理员身份打开命令提示符，运行：

```cmd
mklink "%USERPROFILE%\.wezterm.lua" "C:\path\to\wezterm-config\.wezterm.lua"
```

**方式二：手动复制**

```powershell
copy C:\path\to\wezterm-config\.wezterm.lua %USERPROFILE%\.wezterm.lua
```

### 自定义

- **字体**：修改 `config.font` 和 `config.font_rules` 部分
- **配色**：修改 `config.color_schemes` 中的 `Tabby-JetBrains-Darcula` 表
- **Shell**：修改 `config.default_prog` 为你喜欢的 Shell（如 PowerShell、WSL）
- **快捷键**：在 `config.keys` 和 `config.mouse_bindings` 中增删改

### 依赖

- [WezTerm](https://wezfurlong.org/wezterm/) nightly 或 stable ≥ 20240101
- 推荐安装字体：Source Code Pro、JetBrains Mono、Microsoft YaHei

### 许可证

[MIT](LICENSE)
