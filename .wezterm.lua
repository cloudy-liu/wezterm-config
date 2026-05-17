-- Global WezTerm config (on Windows, typically saved as ~/.wezterm.lua, where ~ is the user home directory)
local wezterm = require 'wezterm'
local act = wezterm.action

-- Use config_builder: clearer error messages, more complete defaults
local config = wezterm.config_builder()

-- ============================================================================
-- Basics: startup / fonts / cursor
-- ============================================================================

-- Windows paths: use double backslashes \\ or forward slashes /
config.default_prog = { 'cmd.exe', '/k', 'D:/tools/cmder_full/cmder/vendor/init.bat' }

config.font = wezterm.font_with_fallback({
    'Source Code Pro',
    'JetBrains Mono',
    'Consolas',
    'Microsoft YaHei',
    'Segoe UI Symbol',  -- Windows symbol font, covers more Unicode characters
    'Noto Sans Symbols 2',  -- If Noto fonts are installed
})

-- Close to Windows Terminal's faint text handling:
-- For all Intensity=Half text, keep the same font weight as normal text but dim
-- the foreground to OneDark comment gray. This is mainly to improve the look of
-- Cursor Thinking text, avoiding the default ExtraLight which appears too faint.
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

-- Disable missing glyph warning popup (no more alerts when certain characters lack glyphs)
config.warn_about_missing_glyphs = false

-- ============================================================================
-- Paste fix: Windows clipboard typically uses CRLF; remote tools (vim, git commit, etc.)
-- may display extra blank lines. Normalize pasted newlines to LF (recommended).
-- Ref: https://wezterm.org/config/lua/config/canonicalize_pasted_newlines.html
-- ============================================================================
config.canonicalize_pasted_newlines = "LineFeed"

-- Window close confirmation: WezTerm doesn't support "prompt once then remember".
-- Note: window_close_confirmation only affects closing via the window system (clicking X, etc.),
-- not closing individual tabs/panes.
-- - 'NeverPrompt': never prompt
-- - 'SmartPrompt': smart prompt
-- - 'AlwaysPrompt': always prompt
config.window_close_confirmation = 'NeverPrompt'


-- ============================================================================
-- Colors: scheme + tab/titlebar colors
-- ============================================================================

