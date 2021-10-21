local config = {}

function config.galaxyline()
  require('modules.ui.eviline')
end

function config.nvim_bufferline()
  -- require('bufferline').setup{
  --   options = {
  --     modified_icon = '✥',
  --     buffer_close_icon = 'x',
  --     mappings = true,
  --     always_show_bufferline = false,
  --   }
  -- }
  require('bufferline').setup {
    options = {
      right_mouse_command = 'vert sbuffer %d',
      show_close_icon = false,
      ---based on https://github.com/kovidgoyal/kitty/issues/957
      separator_style = os.getenv 'KITTY_WINDOW_ID' and 'slant' or 'padded_slant',
      diagnostics = 'nvim_lsp',
      -- diagnostics_indicator = diagnostics_indicator,
      -- custom_filter = custom_filter,
      offsets = {
        {
          filetype = 'undotree',
          text = 'Undotree',
          highlight = 'PanelHeading',
          padding = 1,
        },
        {
          filetype = 'NvimTree',
          text = 'Explorer',
          highlight = 'PanelHeading',
          padding = 1,
        },
        {
          filetype = 'DiffviewFiles',
          text = 'Diff View',
          highlight = 'PanelHeading',
          padding = 1,
        },
        {
          filetype = 'flutterToolsOutline',
          text = 'Flutter Outline',
          highlight = 'PanelHeading',
        },
        {
          filetype = 'packer',
          text = 'Packer',
          highlight = 'PanelHeading',
          padding = 1,
        },
      },
    },
  }
end

function config.dashboard()

  local home = os.getenv('HOME')
  vim.g.dashboard_footer_icon = '🐬 '
  vim.g.dashboard_preview_command = 'cat'
  vim.g.dashboard_preview_pipeline = 'lolcat'
  vim.g.dashboard_preview_file = home .. '/.config/nvim/static/neovim.cat'
  -- vim.g.dashboard_preview_file = home .. '/.config/nvim/static/info.txt'
  vim.g.dashboard_preview_file_height = 12
  vim.g.dashboard_preview_file_width = 80
  vim.g.dashboard_default_executive = 'telescope'
  vim.g.dashboard_custom_section = {
    last_session = {
      description = {'  Recently laset session                  SPC s l'},
      command =  'SessionLoad'},
    find_history = {
      description = {'  Recently opened files                   SPC f h'},
      command =  'DashboardFindHistory'},
    find_file  = {
      description = {'  Find  File                              SPC f f'},
      command = 'Telescope find_files find_command=rg,--hidden,--files'},
    new_file = {
     description = {'  File Browser                            SPC f b'},
     command =  'Telescope file_browser'},
    find_word = {
     description = {'  Find  word                              SPC f w'},
     command = 'DashboardFindWord'},
    find_dotfiles = {
     description = {'  Open Personal dotfiles                  SPC f d'},
     command = 'Telescope dotfiles path=' .. home ..'/dotfile'},
  }
end

function config.nvim_tree()
  local tree_cb = require'nvim-tree.config'.nvim_tree_callback
  require('nvim-tree').setup {
      gitignore = true,
      ignore = {'.git', 'node_modules', '.cache'},
      open_on_tab = false,
      disable_netrw = true,
      hijack_netrw = true,
      auto_close = true,
      update_cwd = true,
      highlight_opened_files = true,
      auto_ignore_ft = {'startify', 'dashboard'},
      update_focused_file = {
          enable = true,
          update_cwd = true,
          ignore_list = {}
      },
      view = {
          width = 30,
          side = 'left',
          auto_resize = false,
          mappings = {
              custom_only = true,
              -- list of mappings to set on the tree manually
              list = {
                  {
                      key = {"<CR>", "o", "<2-LeftMouse>"},
                      cb = tree_cb("edit")
                  }, {key = {"<2-RightMouse>", "<C-]>"}, cb = tree_cb("cd")},
                  {key = "<C-v>", cb = tree_cb("vsplit")},
                  {key = "<C-x>", cb = tree_cb("split")},
                  {key = "<C-t>", cb = tree_cb("tabnew")},
                  {key = "<", cb = tree_cb("prev_sibling")},
                  {key = ">", cb = tree_cb("next_sibling")},
                  {key = "P", cb = tree_cb("parent_node")},
                  {key = "<BS>", cb = tree_cb("close_node")},
                  {key = "<S-CR>", cb = tree_cb("close_node")},
                  {key = "<Tab>", cb = tree_cb("preview")},
                  {key = "K", cb = tree_cb("first_sibling")},
                  {key = "J", cb = tree_cb("last_sibling")},
                  {key = "I", cb = tree_cb("toggle_ignored")},
                  {key = "H", cb = tree_cb("toggle_dotfiles")},
                  {key = "R", cb = tree_cb("refresh")},
                  {key = "a", cb = tree_cb("create")},
                  {key = "d", cb = tree_cb("remove")},
                  {key = "r", cb = tree_cb("rename")},
                  {key = "<C-r>", cb = tree_cb("full_rename")},
                  {key = "x", cb = tree_cb("cut")},
                  {key = "c", cb = tree_cb("copy")},
                  {key = "p", cb = tree_cb("paste")},
                  {key = "y", cb = tree_cb("copy_name")},
                  {key = "Y", cb = tree_cb("copy_path")},
                  {key = "gy", cb = tree_cb("copy_absolute_path")},
                  {key = "[c", cb = tree_cb("prev_git_item")},
                  {key = "]c", cb = tree_cb("next_git_item")},
                  {key = "-", cb = tree_cb("dir_up")},
                  {key = "s", cb = tree_cb("system_open")},
                  {key = "q", cb = tree_cb("close")},
                  {key = "g?", cb = tree_cb("toggle_help")}
              }
          }
      }
  }
