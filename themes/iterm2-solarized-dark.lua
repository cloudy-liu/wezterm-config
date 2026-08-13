-- wezterm-config-theme: iterm2-solarized-dark
-- iTerm2-inspired Solarized Dark theme.
-- Install via: python install_theme.py install iterm2-solarized-dark
-- Palette sources:
--   https://gitlab.com/gnachman/iterm2/-/blob/33945e63ad48ed80d6cc1adf7cbeb663217652d2/plists/ColorPresets.plist
--   https://github.com/altercation/solarized
-- Appearance reference:
--   https://iterm2.com/documentation-preferences-appearance.html
-- Global WezTerm config (on Windows, typically saved as ~/.wezterm.lua, where ~ is the user home directory)
local wezterm = require 'wezterm'
local act = wezterm.action

-- Use config_builder: clearer error messages, more complete defaults
local config = wezterm.config_builder()

-- ============================================================================
-- Basics: startup / fonts / cursor
-- ============================================================================

-- Resolve Cmder without a hardcoded machine path:
-- WEZTERM_CMDER_INIT → CMDER_ROOT → where cmder → common paths → plain cmd.exe
local function file_exists(path)
    local f = io.open(path, 'r')
    if f then
        f:close()
        return true
    end
    return false
end

local function normalize_slashes(path)
    return (path:gsub('\\', '/'))
end

local function dirname(path)
    return normalize_slashes(path):match('^(.*)/[^/]+$')
end

local function resolve_default_prog()
    local candidates = {}

    local explicit = os.getenv('WEZTERM_CMDER_INIT')
    if explicit and explicit ~= '' then
        table.insert(candidates, normalize_slashes(explicit))
    end

    local cmder_root = os.getenv('CMDER_ROOT')
    if cmder_root and cmder_root ~= '' then
        table.insert(candidates, normalize_slashes(cmder_root) .. '/vendor/init.bat')
    end

    local ok, stdout = wezterm.run_child_process({ 'where.exe', 'cmder' })
    if ok and stdout and stdout ~= '' then
        local exe = stdout:match('^[^\r\n]+')
        local dir = exe and dirname(exe)
        if dir then
            table.insert(candidates, dir .. '/vendor/init.bat')
        end
    end

    local home = normalize_slashes(os.getenv('USERPROFILE') or '')
    for _, p in ipairs({
        home .. '/cmder/vendor/init.bat',
        home .. '/scoop/apps/cmder/current/vendor/init.bat',
        'C:/tools/cmder/vendor/init.bat',
        'C:/cmder/vendor/init.bat',
    }) do
        table.insert(candidates, p)
    end

    for _, init_bat in ipairs(candidates) do
        if file_exists(init_bat) then
            return { 'cmd.exe', '/k', init_bat }
        end
    end

    return { 'cmd.exe' }
end

config.default_prog = resolve_default_prog()

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
-- the foreground to Solarized Base00. This is mainly to improve the look of
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
            { foreground = '#657b83' }
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
            { foreground = '#657b83' }
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
-- Colors: the exact Solarized Dark preset bundled in iTerm2's source tree.
-- Solarized intentionally uses tonal base colors for several bright ANSI slots;
-- do not "correct" those unusual entries to brighter red/green/yellow values.
-- ============================================================================

local solarized = {
    base03 = '#002b36',
    base02 = '#073642',
    base01 = '#586e75',
    base00 = '#657b83',
    base0 = '#839496',
    base1 = '#93a1a1',
    base2 = '#eee8d5',
    base3 = '#fdf6e3',
    yellow = '#b58900',
    orange = '#cb4b16',
    red = '#dc322f',
    magenta = '#d33682',
    violet = '#6c71c4',
    blue = '#268bd2',
    cyan = '#2aa198',
    green = '#859900',
}

