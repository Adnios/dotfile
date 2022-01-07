local wezterm = require "wezterm"
local mykeys = {
    {
        key = "t",
        mods = "SHIFT|ALT",
        action = wezterm.action {SpawnTab = "CurrentPaneDomain"}
    }, {
        key = "w",
        mods = "SHIFT|ALT",
        action = wezterm.action {CloseCurrentTab = {confirm = true}}
    }, {key = "=", mods = "CTRL", action = "IncreaseFontSize"},
    {key = "-", mods = "CTRL", action = "DecreaseFontSize"},
    {key = "0", mods = "CTRL", action = "ResetFontSize"},
    {key = "C", mods = "CTRL|SHIFT", action = "Copy"},
    {key = "V", mods = "CTRL|SHIFT", action = "Paste"},
    {key = "Z", mods = "CTRL", action = "TogglePaneZoomState"}, {
        key = "J",
        mods = "SHIFT|ALT",
        action = wezterm.action {ActivateTabRelative = -1}
    }, {
        key = "K",
        mods = "SHIFT|ALT",
        action = wezterm.action {ActivateTabRelative = 1}
    }, {key = "X", mods = "SHIFT|ALT", action = "ActivateCopyMode"},
    {key = " ", mods = "SHIFT|ALT", action = "QuickSelect"}
}
for i = 1, 8 do
    table.insert(mykeys, {
        key = tostring(i),
        mods = "CTRL|ALT",
        action = wezterm.action {ActivateTab = i - 1}
    })
end

return {
    scrollback_lines=20000,
    use_ime = true,
    default_prog = {"/usr/bin/zsh", "-l"},
    font = wezterm.font_with_fallback({
        "FiraCode Nerd Font", "Noto Sans CJK SC"
    }),
    front_end = "OpenGL",
    font_size = 10,
    -- color_scheme = "Snazzy",
    enable_tab_bar = true,
    tab_max_width = 20,
    tab_bar_at_bottom = true,
    hide_tab_bar_if_only_one_tab = true,
    colors = {
        -- https://github.com/wez/wezterm/blob/main/assets/colors/Snazzy.toml
        foreground = "#ebece6",
        background = "#1e1f29",
        cursor_bg = "#ff5555",
        cursor_border = "#ff5555",
        cursor_fg = "#1a1b26",
        -- cursor_bg = "#e4e4e4",
        -- cursor_border = "#e4e4e4",
        -- cursor_fg = "#f6f6f6",
        selection_bg = "#81aec6",
        selection_fg = "#000000",

        ansi = {"#000000","#fc4346","#50fb7c","#f0fb8c","#49baff","#fc4cb4","#8be9fe","#ededec"},
        brights = {"#555555","#fc4346","#50fb7c","#f0fb8c","#49baff","#fc4cb4","#8be9fe","#ededec"},

        tab_bar = {
            background = "#2e3440",
            active_tab = {
                bg_color = "#5e81ac",
                fg_color = "#eceff4",
                intensity = "Bold",
                italic = true
            },
            inactive_tab = {bg_color = "#4c566a", fg_color = "#d8dee9"},
            inactive_tab_hover = {
                bg_color = "#d8dee9",
                fg_color = "#3b4252",
                italic = false
            },
            new_tab = {bg_color = "#3b4252", fg_color = "#a3be8c"},
            new_tab_hover = {
                bg_color = "#3b4252",
                fg_color = "#8fbcbb",
                italic = false
            }
        }
    },
    -- text_background_opacity = 1.0,
    disable_default_key_bindings = true,
    debug_key_events = true,
    use_fancy_tab_bar = false,

    -- Use ALT instead of SHIFT to bypass application mouse reporting
    -- Use CTRL+SHIFT+click or SHIFT+click to open url in nvim
    bypass_mouse_reporting_modifiers = "SHIFT",
    mouse_bindings = {
        {
            event = {Up = {streak = 1, button = "Left"}},
            mods = "NONE",
            action = wezterm.action {
                CompleteSelectionOrOpenLinkAtMouseCursor = "Clipboard"
            }
        }, {
            event = {Up = {streak = 1, button = "Left"}},
            mods = "CTRL",
            action = "OpenLinkAtMouseCursor"
        }, {
          event={Down={streak=1, button="Left"}},
          mods="CTRL",
          action="Nop",
        },
    },
    keys = mykeys,

    window_padding = {
      left = 0,
      right = 0,
      top = 0,
      bottom = 0,
    },

    window_close_confirmation = "NeverPrompt",
    -- skip_close_confirmation_for_processes_named = {
    --   "bash", "sh", "zsh", "fish", "tmux", "nvim", "env TERM=wezterm nvim"
    -- }

    -- window_background_opacity = 0.95
    -- window_background_image = "/home/ayamir/Pictures/wezterm/nord.jpg",
    -- window_background_image_hsb = {
    --     brightness = 2.0,
    --     hue = 1.0,
    --     saturation = 1.0
    -- }
}
