-- wezterm-config-theme: luna-night
-- Luna-Night theme (purple Acrylic). Install via: python install_theme.py install luna-night
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
-- Colors: Luna-Night (sampled from target screenshot)
-- Palette: deep purple bg + pink/cyan/amber accents
-- ============================================================================

local luna = {
    bg = '#21213b',
    bg_dim = '#1a1a30',
    bg_lift = '#2a2a48',
    fg = '#a2abc8', -- muted body text (sampled from reference; not near-white)
    fg_dim = '#767f9c',
    pink = '#ed5093',
    pink_soft = '#e85393',
    cyan = '#61b4d2',
    amber = '#dc9d4d',
    split = '#bc773c', -- sandy orange pane dividers (from reference)
    selection = '#3a2a55',
}

config.color_schemes = {
    ['Luna-Night'] = {
        foreground = luna.fg,
        background = luna.bg,

        cursor_bg = luna.fg,
        cursor_fg = luna.bg,
        cursor_border = luna.fg,

        selection_fg = luna.fg,
        selection_bg = luna.selection,

        ansi = {
            luna.bg, -- Black
            '#f07178', -- Red
            '#7fd99a', -- Green
            luna.amber, -- Yellow / amber tab accent
            '#6b9fff', -- Blue
            luna.pink, -- Magenta / neon pink
            luna.cyan, -- Cyan
            luna.fg, -- White
        },
        brights = {
            '#55557a', -- Bright Black
            '#ff8b92', -- Bright Red
            '#9aefb4', -- Bright Green
            '#e0a154', -- Bright Yellow
            '#8bb4ff', -- Bright Blue
            luna.pink_soft, -- Bright Magenta
            '#7ec8e0', -- Bright Cyan
            '#b5bcd8', -- Bright White (still muted; reference is never pure white)
        },
    },
}
config.color_scheme = 'Luna-Night'

-- ============================================================================
-- Appearance: pink frame / acrylic blur / retro tabs (reference look)
-- ============================================================================

config.tab_bar_at_bottom = false
config.show_tab_index_in_tab_bar = false
-- Fancy tab bar: hover close (x) like tabby-darcula; retro bar has no per-tab x
config.use_fancy_tab_bar = true
config.show_close_tab_button_in_tabs = true
config.hide_tab_bar_if_only_one_tab = false
config.tab_max_width = 32

-- Acrylic blur + translucent purple shell (wallpaper show-through like the reference)
config.window_background_opacity = 0.82
config.win32_system_backdrop = 'Acrylic'
config.text_background_opacity = 0.92

config.window_padding = {
    left = 14,
    -- right padding = scrollbar width when enable_scroll_bar is on
    right = 10,
    top = 10,
    bottom = 10,
}

-- Dim inactive panes slightly so the active pane reads clearer
config.inactive_pane_hsb = {
    saturation = 0.92,
    brightness = 0.78,
}

-- Limit refresh rate: reduces flicker with CLI tools that redraw frequently (WezTerm default is 60 FPS)
config.max_fps = 60
config.animation_fps = 1

-- Cursor: thin bar (normal I-beam style)
config.default_cursor_style = 'SteadyBar'
config.force_reverse_video_cursor = false

config.enable_scroll_bar = true
config.min_scroll_bar_height = '1cell'
config.scrollback_lines = 10000
config.audible_bell = 'Disabled'
config.line_height = 1.08

-- No system title bar; WezTerm draws caption buttons in the tab bar
config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
config.integrated_title_button_style = 'Windows'
config.integrated_title_button_alignment = 'Right'
config.integrated_title_buttons = { 'Hide', 'Maximize', 'Close' }

config.window_frame = {
    font_size = 11.0,
    active_titlebar_fg = luna.fg,
    active_titlebar_bg = luna.bg_dim,
    inactive_titlebar_fg = luna.fg_dim,
    inactive_titlebar_bg = luna.bg_dim,
    button_fg = luna.fg_dim,
    button_bg = luna.bg_dim,
    button_hover_fg = '#e8ecf5',
    button_hover_bg = luna.bg_lift,
}

config.colors = {
    foreground = luna.fg,
    background = luna.bg,
    cursor_bg = luna.fg,
    cursor_fg = luna.bg,
    cursor_border = luna.fg,
    selection_fg = luna.fg,
    selection_bg = luna.selection,
    scrollbar_thumb = luna.fg_dim, -- muted thin thumb; avoid loud pink strip
    split = luna.bg_lift, -- near-background; avoid eye-catching divider color
    tab_bar = {
        background = luna.bg_dim,
        active_tab = {
            bg_color = luna.bg,
            fg_color = luna.amber,
            intensity = 'Bold',
        },
        inactive_tab = {
            bg_color = luna.bg_dim,
            fg_color = luna.fg_dim,
        },
        inactive_tab_hover = {
            bg_color = luna.bg_lift,
            fg_color = luna.pink_soft,
        },
        new_tab = {
            bg_color = luna.bg_dim,
            fg_color = luna.fg_dim,
        },
        new_tab_hover = {
            bg_color = luna.bg_lift,
            fg_color = luna.pink,
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
                    { Background = { Color = '#ed5093' } },
                    { Foreground = { Color = '#21213b' } },
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
    return 'WezTerm'
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