end


function config.gitsigns()
  if not packer_plugins['plenary.nvim'].loaded then
    vim.cmd [[packadd plenary.nvim]]
  end
  require('gitsigns').setup {
    signs = {
      add = {hl = 'GitGutterAdd', text = '▋'},
      change = {hl = 'GitGutterChange',text= '▋'},
      delete = {hl= 'GitGutterDelete', text = '▋'},
      topdelete = {hl ='GitGutterDeleteChange',text = '▔'},
      changedelete = {hl = 'GitGutterChange', text = '▎'},
    },
    keymaps = {
       -- Default keymap options
       noremap = true,
       buffer = true,

       ['n ]g'] = { expr = true, "&diff ? ']g' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'"},
       ['n [g'] = { expr = true, "&diff ? '[g' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'"},

       ['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
       ['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
       ['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
       ['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
       ['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line()<CR>',

       -- Text objects
       ['o ih'] = ':<C-U>lua require"gitsigns".text_object()<CR>',
       ['x ih'] = ':<C-U>lua require"gitsigns".text_object()<CR>'
     },
      watch_gitdir = {interval = 1000, follow_files = true},
      current_line_blame = true,
      current_line_blame_opts = {delay = 1000, virtual_text_pos = 'eol'},
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil, -- Use default
      word_diff = false,
      diff_opts = {internal = true}
  }
end

function config.rainbow()
  require'nvim-treesitter.configs'.setup {
    rainbow = {
      enable = true
    }
  }
end

function config.blankline()
  vim.g.indent_blankline_buftype_exclude = {'terminal'}
  vim.g.indent_blankline_filetype_exclude = {'help', 'startify', 'dashboard', 'packer', }
  vim.g.indent_blankline_char = '▏'
  vim.g.indent_blankline_use_treesitter=true
  -- vim.g.indent_blankline_show_current_context = true
  -- vim.g.indent_blankline_context_patterns = {'class', 'function', 'method', '^if', '^while', 'div', '^for', '^object', '^table', 'block', 'arguments'}
end


function config.indent_blakline()
  vim.g.indent_blankline_char = "│"
  vim.g.indent_blankline_show_first_indent_level = true
  vim.g.indent_blankline_filetype_exclude = {
    "startify",
    "dashboard",
    "dotooagenda",
    "log",
    "fugitive",
    "gitcommit",
    "packer",
    "vimwiki",
    "markdown",
    "json",
    "txt",
    "vista",
    "help",
    "todoist",
    "NvimTree",
    "peekaboo",
    "git",
    "TelescopePrompt",
    "undotree",
    "flutterToolsOutline",
    "" -- for all buffers without a file type
  }
  vim.g.indent_blankline_buftype_exclude = {"terminal", "nofile"}
  vim.g.indent_blankline_show_trailing_blankline_indent = false
  vim.g.indent_blankline_show_current_context = true
  vim.g.indent_blankline_context_patterns = {
    "class",
    "function",
    "method",
    "block",
    "list_literal",
    "selector",
    "^if",
    "^table",
    "if_statement",
    "while",
    "for"
  }
  -- because lazy load indent-blankline so need readd this autocmd
  vim.cmd('autocmd CursorMoved * IndentBlanklineRefresh')
end

return config
