local config = {}

function config.rnvimr()
  vim.g.rnvimr_enable_ex = 1
  vim.g.rnvimr_enable_bw = 1
  vim.g.rnvimr_enable_picker = 1
  vim.g.rnvimr_draw_border = 0
  vim.g.rnvimr_border_attr = {fg = 3}
  vim.g.rnvimr_ranger_cmd = 'ranger --cmd="set column_ratios 1,1"'
  vim.api.nvim_command('highlight link RnvimrNormal CursorLine')
end

function config.quickrun()
  vim.g.quickrun_no_default_key_mappings = 1
end

-- I do not want to install texlive which is too big
--[[ function config.vimtex()
  -- " let g:tex_flavor='latex'
  -- " let g:tex_flavor='XeLaTex'
  -- set conceallevel=1
  vim.g.tex_flavor='xelatex'
  vim.g.vimtex_view_method='zathura'
  vim.g.vimtex_quickfix_mode=0
  vim.g.tex_conceal='abdmg'
  vim.g.vimtex_compiler_progname = 'nvr'
end ]]

function config.lastplace()
  vim.g.lastplace_ignore = "gitcommit,gitrebase,svn,hgcommit"
  vim.g.lastplace_ignore_buftype = "quickfix,nofile,help"
  vim.g.lastplace_open_folds = 0
end

function config.rainbow()
  vim.g.rainbow_active = 1
end

function config.toggleterm()
  local large_screen = vim.o.columns > 200
  require("toggleterm").setup {
    size = (large_screen and vim.o.columns * 0.5 or 15),
    open_mapping = [[<c-\>]],
    direction = large_screen and "vertical" or "horizontal"
  }
end

return config