config.color_schemes = {
    ['Tabby-JetBrains-Darcula'] = {
        foreground = '#ADADAD',
        background = '#202A35',

        cursor_bg = '#ADADAD',
        cursor_fg = '#202020',
        cursor_border = '#ADADAD',

        ansi = {
            '#202A35', -- Black (matches background; reduces harsh ANSI black blocks)
            '#FA5355', -- Red
            '#3A9A5B', -- Green (softened: original #126E00 too dark, changed to milder emerald)
            '#FF8A65', -- Yellow
            '#4581EB', -- Blue
            '#FA54FF', -- Magenta
            '#33C2C1', -- Cyan
            '#ADADAD', -- White
        },
        brights = {
            '#555555', -- Bright Black
            '#FB7172', -- Bright Red
            '#50C878', -- Bright Green (softened: original #67FF4F too harsh, changed to emerald)
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
-- Appearance: tab bar / title bar / buttons
-- ============================================================================

-- Tabs at top:配合 integrated buttons in the top-right corner
config.tab_bar_at_bottom = false
config.show_tab_index_in_tab_bar = false
config.use_fancy_tab_bar = true
config.window_background_opacity = 1.0 -- For transparency, try 0.9 / 0.85

-- Limit refresh rate: reduces flicker with CLI tools that redraw frequently (WezTerm default is 60 FPS)
-- Cursor style: SteadyBar doesn't blink, reducing visual noise during fast output
-- If you prefer blinking, change back to 'BlinkingBar'
config.default_cursor_style = 'SteadyBar'
config.max_fps = 60
config.animation_fps = 1
config.cursor_blink_rate = 0
config.force_reverse_video_cursor = true

-- Right scrollbar: for drag-scrolling through scrollback (disabled by default)
-- Note: scrollbar occupies right window_padding space; if right padding=0, WezTerm auto-adds 1 cell.
config.enable_scroll_bar = true
config.min_scroll_bar_height = 8 -- Minimum thumb height (in character cells); larger = easier to drag

-- No system title bar: only integrated min/max/close buttons, window is still resizable
config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'

config.window_frame = {
    -- Tab bar font size: larger value makes the tab bar taller (default 10pt on Windows, here 12pt for Tabby-like feel)
    font_size = 12.0,
    active_titlebar_fg = '#ADADAD',
    active_titlebar_bg = '#202A35',
    inactive_titlebar_bg = '#202020',
}

config.colors = {
    -- Scrollbar thumb color: brightened for better visibility on dark backgrounds
    -- Ref: https://wezterm.org/config/appearance.html#defining-your-own-colors
    scrollbar_thumb = '#6B90B3',
    tab_bar = {
        -- Tab bar background: matches titlebar/terminal background to avoid visible seams
        background = '#202A35',

        -- Active tab: same color as editor area + underline/bold to indicate current tab
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
-- Key bindings
-- ============================================================================

local function rename_current_tab(window, line)
    if line and #line > 0 then
        window:active_tab():set_title(line)
    end
end

local function rename_tab_action()
    return wezterm.action_callback(function(window, pane)
        local current_title = window:active_tab():get_title() or ''
        window:perform_action(
            act.PromptInputLine({
                description = 'Rename current tab',
                initial_value = current_title,
                action = wezterm.action_callback(function(win, _p, line)
                    rename_current_tab(win, line)
                end),
            }),
            pane
        )
    end)
end

config.keys = {
    -- Rename current tab (Ctrl+B)
    { key = 'b', mods = 'CTRL', action = rename_tab_action() },
    -- Rename current tab (Ctrl+Shift+R)
    { key = 'r', mods = 'CTRL|SHIFT', action = rename_tab_action() },
    -- Debug overlay (don't use default Ctrl+Shift+L: it's typically for Launcher/domain selection)
    { key = 'D', mods = 'CTRL|SHIFT', action = act.ShowDebugOverlay },

    -- Move current tab position (WezTerm doesn't support mouse drag, use keyboard instead)
    { key = 'LeftArrow',  mods = 'CTRL|SHIFT', action = act.MoveTabRelative(-1) }, -- Move left
    { key = 'RightArrow', mods = 'CTRL|SHIFT', action = act.MoveTabRelative(1) },  -- Move right

    -- Ctrl+V paste
    { key = 'v', mods = 'CTRL', action = act.PasteFrom('Clipboard') },

    -- Ctrl+C: copy when text is selected, send Ctrl+C key when nothing is selected (inspired by Tabby)
    {
        key = 'c',
        mods = 'CTRL',
        action = wezterm.action_callback(function(window, pane)
            local selection = window:get_selection_text_for_pane(pane)
            if selection and #selection > 0 then
                -- Has selection: copy to clipboard
                window:perform_action(act.CopyTo('Clipboard'), pane)
                -- Show "Copied" badge in right status bar (mimics Tabby's toast)
                window:set_right_status(wezterm.format({
                    { Background = { Color = '#3A3A3A' } },
                    { Foreground = { Color = '#FFFFFF' } },
                    { Text = '  Copied  ' },
                }))
                -- Clear badge after 2 seconds
                wezterm.time.call_after(2, function()
                    window:set_right_status('')
                end)
            else
                -- No selection: send Ctrl+C key to pane
                window:perform_action(act.SendKey({ key = 'c', mods = 'CTRL' }), pane)
            end
        end),
    },

    -- ── Pane splits (aligned with Windows Terminal) ──
    { key = '+', mods = 'ALT|SHIFT', action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },
    { key = '_', mods = 'ALT|SHIFT', action = act.SplitVertical({ domain = 'CurrentPaneDomain' }) },

    -- ── Pane navigation (aligned with Windows Terminal) ──
    { key = 'LeftArrow',  mods = 'ALT', action = act.ActivatePaneDirection('Left') },
    { key = 'RightArrow', mods = 'ALT', action = act.ActivatePaneDirection('Right') },
    { key = 'UpArrow',    mods = 'ALT', action = act.ActivatePaneDirection('Up') },
    { key = 'DownArrow',  mods = 'ALT', action = act.ActivatePaneDirection('Down') },

    -- ── Pane resize (aligned with Windows Terminal) ──
    { key = 'LeftArrow',  mods = 'ALT|SHIFT', action = act.AdjustPaneSize({ 'Left', 1 }) },
    { key = 'RightArrow', mods = 'ALT|SHIFT', action = act.AdjustPaneSize({ 'Right', 1 }) },
    { key = 'UpArrow',    mods = 'ALT|SHIFT', action = act.AdjustPaneSize({ 'Up', 1 }) },
    { key = 'DownArrow',  mods = 'ALT|SHIFT', action = act.AdjustPaneSize({ 'Down', 1 }) },

    -- ── Close current pane / New tab (aligned with Windows Terminal) ──
    { key = 'w', mods = 'CTRL|SHIFT', action = act.CloseCurrentPane({ confirm = true }) },
    { key = 't', mods = 'CTRL|SHIFT', action = act.SpawnTab('CurrentPaneDomain') },
}

-- ============================================================================
-- Mouse bindings: right-click paste (inspired by Tabby)
-- ============================================================================

config.mouse_bindings = {
    -- Right-click → paste
    {
        event = { Down = { streak = 1, button = 'Right' } },
        mods = 'NONE',
        action = act.PasteFrom('Clipboard'),
    },

    -- Ctrl + left-click → open link
    {
        event = { Up = { streak = 1, button = 'Left' } },
        mods = 'CTRL',
        action = act.OpenLinkAtMouseCursor,
    },
}

-- ============================================================================
-- Events: window title / tab title format
-- ============================================================================

wezterm.on('format-window-title', function()
    -- With integrated buttons, the title is mainly for taskbar/Alt+Tab; keep it simple
    return 'WezTerm'
end)

local function strip_windows_admin_prefix(s)
    return (s or ''):gsub('^管理员:%s*', ''):gsub('^Administrator:%s*', '')
end

wezterm.on('format-tab-title', function(tab, _tabs, _panes, _cfg, _hover, max_width)
    -- Prefer tab_title set via set_title(); fall back to pane title
    local title = (tab.tab_title and #tab.tab_title > 0) and tab.tab_title or (tab.active_pane.title or '')
    title = strip_windows_admin_prefix(title)

    -- Truncate + pad to fill the tab's allocated width
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
