" general settings

set hidden " by coc required
set rnu nu
set cursorline
set mouse=a
set noshowmode
set cmdheight=1
set updatetime=300
set shortmess+=c
set signcolumn=yes
set tabstop=2
set shiftwidth=2 
set noexpandtab 
set showtabline=2
set colorcolumn=80

syntax on
filetype plugin on

" PLUGINS

call plug#begin('~/.vim/plugged')

" tools 
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/vim-easy-align'
Plug 'mcchrish/nnn.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-fugitive'
Plug 'easymotion/vim-easymotion'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'Yggdroot/indentLine' 
Plug 'elzr/vim-json'
Plug 'gcmt/taboo.vim'

" themes 
Plug 'sainnhe/edge'

" syntax highlight
Plug 'pangloss/vim-javascript' 
Plug 'leafgarland/typescript-vim' 
Plug 'jparise/vim-graphql'
Plug 'chr4/nginx.vim'
Plug 'delphinus/vim-firestore'
Plug 'fatih/vim-go'

" code completion & dev tools
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'editorconfig/editorconfig-vim'
Plug 'andrewstuart/vim-kubernetes' 

call plug#end()

" PLUGIN SETTINGS 

" indentLine 
let g:indentLine_char_list = ['|', '¦', '┆', '┊']

" vim-json 
let g:vim_json_syntax_conceal = 0

" taboo 
let g:taboo_tab_format = ' %N %f%m '
let g:taboo_renamed_tab_format = ' %N [%l]%m '

" NERDTree settings 
let g:NERDTreeChDirMode=1
let g:NERDTreeShowHidden=1
let g:NERDTreeWinPos = "right"

" vim-go 

let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

" KEY BINDINGS 

" taboo 
noremap <leader>tr :TabooRename<space>
noremap <leader>to :TabooOpen<space> 

" fugitive 
noremap <leader>gb :Gblame<cr>

" NERDTree
noremap <leader><tab>   :NERDTreeToggle<cr>
noremap <leader><s-tab> :NERDTreeFocus<cr>
noremap <leader>w       :NERDTree<space>
noremap <leader>^       :NERDTreeFind<cr>
noremap <leader><s-S>   :NERDTreeMirror<cr>

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

" coc 
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

function! s:select_current_word()
  if !get(g:, 'coc_cursors_activated', 0)
    return "\<Plug>(coc-cursors-word)"
  endif
  return "*\<Plug>(coc-cursors-word):nohlsearch\<CR>"
endfunc

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nnoremap <silent> <space>d :<C-u>CocList diagnostics<cr>
nnoremap <silent> <space>e :<C-u>CocList extensions<cr>
nnoremap <silent> <space>c :<C-u>CocList commands<cr>
nnoremap <silent> <space>o :<C-u>CocList outline<cr>
nnoremap <silent> <space>s :<C-u>CocList -I symbols<cr>
nnoremap <silent> <space>j :<C-u>CocNext<CR>
nnoremap <silent> <space>k :<C-u>CocPrev<CR>
nnoremap <silent> <space>p :<C-u>CocListResume<CR>

nnoremap <silent> K :call <SID>show_documentation()<CR>

nmap <leader>rn <Plug>(coc-rename)
 
xmap <leader>p <Plug>(coc-format-selected)
nmap <leader>p <Plug>(coc-format-selected)

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a <Plug>(coc-codeaction-selected)
nmap <leader>a <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <c-space> coc#refresh()

autocmd CursorHold * silent call CocActionAsync('highlight')

nmap <expr> <silent> <C-d> <SID>select_current_word()

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

"
" theme settings 
"

set background=dark
colorscheme edge

" highlight comments in jsonc correctly 
autocmd FileType json syntax match Comment +\/\/.\+$+

hi CursorLineNr ctermbg=none cterm=bold 
hi LineNr ctermfg=8
hi HighlightedyankRegion cterm=bold
hi Search ctermbg=8

" if dark, disable background to make it transparent again 
if &background == 'dark'
  hi Normal       ctermbg=none
  hi EndOfBuffer  ctermbg=none
  hi SignColumn   ctermbg=none
  hi LineNr       ctermbg=none
endif 

"
" lightline settings
"

let g:lightline = {
  \   'colorscheme': 'edge',
  \   'separator': { 'left': '▙', 'right': '▟' },
  \   'subseparator': { 'left': '▸', 'right': '◂' }, 
  \   'active': {
  \     'left': [ 
  \       [ 'mode', 'paste' ],
  \       [ 'ctrlpmark', 'cocstatus', 'readonly', 'filename', 'modified', 'method' ], 
  \       [ 'gitbranch', 'relativepath' ]
  \     ], 
  \     'right': [ 
  \       [ 'lineinfo' ],
  \       [ 'percent' ],
  \       [ 'fileformat', 'fileencoding', 'filetype' ] 
  \     ]
  \   }, 
  \   'inactive': {
  \     'left': [ 
  \       [ 'filename' ], 
  \       [ 'gitbranch', 'relativepath' ]
  \     ],
  \     'right': [ 
  \       [ 'lineinfo' ],
  \       [ 'percent' ]
  \     ]
  \   }, 
  \   'tabline': {
  \     'left': [ [ 'tabs' ] ],
  \     'right': [] 
  \   }, 
  \   'component_function': {
  \     'cocstatus': 'coc#status', 
  \     'gitbranch': 'fugitive#head'
  \   }
  \ }

