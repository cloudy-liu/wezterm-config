-- 全局 WezTerm 配置（Windows 上通常可写作 ~/.wezterm.lua，~ 对应当前用户目录）
local wezterm = require 'wezterm'
local act = wezterm.action

-- 使用 config_builder：报错更清晰、默认项更完整
local config = wezterm.config_builder()

-- ============================================================================
-- 基础：启动/字体/光标
-- ============================================================================

-- Windows 路径建议用双反斜杠 \\ 或单斜杠 /
config.default_prog = { 'cmd.exe', '/k', 'D:/tools/cmder_full/cmder/vendor/init.bat' }

config.font = wezterm.font_with_fallback({
    'Source Code Pro',
    'JetBrains Mono',
    'Consolas',
    'Microsoft YaHei',
    'Segoe UI Symbol',  -- Windows 符号字体，覆盖更多 Unicode 字符
    'Noto Sans Symbols 2',  -- 如果安装了 Noto 字体
})

-- 尽量贴近 Windows Terminal 的 faint 处理：
-- 对所有 Intensity=Half 的文本保持正文同一套字重，并将前景色弱化成
-- 接近 OneDark 注释灰。当前主要用于改善 Cursor Thinking 文本的观感，
-- 避免默认 ExtraLight 看起来过于发虚。
config.font_rules = {
    {
        intensity = 'Half',
        italic = false,
        font = wezterm.font_with_fallback(
            {
                { family = 'Source Code Pro', weight = 'Regular' },
                { family = 'JetBrains Mono', weight = 'Regular' },
                { family = 'Consolas', weight = 'Regular' },
                'Microsoft YaHei',
                'Segoe UI Symbol',
                'Noto Sans Symbols 2',
            },
            { foreground = '#5C6370' }
        ),
    },
    {
        intensity = 'Half',
        italic = true,
        font = wezterm.font_with_fallback(
            {
                { family = 'Source Code Pro', weight = 'Regular', style = 'Italic' },
                { family = 'JetBrains Mono', weight = 'Regular', style = 'Italic' },
                { family = 'Consolas', weight = 'Regular', style = 'Italic' },
                'Microsoft YaHei',
                'Segoe UI Symbol',
                'Noto Sans Symbols 2',
            },
            { foreground = '#5C6370' }
        ),
    },
}
config.font_size = 12.0

-- 关闭字体缺字警告弹窗（某些特殊字符找不到字形时不再提示）
config.warn_about_missing_glyphs = false

-- ============================================================================
-- 粘贴修复：Windows 剪贴板通常是 CRLF；远端 (vim/git commit 等) 可能表现为"隔行多空行/多很多行"
-- 将粘贴文本中的换行统一规范化为 LF（推荐）
-- 参考：https://wezterm.org/config/lua/config/canonicalize_pasted_newlines.html
-- ============================================================================
config.canonicalize_pasted_newlines = "LineFeed"

-- 关闭确认（窗口）：WezTerm 目前不支持"只提示一次然后记住"的交互。
-- 注意：window_close_confirmation 只影响"通过窗口系统关闭窗口"（点右上角 X 关窗口等），
-- 不影响"关闭 Tab/Pane"时的确认。
-- - 'NeverPrompt': 从不提示
-- - 'SmartPrompt': 智能提示
-- - 'AlwaysPrompt': 总是提示
config.window_close_confirmation = 'NeverPrompt'


-- ============================================================================
-- 配色：scheme + tab/titlebar 颜色
-- ============================================================================

config.color_schemes = {
    ['Tabby-JetBrains-Darcula'] = {
        foreground = '#ADADAD',
        background = '#202A35',

        cursor_bg = '#ADADAD',
        cursor_fg = '#202020',
        cursor_border = '#ADADAD',

        ansi = {
            '#202A35', -- Black（与背景一致；可弱化所有 ANSI black 背景块的突兀感）
            '#FA5355', -- Red
            '#3A9A5B', -- Green（调深：原 #126E00 太暗，改为更柔和的翡翠绿）
            '#FF8A65', -- Yellow
            '#4581EB', -- Blue
            '#FA54FF', -- Magenta
            '#33C2C1', -- Cyan
            '#ADADAD', -- White
        },
        brights = {
            '#555555', -- Bright Black
            '#FB7172', -- Bright Red
            '#50C878', -- Bright Green（调深：原 #67FF4F 太刺眼，改为翡翠绿）
            '#FF7043', -- Bright Yellow
            '#6D9DF1', -- Bright Blue
            '#FB82FF', -- Bright Magenta
            '#60D3D1', -- Bright Cyan
            '#EEEEEE', -- Bright White
        },
    },
}
config.color_scheme = 'Tabby-JetBrains-Darcula'

