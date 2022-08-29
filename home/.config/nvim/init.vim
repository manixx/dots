call plug#begin('~/.vim/plugged')

Plug 'sainnhe/edge'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/vim-easy-align'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'scrooloose/nerdcommenter'
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-fugitive'
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'
Plug 'windwp/nvim-autopairs'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npm install'  }

call plug#end()

set colorcolumn=80                    " draw line at col 80
set rnu nu                            " line numbers, relative
set list                              " show hidden characters
set cursorline                        " highlight line where cursor is
set signcolumn=yes                    " show always
set background=dark
set termguicolors                     " enable true colors
set showtabline=2                     " always show tabbar
set noshowmode                        " lightline takes care
set shiftwidth=2
set tabstop=2                         " width of one tab
set spelllang=en,de                   " not enabled by default, check bindings

syntax      enable           " enable syntax highlights
filetype    plugin indent on " enable plugins
colorscheme edge

hi CursorLineNr gui=bold
hi Search       gui=bold
hi SignColumn   guibg=none
hi Normal       guibg=none
hi EndOfBuffer  guibg=none
hi Visual       guibg=Gray

" Set soft-tabs on YAML files
autocmd FileType yaml,helm setlocal ts=2 sts=2 sw=2 expandtab indentkeys-=<:>
" Strip trailing spaces, but keep cursor position
autocmd BufWritePre * execute 'norm m`' | %s/\s\+$//e | norm g``

" lightline
let g:lightline = {
			\ 'colorscheme': 'edge',
			\ 'separator': { 'left': '▙', 'right': '▟' },
			\ 'subseparator': { 'left': '▸', 'right': '◂' },
			\ }

" nerdtree
let g:NERDTreeChDirMode=1
let g:NERDTreeShowHidden=1
let g:NERDTreeWinPos = "right"
let g:NERDTreeRemoveFileCmd = 'trash '
let g:NERDTreeRemoveDirCmd = 'trash '

" indentLine
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_defaultGroup = 'SpecialKey'

" gitgutter
let g:gitgutter_map_keys = 0

" autopairs
lua <<EOF
require('nvim-autopairs').setup{}
EOF

" common
noremap <leader>ss :set spell!<cr>

" fzf
noremap <leader>f   :Files<cr>
noremap <leader>F   :Files ~<cr>
noremap <leader>s   :Rg<cr>
noremap <leader>l   :Lines<cr>
noremap <leader>bl  :BLines<cr>
noremap <leader>gc  :Commits<cr>
noremap <leader>gbc :BCommits<cr>
noremap <leader>sy  :Filetypes<cr>
noremap <leader>bu  :Buffers<cr>
noremap <leader>m   :Marks<cr>

" easy align
xmap ga <Plug>(EasyAlign)

" nerdtree
noremap <leader><tab>   :NERDTreeToggle<cr>
noremap <leader><s-tab> :NERDTreeFocus<cr>
noremap <leader>^       :NERDTreeFind<cr>

" fugitive
noremap <leader>gb :Git blame<cr>
noremap <leader>gg :Git<cr>

" gitgutter
nmap    ]c         <Plug>(GitGutterNextHunk)
nmap    [c         <Plug>(GitGutterPrevHunk)
noremap <leader>gf :GitGutterFold<cr>

" hides lightline on the nerdtree window
augroup filetype_nerdtree
	au!
	au FileType nerdtree call s:disable_lightline_on_nerdtree()
	au WinEnter,BufWinEnter,TabEnter * call s:disable_lightline_on_nerdtree()
augroup END

fu s:disable_lightline_on_nerdtree() abort
	let nerdtree_winnr = index(map(range(1, winnr('$')), {_,v -> getbufvar(winbufnr(v), '&ft')}), 'nerdtree') + 1
	call timer_start(0, {-> nerdtree_winnr && setwinvar(nerdtree_winnr, '&stl', '%#Normal#')})
endfu
