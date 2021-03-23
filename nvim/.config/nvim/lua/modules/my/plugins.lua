local my = {}
local conf = require('modules.my.config')


my['kevinhwang91/rnvimr'] = {
  cmd = 'RnvimrToggle',
  config = conf.rnvimr
}

--[[ my['lilydjwg/fcitx.vim'] = {
  event = 'BufReadPre'
} ]]

--[[ my['junegunn/vim-peekaboo'] = {
  event = 'BufReadPre'
} ]]

my['thinca/vim-quickrun'] = {
  cmd = 'QuickRun',
  config = conf.quickrun
}

my['airblade/vim-rooter'] = {
  event = 'BufReadPre',
  config = function()
    vim.g.rooter_patterns = {'.git', 'Makefile', '*.sln', 'build/env.sh'}
  end
}

--[[ my['luochen1990/rainbow'] = {
  ft = 'html,css,javascript,javascriptreact,vue,go,python,c,cpp,lua,rust,vim,less,stylus,sass,scss,json,ruby,scala,toml,php,haskell',
  config = conf.rainbow
} ]]

return my
