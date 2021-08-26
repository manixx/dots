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

" lsp 
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'hrsh7th/vim-vsnip'
Plug 'ojroques/nvim-lspfuzzy'

" syntax 
Plug 'jparise/vim-graphql'
Plug 'pangloss/vim-javascript'
Plug 'ekalinin/Dockerfile.vim'

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
"set foldmethod=syntax
"set foldlevelstart=1

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

" vim-javascript 
let g:javascript_plugin_jsdoc = 1

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

" ##############################################################################
" ## LSP config
" ##############################################################################

lua require("lsp-config")
