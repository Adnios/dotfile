" adding autocmd FileType python make this working
" only python.vim need this to make these settings work
" autocmd FileType python setlocal noexpandtab     " Don't expand tabs to spaces
autocmd FileType python setlocal tabstop=4       " The number of spaces a tab is
autocmd FileType python setlocal shiftwidth=4    " Number of spaces to use in auto(indent)
autocmd FileType python setlocal softtabstop=-1  " Automatically keeps in sync with shiftwidth
autocmd FileType python setlocal smarttab        " Tab insert blanks according to 'shiftwidth'
autocmd FileType python setlocal autoindent      " Use same indenting on new lines
autocmd FileType python setlocal smartindent     " Smart autoindenting on new lines
autocmd FileType python setlocal shiftround      " Round indent to multiple of 'shiftwidth'