config.color_schemes = {
    ['iTerm2-Solarized-Dark'] = {
        foreground = solarized.base0,
        background = solarized.base03,

        cursor_bg = solarized.base0,
        cursor_fg = solarized.base02,
        cursor_border = solarized.base0,

        selection_fg = solarized.base1,
        selection_bg = solarized.base02,

        ansi = {
            solarized.base02, -- Black
            solarized.red, -- Red
            solarized.green, -- Green
            solarized.yellow, -- Yellow
            solarized.blue, -- Blue
            solarized.magenta, -- Magenta
            solarized.cyan, -- Cyan
            solarized.base2, -- White
        },
        brights = {
            solarized.base03, -- Bright Black
            solarized.orange, -- Bright Red
            solarized.base01, -- Bright Green
            solarized.base00, -- Bright Yellow
            solarized.base0, -- Bright Blue
            solarized.violet, -- Bright Magenta
            solarized.base1, -- Bright Cyan
            solarized.base3, -- Bright White
        },
    },
}
config.color_scheme = 'iTerm2-Solarized-Dark'

-- ============================================================================
-- Appearance: iTerm2's modern Minimal/Compact direction: integrated top tabs,
-- centered stretched titles, configurable margins, and gently dimmed splits.
-- ============================================================================

config.tab_bar_at_bottom = false
config.show_tab_index_in_tab_bar = false
-- Fancy tab bar: hover close (x) like tabby-darcula; retro bar has no per-tab x
config.use_fancy_tab_bar = true
config.show_close_tab_button_in_tabs = true
config.hide_tab_bar_if_only_one_tab = false
config.tab_max_width = 40

-- iTerm2 exposes transparency and blur as profile settings. Keep Luna-Night's
-- Acrylic foundation, but make it restrained so Solarized values stay stable.
config.window_background_opacity = 0.94
config.win32_system_backdrop = 'Acrylic'
config.text_background_opacity = 0.98

config.window_padding = {
    left = 10,
    -- right padding = scrollbar width when enable_scroll_bar is on
    right = 10,
    top = 8,
    bottom = 8,
}

-- Dim inactive panes slightly so the active pane reads clearer
config.inactive_pane_hsb = {
    saturation = 0.94,
    brightness = 0.84,
}

-- Limit refresh rate: reduces flicker with CLI tools that redraw frequently (WezTerm default is 60 FPS)
config.max_fps = 60
config.animation_fps = 1

-- iTerm2's context-aware cursor is a reverse-video box. Keep it non-blinking
-- to retain Luna-Night's low-motion behavior.
config.default_cursor_style = 'SteadyBlock'
config.force_reverse_video_cursor = true

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
    active_titlebar_fg = solarized.base1,
    active_titlebar_bg = solarized.base03,
    inactive_titlebar_fg = solarized.base00,
    inactive_titlebar_bg = solarized.base03,
    button_fg = solarized.base0,
    button_bg = solarized.base03,
    button_hover_fg = solarized.base2,
    button_hover_bg = solarized.base02,
}

config.colors = {
    foreground = solarized.base0,
    background = solarized.base03,
    cursor_bg = solarized.base0,
    cursor_fg = solarized.base02,
    cursor_border = solarized.base0,
    selection_fg = solarized.base1,
    selection_bg = solarized.base02,
    scrollbar_thumb = solarized.base01,
    split = solarized.base02,
    tab_bar = {
        background = solarized.base03,
        active_tab = {
            bg_color = solarized.base02,
            fg_color = solarized.base1,
            intensity = 'Bold',
        },
        inactive_tab = {
            bg_color = solarized.base03,
            fg_color = solarized.base00,
        },
        inactive_tab_hover = {
            bg_color = solarized.base02,
            fg_color = solarized.base0,
        },
        new_tab = {
            bg_color = solarized.base03,
            fg_color = solarized.base00,
        },
        new_tab_hover = {
            bg_color = solarized.base02,
            fg_color = solarized.cyan,
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
                    { Background = { Color = '#268bd2' } },
                    { Foreground = { Color = '#fdf6e3' } },
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
    return 'WezTerm · iTerm2 Solarized'
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

    local remaining = math.max(0, max_width - #title)
    local left = math.floor(remaining / 2)
    local right = remaining - left

    return {
        { Text = string.rep(' ', left) .. title .. string.rep(' ', right) },
    }
end)



return config
