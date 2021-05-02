call plug#begin('~/.vim/plugged')

" common tools
Plug 'sainnhe/edge' " main theme
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'scrooloose/nerdtree'
Plug 'itchyny/lightline.vim'

" lsp 
Plug 'neovim/nvim-lspconfig'

" syntax

call plug#end()

" ##############################################################################
" ## common options
" ##############################################################################

set colorcolumn=80
set rnu nu
set list          " show hidden characters
set cursorline
set mouse=a       " enable mouse integration
set signcolumn=yes
set background=dark 
set termguicolors " enable true colors
set showtabline=2 " always show tabbar
set noshowmode    " lightline takes care
set tabstop=2

syntax      on
filetype    plugin on
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

" ##############################################################################
" ## keybindings
" ##############################################################################

" common
noremap <leader><esc>   :noh<cr>
noremap <leader>w       :call ChangeCWD()<cr>

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

" ##############################################################################
" ## lsp settings
" ##############################################################################

lua require("lsp-config") 
