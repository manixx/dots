call plug#begin('~/.vim/plugged')

" common tools
Plug 'sainnhe/edge' " main theme
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
Plug 'towolf/vim-helm'
Plug 'tpope/vim-surround'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'windwp/nvim-autopairs'

" lsp
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'hrsh7th/vim-vsnip'
Plug 'ojroques/nvim-lspfuzzy'

call plug#end()

" ##############################################################################
" ## common options
" ##############################################################################

set colorcolumn=80               " draw line at col 80
set rnu nu                       " line numbers, relative
set list                         " show hidden characters
set cursorline                   " highlight line where cursor is
set mouse=a                      " enable mouse integration
set signcolumn=yes               " show always
set background=dark
set termguicolors                " enable true colors
set showtabline=2                " always show tabbar
set noshowmode                   " lightline takes care
set completeopt=menuone,noselect " show menu on one element, do not preselect
set shortmess+=c                 " disable 'Pattern not found error'
set updatetime=100               " update various parts faster (lsp server)
set shiftwidth=2
set tabstop=2
set incsearch
set hlsearch
set spelllang=en,de
set spell

syntax      enable    " enable syntax highlights
filetype    plugin on " enable plugins
colorscheme edge

hi CursorLineNr gui=bold
hi Search       gui=bold
hi SignColumn   guibg=none

" ##############################################################################
" ## buffer settings
" ##############################################################################

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd BufWritePre * execute 'norm m`' | %s/\s\+$//e | norm g``

" ##############################################################################
" ## plugin config
" ##############################################################################

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
let g:vim_json_conceal=0

" gitgutter
let g:gitgutter_map_keys = 0

" vim-javascript
let g:javascript_plugin_jsdoc = 1

" treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  sync_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },
}
EOF

" autopairs
lua <<EOF
require('nvim-autopairs').setup{}
EOF

" ##############################################################################
" ## keybindings
" ##############################################################################

" common
noremap <leader>w  :call ChangeCWD()<cr>
noremap <leader>rf ggVG=

" fzf
noremap <leader>f   :Files<cr>
noremap <leader>F   :Files ~<cr>
noremap <leader>s   :Rg<cr>
noremap <leader>l   :Lines<cr>
noremap <leader>lb  :BLines<cr>
noremap <leader>gc  :Commits<cr>
noremap <leader>gbc :BCommits<cr>
noremap <leader>sy  :Filetypes<cr>
noremap <leader>bu  :Buffers<cr>
noremap <leader>bl  :Lines<cr>

" easy align
xmap ga <Plug>(EasyAlign)

" nerdtree
noremap <leader><tab>   :NERDTreeToggle<cr>
noremap <leader><s-tab> :NERDTreeFocus<cr>
noremap <leader>^       :NERDTreeFind<cr>
noremap <leader><s-S>   :NERDTreeMirror<cr>

" fugitive
noremap <leader>gb :Git blame<cr>
noremap <leader>gs :Git<cr>

" gitgutter
nmap    ]c         <Plug>(GitGutterNextHunk)
nmap    [c         <Plug>(GitGutterPrevHunk)
noremap <leader>gf :GitGutterFold<cr>

" compe
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm(luaeval("require 'nvim-autopairs'.autopairs_cr()"))
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

" lsp
noremap <leader>ldb :LspDiagnostics 0<cr>
noremap <leader>lda :LspDiagnosticsAll<cr>

" ##############################################################################
" ## custom functions
" ##############################################################################

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

" ##############################################################################
" ## LSP config
" ##############################################################################

lua require("lsp-config")
