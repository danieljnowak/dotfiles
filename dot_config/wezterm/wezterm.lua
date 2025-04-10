-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action
local mux = wezterm.mux

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Set up workspace configurations
local function setup_workspaces()
  -- When wezterm starts up, create and switch to a workspace called "default"
  wezterm.on("gui-startup", function(cmd)
    local tab, pane, window = mux.spawn_window(cmd or {})
    window:gui_window():maximize()
  end)

  -- Define workspace layouts
  wezterm.on("update-right-status", function(window, pane)
    local workspace = window:active_workspace()
    window:set_right_status(wezterm.format {
      { Foreground = { Color = "cyan" } },
      { Text = "  " .. workspace .. " " },
    })
  end)
end

-- Call workspace setup
setup_workspaces()

-- Enable session restoration
config.enable_wayland = false
config.unix_domains = {
  {
    name = 'unix',
  },
}
config.default_gui_startup_args = { 'connect', 'unix' }

-- Color scheme and appearance - using tokyonight as a modern alternative
config.color_scheme = 'Tokyo Night'
config.font = wezterm.font_with_fallback {
  'Codelia NF',
  'JetBrains Mono',
}
config.font_size = 16
config.window_background_opacity = 0.95
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
  left = 5,
  right = 5,
  top = 5,
  bottom = 5,
}

-- Tab bar appearance with better styling
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = true
config.show_tab_index_in_tab_bar = false
config.tab_max_width = 25
config.colors = {
  tab_bar = {
    background = '#1a1b26',
    active_tab = {
      bg_color = '#7aa2f7',
      fg_color = '#1a1b26',
    },
    inactive_tab = {
      bg_color = '#1a1b26',
      fg_color = '#a9b1d6',
    },
    inactive_tab_hover = {
      bg_color = '#292e42',
      fg_color = '#c0caf5',
    },
    new_tab = {
      bg_color = '#1a1b26',
      fg_color = '#a9b1d6',
    },
    new_tab_hover = {
      bg_color = '#292e42',
      fg_color = '#c0caf5',
    },
  },
}

-- Terminal bells
config.audible_bell = "Disabled"
config.visual_bell = {
  fade_in_duration_ms = 75,
  fade_out_duration_ms = 75,
  target = "CursorColor",
}

-- Key mappings - enhanced with workspaces and quick actions
config.keys = {
  -- Split panes
  { key = 'd', mods = 'CMD', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'd', mods = 'CMD|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  
  -- Navigate between panes
  { key = 'h', mods = 'CMD|ALT', action = act.ActivatePaneDirection 'Left' },
  { key = 'l', mods = 'CMD|ALT', action = act.ActivatePaneDirection 'Right' },
  { key = 'k', mods = 'CMD|ALT', action = act.ActivatePaneDirection 'Up' },
  { key = 'j', mods = 'CMD|ALT', action = act.ActivatePaneDirection 'Down' },
  
  -- Resize panes
  { key = 'LeftArrow', mods = 'CMD|SHIFT', action = act.AdjustPaneSize { 'Left', 5 } },
  { key = 'RightArrow', mods = 'CMD|SHIFT', action = act.AdjustPaneSize { 'Right', 5 } },
  { key = 'UpArrow', mods = 'CMD|SHIFT', action = act.AdjustPaneSize { 'Up', 3 } },
  { key = 'DownArrow', mods = 'CMD|SHIFT', action = act.AdjustPaneSize { 'Down', 3 } },
  
  -- Tabs
  { key = 't', mods = 'CMD', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'w', mods = 'CMD', action = act.CloseCurrentTab { confirm = true } },
  { key = 'Tab', mods = 'CTRL', action = act.ActivateTabRelative(1) },
  { key = 'Tab', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
  
  -- Workspace management
  { key = '1', mods = 'CMD|ALT', action = act.SwitchToWorkspace { name = 'default' } },
  { key = '2', mods = 'CMD|ALT', action = act.SwitchToWorkspace { name = 'coding' } },
  { key = '3', mods = 'CMD|ALT', action = act.SwitchToWorkspace { name = 'servers' } },
  { key = 'n', mods = 'CMD|ALT', action = act.PromptInputLine {
    description = 'Enter workspace name',
    action = wezterm.action_callback(function(window, pane, line)
      if line then
        window:perform_action(act.SwitchToWorkspace { name = line }, pane)
      end
    end),
  }},
  
  -- Font size
  { key = '+', mods = 'CMD', action = act.IncreaseFontSize },
  { key = '-', mods = 'CMD', action = act.DecreaseFontSize },
  { key = '0', mods = 'CMD', action = act.ResetFontSize },
  
  -- Quick select mode - easily copy text without using mouse
  { key = 'f', mods = 'CMD|SHIFT', action = act.QuickSelect },
  
  -- Copy/Paste with system clipboard
  { key = 'c', mods = 'CMD', action = act.CopyTo 'Clipboard' },
  { key = 'v', mods = 'CMD', action = act.PasteFrom 'Clipboard' },
  
  -- Launcher for commonly used commands
  { key = 'p', mods = 'CMD|SHIFT', action = act.ActivateCommandPalette },
  
  -- Reload configuration
  { key = 'r', mods = 'CMD|SHIFT', action = act.ReloadConfiguration },
  
  -- Toggle fullscreen
  { key = 'f', mods = 'CMD', action = act.ToggleFullScreen },
}

-- Mouse config
config.mouse_bindings = {
  -- Right click to paste from primary selection
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = act.PasteFrom 'PrimarySelection',
  },
  -- Select word with double-click
  {
    event = { Down = { streak = 2, button = 'Left' } },
    mods = 'NONE',
    action = act.SelectTextAtMouseCursor 'Word',
  },
  -- Select line with triple-click
  {
    event = { Down = { streak = 3, button = 'Left' } },
    mods = 'NONE',
    action = act.SelectTextAtMouseCursor 'Line',
  },
}

-- Hyperlinks with improved rules
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- Add custom domain links
table.insert(config.hyperlink_rules, {
  regex = [[(PR|pr|ISSUE|issue)#(\d+)\b]],
  format = 'https://github.com/your-org/your-repo/pull/$2',
})

-- Add file path detection
table.insert(config.hyperlink_rules, {
  regex = [[\b(file|path):([^:]+):(\d+)(?::(\d+))?]],
  format = function(match)
    local path = match[2]
    local line = match[3]
    local col = match[4] or '1'
    return path .. ':' .. line .. ':' .. col
  end,
})

-- Add custom URL protocols
table.insert(config.hyperlink_rules, {
  regex = [[\b\w+://[\w.-]+(?:/[\w.-/]*)?]],
  format = '$0',
})

-- Scroll configuration
config.scrollback_lines = 10000
config.enable_scroll_bar = true

-- and finally, return the configuration to wezterm
return config
