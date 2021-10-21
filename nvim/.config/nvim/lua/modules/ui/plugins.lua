local ui = {}
local conf = require('modules.ui.config')

ui['glepnir/zephyr-nvim'] = {
  config = [[vim.cmd('colorscheme zephyr')]]
}

ui['folke/tokyonight.nvim'] = {
  -- config = [[vim.cmd('colorscheme tokyonight')]]
}

ui['glepnir/dashboard-nvim'] = {
  config = conf.dashboard
}

ui['glepnir/galaxyline.nvim'] = {
  branch = 'main',
  config = conf.galaxyline,
  requires = 'kyazdani42/nvim-web-devicons'
}

ui['lukas-reineke/indent-blankline.nvim'] = {
  evnet = 'BufReadPre',
  config = conf.indent_blakline
}

ui['akinsho/nvim-bufferline.lua'] = {
  config = conf.nvim_bufferline,
  requires = 'kyazdani42/nvim-web-devicons'
}

ui['kyazdani42/nvim-tree.lua'] = {
  -- cmd = {'NvimTreeToggle','NvimTreeOpen'},
  config = conf.nvim_tree,
  requires = 'kyazdani42/nvim-web-devicons'
}

ui['lewis6991/gitsigns.nvim'] = {
  event = {'BufReadPre','BufNewFile'},
  config = conf.gitsigns,
  requires = {'nvim-lua/plenary.nvim', opt=true}
}

-- ui['p00f/nvim-ts-rainbow'] = {
--   event = {'BufReadPre', 'BufNewFile'},
--   config = conf.rainbow
-- }

ui['folke/zen-mode.nvim'] = {
  opt = true,
  cmd = 'ZenMode',
  config = function ()
    require('zen-mode').setup {}
  end
}

return ui