-- ============================================================================
-- 外观：Tab/标题栏/按钮
-- ============================================================================

-- Tab 放顶部：配合集成按钮在右上角
config.tab_bar_at_bottom = false
config.show_tab_index_in_tab_bar = false
config.use_fancy_tab_bar = true
config.window_background_opacity = 1.0 -- 透明可设 0.9 / 0.85

-- 限制刷新率：减少某些 CLI 工具频繁重绘时的闪烁感（WezTerm 默认 60 FPS）
-- 光标样式：SteadyBar 不闪烁，减少快速输出时的视觉干扰
-- 如果你喜欢闪烁，可以改回 'BlinkingBar'
config.default_cursor_style = 'SteadyBar'
config.max_fps = 60
config.animation_fps = 1
config.cursor_blink_rate = 0
config.force_reverse_video_cursor = true

-- 右侧滚动条：用于拖动浏览 scrollback（默认关闭）
-- 注：滚动条会占用右侧 window_padding 空间；若右侧 padding=0，WezTerm 会自动加 1 格。
config.enable_scroll_bar = true
config.min_scroll_bar_height = 8 -- 滑块最小高度（单位：字符格）；越大越容易拖拽

-- 无系统标题栏：仅集成最小化/最大化/关闭按钮，并保留可调整大小
config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'

config.window_frame = {
    -- Tab 栏字体大小：调大可以让 Tab 栏更高（默认 Windows 10pt，这里改成 12pt 更接近 Tabby）
    font_size = 12.0,
    active_titlebar_fg = '#ADADAD',
    active_titlebar_bg = '#202A35',
    inactive_titlebar_bg = '#202020',
}

config.colors = {
    -- 滚动条滑块颜色（thumb）：调亮一点，深色背景下更容易看见/拖动
    -- 参考：https://wezterm.org/config/appearance.html#defining-your-own-colors
    scrollbar_thumb = '#6B90B3',
    tab_bar = {
        -- Tab 栏整体背景：与标题栏/终端背景保持一致，避免偶发"缝"
        background = '#202A35',

        -- 选中 Tab：与编辑区同色 + 下划线/加粗提示当前 Tab
        active_tab = {
            bg_color = '#202A35',
            fg_color = '#ffffff',
            intensity = 'Bold',
            underline = 'Single',
        },

        inactive_tab = {
            bg_color = '#131D27',
            fg_color = '#808080',
        },

        inactive_tab_hover = {
            bg_color = '#3b3052',
            fg_color = '#909090',
        },

        new_tab = {
            bg_color = '#202020',
            fg_color = '#808080',
        },
        new_tab_hover = {
            bg_color = '#3b3052',
            fg_color = '#909090',
        },
    },
}

-- ============================================================================
-- 快捷键
-- ============================================================================

local function rename_current_tab(window, line)
    if line and #line > 0 then
        window:active_tab():set_title(line)
    end
end

