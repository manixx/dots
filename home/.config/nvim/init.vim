call plug#begin('~/.vim/plugged')
Plug 'sainnhe/edge'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/vim-easy-align'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'Yggdroot/indentLine'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
call plug#end()

set colorcolumn=80
set nu rnu
set list
set cursorline
set signcolumn=yes
set background=dark
set termguicolors
set showtabline=2
set noshowmode
set shiftwidth=2
set tabstop=2
set spell
set spelllang=en,de
set listchars=tab:→\ ,multispace:·,trail:•,extends:↩
set statuscolumn=%l\ %s%C%=%T%r│%T

syntax      enable
filetype    plugin indent on
colorscheme edge

hi NonText      guifg=Gray
hi Whitespace   guifg=Gray
hi CursorLineNr gui=bold
hi Search       gui=bold
hi SignColumn   guibg=none
hi Normal       guibg=none
hi EndOfBuffer  guibg=none
hi Visual       guibg=Gray
hi NormalNC     guibg=none

autocmd FileType yaml,helm setlocal ts=2 sts=2 sw=2 expandtab indentkeys-=<:>
autocmd BufWritePre * execute 'norm m`' | %s/\s\+$//e | norm g``

let g:lightline = {
	\ 'colorscheme': 'edge',
	\ 'separator': { 'left': '▙', 'right': '▟' },
	\ 'subseparator': { 'left': '▸', 'right': '◂' },
	\ }
let g:NERDTreeChDirMode=1
let g:NERDTreeShowHidden=1
let g:NERDTreeWinPos = "right"
let g:NERDTreeRemoveFileCmd = 'trash '
let g:NERDTreeRemoveDirCmd = 'trash '
let g:NERDTreeMinimalMenu=1
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:gitgutter_map_keys = 0
let g:vim_json_conceal = 0 " show JSON quotes
let g:indentLine_setColors = 0 " use theme colours

noremap <leader>f       :Files<cr>
noremap <leader>F       :Files ~<cr>
noremap <leader>s       :Rg<cr>
noremap <leader>l       :Lines<cr>
noremap <leader>bl      :BLines<cr>
noremap <leader>c       :Commits<cr>
noremap <leader>bc      :BCommits<cr>
noremap <leader>sy      :Filetypes<cr>
noremap <leader>bu      :Buffers<cr>
noremap <leader>m       :Marks<cr>
noremap <leader><tab>   :NERDTreeToggle<cr>
noremap <leader><s-tab> :NERDTreeFocus<cr>
noremap <leader>^       :NERDTreeFind<cr>
noremap <leader>gb      :Git blame<cr>
noremap <leader>g       :Git<cr>
noremap ]c              <Plug>(GitGutterNextHunk)
noremap [c              <Plug>(GitGutterPrevHunk)
noremap <leader>gf      :GitGutterFold<cr>
xmap    ga              <Plug>(EasyAlign)

lua << EOF
require'nvim-treesitter.configs'.setup {
	ensure_installed = { "terraform" },
	auto_install = false,
	highlight = {
		enable = true,
	}
}
EOF
