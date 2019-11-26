call plug#begin('~/.vim/plugged')

" tools 
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/vim-easy-align'
Plug 'mcchrish/nnn.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-fugitive'
Plug 'severin-lemaignan/vim-minimap'
Plug 'easymotion/vim-easymotion'

" themes 
Plug 'sainnhe/edge'
Plug 'morhetz/gruvbox'
Plug 'sainnhe/gruvbox-material'

" syntax highlight
Plug 'pangloss/vim-javascript' 
Plug 'leafgarland/typescript-vim' 
Plug 'jparise/vim-graphql'
Plug 'chr4/nginx.vim'
Plug 'delphinus/vim-firestore'

" code completion & dev tools
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'editorconfig/editorconfig-vim'

call plug#end()

"
" general settings
"

set rnu nu
set cursorline
set mouse=a
set noshowmode
set cmdheight=2
set updatetime=300
set shortmess+=c
set signcolumn=yes
set tabstop=8
set shiftwidth=2 noexpandtab 
set showtabline=2

syntax on
filetype plugin on

"
" key bindings 
" 

" fugitive 
noremap <leader>gb :Gblame<cr>

" NERDTree
noremap <leader><tab>   :NERDTreeToggle<cr>
noremap <leader><s-tab> :NERDTreeFocus<cr>
noremap <leader>w       :NERDTree<space>
noremap <leader>^       :NERDTreeFind<cr>

" fzf 
noremap <leader>f :Files<cr>
noremap <leader>F :Files<space>
noremap <leader>l :Lines<cr>
noremap <leader>s :Rg<cr>
noremap <leader>c :Commits<cr>

" nnn 
noremap <leader>b :NnnPicker<cr>

" copy/paste
noremap <leader>y     "+y
noremap <leader>p     "+p
noremap <leader><esc> :noh<cr>

" coc
nnoremap <silent> <space>y :<C-u>CocList -A --normal yank<cr>
nnoremap <silent> <space>l :<C-u>CocList lines<cr>

" easy align  

xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

"
" coc settings
"

" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()

inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

autocmd CursorHold * silent call CocActionAsync('highlight')

nmap <leader>rn <Plug>(coc-rename)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

nnoremap <silent> <space>a :<C-u>CocList diagnostics<cr>
nnoremap <silent> <space>e :<C-u>CocList extensions<cr>
nnoremap <silent> <space>c :<C-u>CocList commands<cr>
nnoremap <silent> <space>o :<C-u>CocList outline<cr>
nnoremap <silent> <space>s :<C-u>CocList -I symbols<cr>
nnoremap <silent> <space>j :<C-u>CocNext<CR>
nnoremap <silent> <space>k :<C-u>CocPrev<CR>
nnoremap <silent> <space>p :<C-u>CocListResume<CR>

" 
" NERDTree settings 
"

let g:NERDTreeChDirMode=1
let g:NERDTreeShowHidden=1

"
" theme settings 
"

set background=dark
colorscheme edge

" hightlight chars at 80 length
highlight OverLength ctermfg=red cterm=bold
match OverLength /\%81v.\+/

" highlight comments in jsonc correctly 
autocmd FileType json syntax match Comment +\/\/.\+$+

" customizations
hi CursorLineNr ctermbg=none cterm=bold

"
" lightline settings
"

let g:lightline = {
  \ 'colorscheme': 'wombat',
  \ 'active': {
  \   'left': [ 
  \     [ 'mode', 'paste' ],
  \     [ 'ctrlpmark', 'cocstatus', 'readonly', 'filename', 'modified', 'method', 'git' ] 
  \   ]
  \ },
  \ 'component_function': {
  \   'cocstatus': 'coc#status'
  \ },
  \ }

" if dark, disable background to make it transparent again 
if &background == 'dark'
  hi Normal       ctermbg=none
  hi EndOfBuffer  ctermbg=none
  hi SignColumn   ctermbg=none
  hi LineNr       ctermbg=none
endif 

"
" fzf settings 
" 

let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
