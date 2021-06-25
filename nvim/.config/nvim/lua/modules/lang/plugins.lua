local lang = {}
local conf = require('modules.lang.config')

-- lang['ziglang/zig.vim'] = {
--   ft = { 'zig','zir' }
-- }

-- lang['sheerun/vim-polyglot'] = {
--   event = 'BufRead',
--   config = conf.polyglot_config,
--   setup = conf.polyglot_setup
-- }


-- lang['andymass/vim-matchup'] = {
--   config = function ()
--     vim.g.matchup_matchparen_enabled = 0
--     vim.g.matchup_matchparen_fallback = 0
--   end
-- }

lang['nvim-treesitter/nvim-treesitter'] = {
  -- event = 'BufRead',
  -- event = {'BufReadPre', 'BufNewFile'},
  -- after = 'telescope.nvim',
  config = conf.nvim_treesitter,
}

lang['nvim-treesitter/nvim-treesitter-textobjects'] = {
  after = 'nvim-treesitter'
}

return lang
