local tools = {}
local conf = require('modules.tools.config')

-- tools['kristijanhusak/vim-dadbod-ui'] = {
--   cmd = {'DBUIToggle','DBUIAddConnection','DBUI','DBUIFindBuffer','DBUIRenameBuffer'},
--   config = conf.vim_dadbod_ui,
--   requires = {{'tpope/vim-dadbod',opt = true}}
-- }

--[[ tools['editorconfig/editorconfig-vim'] = {
  ft = { 'go','typescript','javascript','vim','rust','zig','c','cpp' }
} ]]

-- tools['vim-save/prodoc.nvim'] = {
--   event = 'BufReadPre'
-- }

tools['tomtom/tcomment_vim'] = {
  evnet = 'BufReadPre'
}


-- tools['b3nj5m1n/kommentary'] = {
--   event = 'BufReadPre',
--   config = conf.kommentary
-- }

tools['liuchengxu/vista.vim'] = {
  cmd = 'Vista',
  config = conf.vim_vista
}

--[[ tools['brooth/far.vim'] = {
  cmd = {'Far','Farp'},
  config = function ()
    vim.g['far#source'] = 'rg'
  end
} ]]

tools['iamcco/markdown-preview.nvim'] = {
  ft = 'markdown',
  config = function ()
    vim.g.mkdp_auto_start = 0
  end
}


tools['nacro90/numb.nvim'] = {
  config = function ()
    require('numb').setup{
      show_numbers = true, -- Enable 'number' for the window while peeking
      show_cursorline = true -- Enable 'cursorline' for the window while peeking
    }
  end
}

return tools
