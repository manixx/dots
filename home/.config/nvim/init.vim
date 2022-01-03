call plug#begin('~/.vim/plugged')

" common tools
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
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" lsp
"Plug 'neovim/nvim-lspconfig'
"Plug 'hrsh7th/vim-vsnip'
"Plug 'ojroques/nvim-lspfuzzy'

" cmp (completion)
"Plug 'hrsh7th/cmp-nvim-lsp'
"Plug 'hrsh7th/cmp-buffer'
"Plug 'hrsh7th/cmp-path'
"Plug 'hrsh7th/cmp-cmdline'
"Plug 'hrsh7th/nvim-cmp'
"Plug 'hrsh7th/cmp-vsnip'
"Plug 'hrsh7th/vim-vsnip'

call plug#end()

set colorcolumn=80 " draw line at col 80
set rnu nu         " line numbers, relative
set list           " show hidden characters
set cursorline     " highlight line where cursor is
set signcolumn=yes " show always
set background=dark
set termguicolors  " enable true colors
set showtabline=2  " always show tabbar
set noshowmode     " lightline takes care
set shiftwidth=2   " make tabstops default
set tabstop=2
set incsearch
set hlsearch
set spelllang=en,de

syntax      enable    " enable syntax highlights
filetype    plugin on " enable plugins
colorscheme edge

hi CursorLineNr gui=bold
hi Search       gui=bold
hi SignColumn   guibg=none

" Set soft-tabs on YAML files
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
" Strip trailing spaces but keep cursor position
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

" indentLine
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_defaultGroup = 'SpecialKey'
let g:indentLine_setConceal = 0

" gitgutter
let g:gitgutter_map_keys = 0

" vim-javascript
let g:javascript_plugin_jsdoc = 1

" autopairs
lua <<EOF
require('nvim-autopairs').setup{}
EOF

" treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  sync_install = true,
  highlight = {
    enable = true,
    disable = { "vim", "rust" },
    additional_vim_regex_highlighting = false,
  },
}
EOF

" common
noremap <leader>w  :call ChangeCWD()<cr>
noremap <leader>rf maggVG='a
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
noremap <leader>gs :Git<cr>

" gitgutter
nmap    ]c         <Plug>(GitGutterNextHunk)
nmap    [c         <Plug>(GitGutterPrevHunk)
noremap <leader>gf :GitGutterFold<cr>

" sets the current working dir, by opening an FZF session
" with an list all dirs from starting from the home dir.
function! ChangeCWD()
	call fzf#run(fzf#wrap({
				\ 'source': 'fd --type d --hidden --no-ignore . ~',
				\ 'options': ['--prompt', 'cwd > '],
				\ 'sink': 'chdir' }))
endfunction

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
