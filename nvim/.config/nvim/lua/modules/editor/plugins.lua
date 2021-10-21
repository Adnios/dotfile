local editor = {}
local conf = require('modules.editor.config')

editor['Raimondi/delimitMate'] = {
  event = 'InsertEnter',
  config = conf.delimimate,
}

-- editor['rhysd/accelerated-jk'] = {
--   opt = true
-- }
-- editor['PHSix/faster.nvim'] = {
--   event = {"VimEnter *"},
--   config = function ()
--     vim.api.nvim_set_keymap('n', 'j', '<Plug>(faster_move_j)', {noremap=false, silent=true})
--     vim.api.nvim_set_keymap('n', 'k', '<Plug>(faster_move_k)', {noremap=false, silent=true})
--   end
-- }

editor['norcalli/nvim-colorizer.lua'] = {
  -- ft = { 'html','css','sass','vim','typescript','typescriptreact'},
  event = {'BufReadPre', 'BufNewFile'},
  config = conf.nvim_colorizer
}

--[[ editor['itchyny/vim-cursorword'] = {
  event = {'BufReadPre','BufNewFile'},
  config = conf.vim_cursorwod
} ]]

editor['hrsh7th/vim-eft'] = {
  opt = true,
  config = function()
    vim.g.eft_ignorecase = true
  end
}

editor['kana/vim-operator-replace'] = {
  keys = {{'x','p'}},
  config = function()
    vim.api.nvim_set_keymap("x", "p", "<Plug>(operator-replace)",{silent =true})
  end,
  requires = 'kana/vim-operator-user'
}

editor['rhysd/vim-operator-surround'] = {
  event = 'BufRead',
  requires = 'kana/vim-operator-user'
}

editor['kana/vim-niceblock']  = {
  opt = true
}

return editor
