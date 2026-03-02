local wezterm = require 'wezterm'
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

local config = wezterm.config_builder()

tabline.setup({
  options = {
    icons_enabled = true,
    theme = 'Dracula (Official)',
    tabs_enabled = true,
    theme_overrides = {
      tab = {
        inactive = { bg = "#21222c", fg = "#bd93f9", },
        active = { bg = "#282a36", fg = "#f8f8f2", },
    },
    },
    section_separators = {
      left = wezterm.nerdfonts.pl_left_hard_divider,
      right = wezterm.nerdfonts.pl_right_hard_divider,
    },
    component_separators = {
      left = wezterm.nerdfonts.pl_left_soft_divider,
      right = wezterm.nerdfonts.pl_right_soft_divider,
    },
    tab_separators = {
      left = wezterm.nerdfonts.pl_left_hard_divider,
      right = wezterm.nerdfonts.pl_right_hard_divider,
    },
  },
  sections = {
    tabline_a = { 'mode' },
    tabline_b = { 'workspace' },
    tabline_c = { ' ' },
    tab_active = {
      'index',
      { 'parent', padding = 0 },
      '/',
      { 'cwd', padding = { left = 0, right = 1 } },
      { 'zoomed', padding = 0 },
    },
    tab_inactive = { 'index', { 'process', padding = { left = 0, right = 1 } } },
    tabline_x = { },
    tabline_y = { 'hostname', 'datetime' },
    tabline_z = { 'domain' },
  },
  extensions = {},
})
tabline.apply_to_config(config)

-- Configure your leader key (recommended to avoid conflicts)
config.leader = { key = "a", mods = "CTRL" }  -- Use Ctrl+a instead of default Ctrl+b

-- Apply wez-tmux plugin with optional configuration
-- require("plugins.wez-tmux.plugin").apply_to_config(config, {
    -- Optional: Customize tab index base (0-based or 1-based)
    -- tab_and_split_indices_are_zero_based = true
-- })
config.keys = {
  -- Turn off the default CMD-m Hide action, allowing CMD-m to
  -- be potentially recognized and handled by the tab
  {
    key = 'h',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivatePaneDirection "Left",
  },
  {
    key = 'l',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivatePaneDirection "Right",
  },
  {
    key = 'k',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivatePaneDirection "Up",
  },
  {
    key = 'j',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivatePaneDirection "Down",
  },
}

config.default_prog = { 'c:/Program Files/Git/bin/bash.exe', '-l' }
config.color_scheme = "Dracula (Official)" -- https://wezterm.org/colorschemes/d/index.html#dracula-official

return config
