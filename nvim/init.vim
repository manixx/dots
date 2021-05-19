call plug#begin('~/.vim/plugged')

" common tools
Plug 'sainnhe/edge' " main theme
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-fugitive'
Plug 'Yggdroot/indentLine' 

" lsp 
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
" Plug 'hrsh7th/vim-vsnip'

" syntax
Plug 'jelera/vim-javascript-syntax'
Plug 'jparise/vim-graphql'
Plug 'towolf/vim-helm'

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
set tabstop=2
set completeopt=menuone,noselect " show menu on one element, do not preselect
set shortmess+=c                 " Disable Pattern not found error

syntax      enable    " enable syntax highlights
filetype    plugin on " enable plugins
colorscheme edge

hi CursorLineNr gui=bold
hi Search       gui=bold
hi SignColumn		guibg=none

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
let g:vim_json_syntax_conceal = 0 " dependency of indentLine

" ##############################################################################
" ## keybindings
" ##############################################################################

" common
noremap <leader><esc> :noh<cr>
noremap <leader>w     :call ChangeCWD()<cr>

function! ChangeCWD() 
	call fzf#run({ 
		\ 'source': 'fd --type d --hidden . ~', 
		\ 'options': '--color fg:#5F6471', 
		\ 'down': '~20%', 
		\ 'sink': 'chdir' })
endfunction

" fzf
noremap <leader>f   :Files<cr>
noremap <leader>F   :Files ~<cr>
noremap <leader>s   :Ag<cr>
noremap <leader>bl  :BLines<cr>
noremap <leader>l   :Lines<cr>
noremap <leader>gc  :Commits<cr>
noremap <leader>gbc :BCommits<cr>
noremap <leader>sy  :Filetypes<cr>
noremap <leader>bu  :Buffers<cr>

" easy align  
xmap ga <Plug>(EasyAlign)

" nerdtree
noremap <leader><tab>   :NERDTreeToggle<cr>
noremap <leader><s-tab> :NERDTreeFocus<cr>
noremap <leader>^       :NERDTreeFind<cr>
noremap <leader><s-S>   :NERDTreeMirror<cr>

" fugitive 
noremap <leader>gb :Git blame<cr>

" ##############################################################################
" ## custom syntax files 
" ##############################################################################

" go 
au BufRead,BufNewFile go.mod set filetype=gomod

" ##############################################################################
" ## lsp settings
" ##############################################################################

lua require("lsp-config") 
