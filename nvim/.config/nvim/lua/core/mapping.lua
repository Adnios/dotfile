local bind = require('keymap.bind')
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd

-- default map
local def_map = {
    -- Vim map
    ["n|<C-x>h"]     = map_cr('set hls!'):with_noremap():with_silent(),
    ["n|<C-x>k"]     = map_cr('bdelete'):with_noremap():with_silent(),
    ["n|Y"]          = map_cmd('y$'),
    ["n|]b"]         = map_cu('bn'):with_noremap(),
    ["n|[b"]         = map_cu('bp'):with_noremap(),
    ["n|<C-h>"]      = map_cmd('<C-w>h'):with_noremap(),
    ["n|<C-l>"]      = map_cmd('<C-w>l'):with_noremap(),
    ["n|<C-j>"]      = map_cmd('<C-w>j'):with_noremap(),
    ["n|<C-k>"]      = map_cmd('<C-w>k'):with_noremap(),
    ["n|<A-[>"]      = map_cr('vertical resize -5'),
    ["n|<A-]>"]      = map_cr('vertical resize +5'),
    ["n|<Leader>ss"] = map_cu('SessionSave'):with_noremap(),
    ["n|<Leader>sl"] = map_cu('SessionLoad'):with_noremap(),
  -- command line
    ["c|<C-b>"]      = map_cmd('<Left>'):with_noremap(),
    ["c|<C-f>"]      = map_cmd('<Right>'):with_noremap(),
    ["c|<C-a>"]      = map_cmd('<Home>'):with_noremap(),
    ["c|<C-e>"]      = map_cmd('<End>'):with_noremap(),
    ["c|<C-d>"]      = map_cmd('<Del>'):with_noremap(),
    ["c|<C-h>"]      = map_cmd('<BS>'):with_noremap(),
    ["c|<C-t>"]      = map_cmd([[<C-R>=expand("%:p:h") . "/" <CR>]]):with_noremap(),
    ["c|w!!"] = map_cmd("execute 'silent! write !sudo tee % >/dev/null' <bar> edit!"),
}

bind.nvim_load_mapping(def_map)
