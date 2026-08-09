-- wezterm-config-theme: ghostty-mocha
-- Ghostty-inspired Catppuccin Mocha theme.
-- Install via: python install_theme.py install ghostty-mocha
-- Palette sources:
--   https://github.com/ghostty-org/ghostty/blob/05221c11c9db0715666fc6e038915128fc6a563e/build.zig.zon
--   https://github.com/mbadolato/iTerm2-Color-Schemes/blob/875a82f/ghostty/Catppuccin%20Mocha
-- Appearance reference:
--   https://ghostty.org/docs/config/reference#macos-titlebar-style
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
-- the foreground to Catppuccin Overlay 2. This is mainly to improve the look of
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
            { foreground = '#9399b2' }
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
            { foreground = '#9399b2' }
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
-- Colors: Catppuccin Mocha as shipped through Ghostty's upstream theme set.
-- The 16 ANSI entries intentionally follow the upstream terminal theme rather
-- than remapping the semantic Catppuccin palette by eye.
-- ============================================================================

local mocha = {
    base = '#1e1e2e',
    mantle = '#181825',
    crust = '#11111b',
    surface0 = '#313244',
    surface1 = '#45475a',
    surface2 = '#585b70',
    overlay0 = '#6c7086',
    overlay1 = '#7f849c',
    overlay2 = '#9399b2',
    subtext0 = '#a6adc8',
    subtext1 = '#bac2de',
    text = '#cdd6f4',
    rosewater = '#f5e0dc',
    red = '#f38ba8',
    green = '#a6e3a1',
    yellow = '#f9e2af',
    blue = '#89b4fa',
    pink = '#f5c2e7',
    teal = '#94e2d5',
    mauve = '#cba6f7',
}

config.color_schemes = {
    ['Ghostty-Catppuccin-Mocha'] = {
        foreground = mocha.text,
        background = mocha.base,

        cursor_bg = mocha.rosewater,
        cursor_fg = mocha.base,
        cursor_border = mocha.rosewater,

        selection_fg = mocha.base,
        selection_bg = mocha.rosewater,

        ansi = {
            mocha.surface1, -- Black
            mocha.red, -- Red
            mocha.green, -- Green
            mocha.yellow, -- Yellow
            mocha.blue, -- Blue
            mocha.pink, -- Magenta
            mocha.teal, -- Cyan
            mocha.subtext1, -- White
        },
        brights = {
            mocha.surface2, -- Bright Black
            '#f7aec2', -- Bright Red
            '#c2ecbf', -- Bright Green
            '#fcd682', -- Bright Yellow
            '#aeccfc', -- Bright Blue
            '#f398da', -- Bright Magenta
            '#b1eae1', -- Bright Cyan
            mocha.subtext0, -- Bright White
        },
    },
}
config.color_scheme = 'Ghostty-Catppuccin-Mocha'

-- ============================================================================
-- Appearance: Ghostty's seamless dark surface and integrated titlebar tabs.
-- Ghostty's default macOS titlebar is transparent so the terminal background
-- flows through it; keeping the WezTerm surface opaque preserves exact colors.
-- ============================================================================

config.tab_bar_at_bottom = false
config.show_tab_index_in_tab_bar = false
-- Fancy tab bar: hover close (x) like tabby-darcula; retro bar has no per-tab x
config.use_fancy_tab_bar = true
config.show_close_tab_button_in_tabs = true
config.hide_tab_bar_if_only_one_tab = false
config.tab_max_width = 32

config.window_background_opacity = 1.0
config.text_background_opacity = 1.0

config.window_padding = {
    left = 6,
    -- right padding = scrollbar width when enable_scroll_bar is on
    right = 6,
    top = 4,
    bottom = 4,
}

-- Dim inactive panes slightly so the active pane reads clearer
config.inactive_pane_hsb = {
    saturation = 0.96,
    brightness = 0.76,
}

-- Limit refresh rate: reduces flicker with CLI tools that redraw frequently (WezTerm default is 60 FPS)
config.max_fps = 60
config.animation_fps = 1

-- Ghostty defaults to a block cursor; keep it steady to preserve Luna-Night's
-- low-motion behavior while matching the shape and palette.
config.default_cursor_style = 'SteadyBlock'
config.force_reverse_video_cursor = false

config.enable_scroll_bar = true
config.min_scroll_bar_height = '1cell'
config.scrollback_lines = 10000
config.audible_bell = 'Disabled'

-- No system title bar; WezTerm draws caption buttons in the tab bar
config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
config.integrated_title_button_style = 'Windows'
config.integrated_title_button_alignment = 'Right'
config.integrated_title_buttons = { 'Hide', 'Maximize', 'Close' }

config.window_frame = {
    font_size = 12.0,
    active_titlebar_fg = mocha.text,
    active_titlebar_bg = mocha.base,
    inactive_titlebar_fg = mocha.overlay2,
    inactive_titlebar_bg = mocha.base,
    button_fg = mocha.subtext0,
    button_bg = mocha.base,
    button_hover_fg = mocha.text,
    button_hover_bg = mocha.surface0,
}

config.colors = {
    foreground = mocha.text,
    background = mocha.base,
    cursor_bg = mocha.rosewater,
    cursor_fg = mocha.base,
    cursor_border = mocha.rosewater,
    selection_fg = mocha.base,
    selection_bg = mocha.rosewater,
    scrollbar_thumb = mocha.surface2,
    split = mocha.surface1,
    tab_bar = {
        background = mocha.base,
        active_tab = {
            bg_color = mocha.base,
            fg_color = mocha.rosewater,
            intensity = 'Bold',
        },
        inactive_tab = {
            bg_color = mocha.base,
            fg_color = mocha.overlay1,
        },
        inactive_tab_hover = {
            bg_color = mocha.surface0,
            fg_color = mocha.pink,
        },
        new_tab = {
            bg_color = mocha.base,
            fg_color = mocha.overlay1,
        },
        new_tab_hover = {
            bg_color = mocha.surface0,
            fg_color = mocha.mauve,
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
                    { Background = { Color = '#f5e0dc' } },
                    { Foreground = { Color = '#1e1e2e' } },
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

    -- ── Pane cycle (Alt+Tab-like): keep pressing to rotate focus ──
    -- Alt+` mirrors Windows "cycle windows of same app"; wraps around.
    { key = '`', mods = 'ALT', action = act.ActivatePaneDirection('Next') },
    { key = '`', mods = 'ALT|SHIFT', action = act.ActivatePaneDirection('Prev') },

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
    return 'WezTerm · Ghostty Mocha'
end)

local function strip_windows_admin_prefix(s)
    return (s or ''):gsub('^管理员:%s*', ''):gsub('^Administrator:%s*', '')
end

wezterm.on('format-tab-title', function(tab, _tabs, _panes, _cfg, _hover, max_width)
    -- Prefer tab_title set via set_title(); fall back to pane title
    local title = (tab.tab_title and #tab.tab_title > 0) and tab.tab_title or (tab.active_pane.title or '')
    title = strip_windows_admin_prefix(title)

    local max_content = math.max(1, max_width - 2)
    if #title > max_content then
        title = string.sub(title, 1, max_content - 1) .. '…'
    end

    return {
        { Text = ' ' .. title .. ' ' },
    }
end)



return config
