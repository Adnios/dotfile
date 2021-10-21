---------- COC CONFIG ----------

local eval = vim.api.nvim_eval
local nnoremap = vim.keymap.nnoremap
local nmap = vim.keymap.nmap
local inoremap = vim.keymap.inoremap

vim.opt.completeopt = { 'menuone', 'noinsert', 'noselect' }

local show_documentation = function()
    if eval("index(['vim','help'], &filetype)") >= 0 then
        vim.cmd([[execute 'h '.expand('<cword>')]])
    else
        vim.fn.CocAction('doHover')
    end
end

-- Use tagstack for go to definition
local goto_definition = function()
    local from = { vim.fn.bufnr('%'), vim.fn.line('.'), vim.fn.col('.'), 0 }
    local items = { { tagname = vim.fn.expand('<cword>'), from = from } }

    vim.fn.settagstack(vim.fn.win_getid(), { items = items }, 't')
    vim.cmd('Telescope coc definitions')
end

-- stylua: ignore start
nnoremap({ 'gd', function() goto_definition() end })
nnoremap({ 'gb', '<C-t>' })
nnoremap({ 'K', function() show_documentation() end })
nmap({ 'gR', '<Plug>(coc-rename})' })
nmap({ 'gr', '<cmd>Telescope coc references<CR>' })
nmap({ 'gn', '<Plug>(coc-diagnostic-next)' })
nmap({ 'gp', '<Plug>(coc-diagnostic-prev)' })
nnoremap({ '<leader>ca', ':CocAction<CR>' })
nmap({ '<leader>cd', '<Plug>(coc-diagnostic-info)' })
inoremap({ '<c-space>', 'coc#refresh()', expr = true })
-- stylua: ignore end

-- Autoimport packages
vim.cmd(
    [[inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]]
)

vim.cmd(
    [[inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"]]
)

vim.cmd(
    [[inoremap <silent><expr> <TAB>
          \ pumvisible() ? "\<C-n>" :
          \ <SID>check_back_space() ? "\<TAB>" :
          \ coc#refresh()]]
)

vim.g.coc_snippet_next = '<TAB>'
vim.g.coc_snippet_prev = '<S-TAB>'
vim.g.coc_status_error_sign = '•'
vim.g.coc_status_warning_sign = '•'
vim.g.coc_disable_transparent_cursor = 1
vim.g.coc_global_extensions = {
                \ 'coc-pyright',
                \ 'coc-git',
                \ 'coc-gitignore',
                \ 'coc-tabnine',
                \ 'coc-json',
                \ 'coc-highlight',
                \ 'coc-snippets',
                \ 'coc-lists',
                \ 'coc-lua',
                \ 'coc-yaml',
                \ 'coc-marketplace',
                \ 'coc-lua',
                \ 'coc-vimlsp'
                \ }