config.keys = {
    -- 重命名当前 Tab（Ctrl+B）
    {
        key = 'b',
        mods = 'CTRL',
        action = act.PromptInputLine({
            description = '重命名当前 Tab',
            action = wezterm.action_callback(function(window, _pane, line)
                rename_current_tab(window, line)
            end),
        }),
    },
    -- 重命名当前 Tab（Ctrl+Shift+R）
    {
        key = 'r',
        mods = 'CTRL|SHIFT',
        action = act.PromptInputLine({
            description = '重命名当前 Tab',
            action = wezterm.action_callback(function(window, _pane, line)
                rename_current_tab(window, line)
            end),
        }),
    },
    -- 调试面板（不要占用默认的 Ctrl+Shift+L：它通常用于 Launcher/域选择）
    { key = 'D', mods = 'CTRL|SHIFT', action = act.ShowDebugOverlay },

    -- 移动当前 Tab 位置（WezTerm 不支持鼠标拖拽，用快捷键替代）
    { key = 'LeftArrow',  mods = 'CTRL|SHIFT', action = act.MoveTabRelative(-1) }, -- 左移
    { key = 'RightArrow', mods = 'CTRL|SHIFT', action = act.MoveTabRelative(1) },  -- 右移

    -- Ctrl+V 粘贴
    { key = 'v', mods = 'CTRL', action = act.PasteFrom('Clipboard') },

    -- Ctrl+C：有选中内容时复制，无选中时向 pane 发送 Ctrl+C 按键（参考 Tabby）
    {
        key = 'c',
        mods = 'CTRL',
        action = wezterm.action_callback(function(window, pane)
            local selection = window:get_selection_text_for_pane(pane)
            if selection and #selection > 0 then
                -- 有选中内容：复制到剪贴板
                window:perform_action(act.CopyTo('Clipboard'), pane)
                -- 在右侧状态栏显示"已复制"提示（模拟 Tabby 的小 toast）
                window:set_right_status(wezterm.format({
                    { Background = { Color = '#3A3A3A' } },
                    { Foreground = { Color = '#FFFFFF' } },
                    { Text = '  已复制  ' },
                }))
                -- 2 秒后清除提示
                wezterm.time.call_after(2, function()
                    window:set_right_status('')
                end)
            else
                -- 无选中内容：向 pane 发送 Ctrl+C 按键
                window:perform_action(act.SendKey({ key = 'c', mods = 'CTRL' }), pane)
            end
        end),
    },

    -- ── 分屏创建（对齐 Windows Terminal） ──
    { key = '+', mods = 'ALT|SHIFT', action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },
    { key = '_', mods = 'ALT|SHIFT', action = act.SplitVertical({ domain = 'CurrentPaneDomain' }) },

    -- ── Pane 导航（对齐 Windows Terminal） ──
    { key = 'LeftArrow',  mods = 'ALT', action = act.ActivatePaneDirection('Left') },
    { key = 'RightArrow', mods = 'ALT', action = act.ActivatePaneDirection('Right') },
    { key = 'UpArrow',    mods = 'ALT', action = act.ActivatePaneDirection('Up') },
    { key = 'DownArrow',  mods = 'ALT', action = act.ActivatePaneDirection('Down') },

    -- ── Pane 大小调整（对齐 Windows Terminal） ──
    { key = 'LeftArrow',  mods = 'ALT|SHIFT', action = act.AdjustPaneSize({ 'Left', 1 }) },
    { key = 'RightArrow', mods = 'ALT|SHIFT', action = act.AdjustPaneSize({ 'Right', 1 }) },
    { key = 'UpArrow',    mods = 'ALT|SHIFT', action = act.AdjustPaneSize({ 'Up', 1 }) },
    { key = 'DownArrow',  mods = 'ALT|SHIFT', action = act.AdjustPaneSize({ 'Down', 1 }) },

    -- ── 关闭当前 Pane / 新建 Tab（对齐 Windows Terminal） ──
    { key = 'w', mods = 'CTRL|SHIFT', action = act.CloseCurrentPane({ confirm = true }) },
    { key = 't', mods = 'CTRL|SHIFT', action = act.SpawnTab('CurrentPaneDomain') },
}

-- ============================================================================
-- 鼠标绑定：右键粘贴（参考 Tabby）
-- ============================================================================

config.mouse_bindings = {
    -- 右键单击 → 粘贴
    {
        event = { Down = { streak = 1, button = 'Right' } },
        mods = 'NONE',
        action = act.PasteFrom('Clipboard'),
    },

    -- Ctrl + 左键 → 打开链接
    {
        event = { Up = { streak = 1, button = 'Left' } },
        mods = 'CTRL',
        action = act.OpenLinkAtMouseCursor,
    },
}

-- ============================================================================
-- 事件：窗口标题 / Tab 标题格式
-- ============================================================================

wezterm.on('format-window-title', function()
    -- 集成按钮样式下，标题主要用于任务栏/Alt+Tab；这里保持简洁
    return 'WezTerm'
end)

local function strip_windows_admin_prefix(s)
    return (s or ''):gsub('^管理员:%s*', ''):gsub('^Administrator:%s*', '')
end

wezterm.on('format-tab-title', function(tab, _tabs, _panes, _cfg, _hover, max_width)
    -- 优先使用 set_title() 设置的 tab_title；否则回退到 pane title
    local title = (tab.tab_title and #tab.tab_title > 0) and tab.tab_title or (tab.active_pane.title or '')
    title = strip_windows_admin_prefix(title)

    -- 按 max_width 做截断 + 填充，使 Tab 尽量"吃满"分配到的宽度
    local max_content = math.max(1, max_width - 2)
    if #title > max_content then
        title = string.sub(title, 1, max_content)
    end

    local remaining = math.max(0, max_width - #title)
    local left = math.floor(remaining / 2)
    local right = remaining - left

    return {
        { Text = string.rep(' ', left) .. title .. string.rep(' ', right) },
    }
end)



return config
