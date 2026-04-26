# 🐱 WezTerm Config
[English](./README.md)

![Demo](./demo.png)

一个开箱即用的 [WezTerm](https://wezfurlong.org/wezterm/) 终端配置，专为 Windows 用户打造。

从 Tabby 转过来？这个配置已经帮你把最常用的习惯都对齐了。

---

## 😫 解决了什么问题

WezTerm 默认配置在很多地方对 Windows 用户不太友好，这个配置逐一修掉了这些痛点：

| 问题 | 这个配置怎么做 |
|------|---------------|
| 粘贴到远端 vim/git commit 会出现隔行空行 | 自动将 CRLF 转为 LF |
| 中文显示乱码或回退到难看的字体 | 6 级字体回退链，中英文都有合适字形 |
| AI 工具（Cursor Thinking 等）的暗淡文字太细看不清 | Half-intensity 文本用 OneDark 注释灰显示，不用 ExtraLight 字重 |
| 关窗口每次都要确认 | 关闭窗口确认弹窗已关闭 |
| 没有右键粘贴 | 右键粘贴，和 Tabby 一样 |
| Ctrl+C 要么只复制要么只中断，不能兼得 | 有选中 → 复制 + 显示"已复制"提示；没选中 → 发送 Ctrl+C 中断 |
| 分屏操作没有顺手快捷键 | 对齐 Windows Terminal：Alt+方向键导航、Alt+Shift+方向键调整大小 |
| Tab 不能重命名 | Ctrl+B 或 Ctrl+Shift+R 重命名 |
| 管理员模式 Tab 标题带"管理员:"前缀，太长 | 自动去除 |
| 标题栏占空间 | 无系统标题栏，集成按钮在 Tab 栏右侧 |
| 缺字弹窗烦人 | 关闭缺字警告 |
| 绿色太暗或太亮 | ANSI 绿色调为翡翠绿，不刺眼也不看不清 |

## ✨ 功能一览

- **配色** — 自定义 `Tabby-JetBrains-Darcula` 暗色主题
- **字体** — Source Code Pro → JetBrains Mono → Consolas → Microsoft YaHei → Segoe UI Symbol → Noto Sans Symbols 2
- **智能 Ctrl+C** — 选中时复制 + 状态栏"已复制"提示（2 秒后消失），未选中时发送中断
- **右键粘贴** — 和 Tabby 一样
- **分屏** — 对齐 Windows Terminal 快捷键（创建/导航/调整/关闭）
- **Tab 管理** — 重命名、移动、标题居中、去除管理员前缀
- **无边框标题栏** — 集成最小化/最大化/关闭按钮
- **CRLF → LF 粘贴修正** — 远端 shell 不再隔行
- **光标不闪烁** — SteadyBar 样式，减少视觉干扰
- **滚动条** — 默认开启，方便拖拽浏览历史输出

## ⌨️ 快捷键

### 🏷️ Tab 管理

| 快捷键 | 功能 |
|--------|------|
| `Ctrl+B` / `Ctrl+Shift+R` | 重命名当前 Tab |
| `Ctrl+Shift+←/→` | 左移/右移 Tab |
| `Ctrl+Shift+T` | 新建 Tab |

### 🪟 分屏

| 快捷键 | 功能 |
|--------|------|
| `Alt+Shift++` | 水平分屏 |
| `Alt+Shift+_` | 垂直分屏 |
| `Alt+←/→/↑/↓` | 在分屏间切换 |
| `Alt+Shift+←/→/↑/↓` | 调整分屏大小 |
| `Ctrl+Shift+W` | 关闭当前分屏 |

### 📋 复制粘贴

| 快捷键 | 功能 |
|--------|------|
| `Ctrl+C` | 复制选中内容 / 无选中时发送 Ctrl+C |
| `Ctrl+V` | 粘贴 |
| 右键 | 粘贴 |
| `Ctrl` + 左键 | 打开链接 |

### 🔧 其他

| 快捷键 | 功能 |
|--------|------|
| `Ctrl+Shift+D` | 调试面板 |

## 📦 安装

### 🔗 一键安装（推荐）

以管理员身份打开命令提示符，创建符号链接：

```cmd
mklink "%USERPROFILE%\.wezterm.lua" "你本地的路径\wezterm-config\.wezterm.lua"
```

这样配置文件和仓库保持同步，`git pull` 即可更新。

### 📂 手动复制

```powershell
copy 你本地的路径\wezterm-config\.wezterm.lua %USERPROFILE%\.wezterm.lua
```

> 安装后首次打开 WezTerm 即生效，无需额外操作。

## 🔧 自定义

配置文件中有清晰的分区注释，按需修改即可：

- **Shell** — 修改 `config.default_prog`（当前默认 cmd.exe + Cmder，可改为 PowerShell 或 WSL）
- **字体** — 修改 `config.font` 和 `config.font_rules`
- **配色** — 修改 `config.color_schemes` 中的 `Tabby-JetBrains-Darcula`
- **快捷键** — 在 `config.keys` 和 `config.mouse_bindings` 中增删改

## 📋 依赖

- [WezTerm](https://wezfurlong.org/wezterm/) stable ≥ 20240101
- 推荐安装字体：Source Code Pro、JetBrains Mono、Microsoft YaHei（不装也能用，会回退到后续字体）

## 📄 许可证

[MIT](./LICENSE)
