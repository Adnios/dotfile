local ui = {}
local conf = require('modules.ui.config')

ui['glepnir/zephyr-nvim'] = {
  config = [[vim.cmd('colorscheme zephyr')]]
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
  branch = 'lua',
  evnet = 'BufReadPre',
  config = conf.indent_blakline
}

ui['akinsho/nvim-bufferline.lua'] = {
  config = conf.nvim_bufferline,
  requires = 'kyazdani42/nvim-web-devicons'
}

ui['kyazdani42/nvim-tree.lua'] = {
  cmd = {'NvimTreeToggle','NvimTreeOpen'},
  commit = "bbb8d6070f2a35ae85d1790fa3f8fff56c06d4ec",
  config = conf.nvim_tree,
  requires = 'kyazdani42/nvim-web-devicons'
}

ui['lewis6991/gitsigns.nvim'] = {
  event = {'BufReadPre','BufNewFile'},
  config = conf.gitsigns,
  requires = {'nvim-lua/plenary.nvim', opt=true}
}

ui['p00f/nvim-ts-rainbow'] = {
  event = {'BufReadPre', 'BufNewFile'},
  config = conf.rainbow
}

return ui
