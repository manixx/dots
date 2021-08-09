call plug#begin('~/.vim/plugged')

" common tools
Plug 'sainnhe/edge' " main theme
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-fugitive'
Plug 'Yggdroot/indentLine' 
Plug 'airblade/vim-gitgutter'

" lsp 
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'hrsh7th/vim-vsnip'
Plug 'ojroques/nvim-lspfuzzy'

" syntax
Plug 'jelera/vim-javascript-syntax'
Plug 'jparise/vim-graphql'
Plug 'towolf/vim-helm'
Plug 'leafgarland/typescript-vim' 
Plug 'hashivim/vim-terraform' 
Plug 'vim-scripts/nginx.vim'

call plug#end()

" ##############################################################################
" ## common options
" ##############################################################################

set colorcolumn=80
set rnu nu
set list                         " show hidden characters
set cursorline
set mouse=a                      " enable mouse integration
set signcolumn=yes
set background=dark 
set termguicolors                " enable true colors
set showtabline=2                " always show tabbar
set noshowmode                   " lightline takes care
set completeopt=menuone,noselect " show menu on one element, do not preselect
set shortmess+=c                 " Disable Pattern not found error
set updatetime=100
set shiftwidth=2
set tabstop=2
set foldmethod=syntax
set foldlevelstart=1

let javaScript_fold=1         " JavaScript
let perl_fold=1               " Perl
let php_folding=1             " PHP
let r_syntax_folding=1        " R
let ruby_fold=1               " Ruby
let sh_fold_enabled=1         " sh
let vimsyn_folding='af'       " Vim script
let xml_syntax_folding=1      " XML

syntax      enable    " enable syntax highlights
filetype    plugin on " enable plugins
colorscheme edge

hi CursorLineNr gui=bold
hi Search       gui=bold
hi SignColumn   guibg=none

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

" ##############################################################################
" ## keybindings
" ##############################################################################

" common
noremap <leader><esc> :noh<cr>
noremap <leader>w     :call ChangeCWD()<cr>

function! ChangeCWD() 
	call fzf#run(fzf#wrap({ 
				\ 'source': 'fd --type d --hidden . ~', 
				\ 'options': ['--prompt', 'cwd > '], 
				\ 'sink': 'chdir' }))
endfunction

" fzf
noremap <leader>f   :Files<cr>
noremap <leader>F   :Files ~<cr>
noremap <leader>s   :Ag<cr>
noremap <leader>l   :Lines<cr>
noremap <leader>gc  :Commits<cr>
noremap <leader>gbc :BCommits<cr>
noremap <leader>sy  :Filetypes<cr>
noremap <leader>bu  :Buffers<cr>

command! -bang -nargs=* LinesWithPreview
			\ call fzf#vim#grep(
			\   'rg --with-filename --column --line-number --no-heading --color=always --smart-case . '.fnameescape(expand('%')), 1,
			\   fzf#vim#with_preview({'options': '--delimiter : --nth 4.. --no-sort'}, 'up:50%', '?'),
			\   1)
nnoremap <leader>bl :LinesWithPreview<CR>

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

" ##############################################################################
" ## custom syntax files 
" ##############################################################################

" ##############################################################################
" ## lsp settings
" ##############################################################################

lua require("lsp-config") 
