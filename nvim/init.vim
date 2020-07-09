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
Plug '/usr/local/opt/fzf'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'Yggdroot/indentLine' 
Plug 'easymotion/vim-easymotion'
Plug 'elzr/vim-json'
Plug 'itchyny/lightline.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'mcchrish/nnn.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'

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
Plug 'ctrlpvim/ctrlp.vim' 
Plug 'majutsushi/tagbar'

" themes 
Plug 'sainnhe/edge'

call plug#end()

" PLUGIN SETTINGS 

" indentLine 
let g:indentLine_char_list = ['|', '¦', '┆', '┊']

" vim-json 
let g:vim_json_syntax_conceal = 0

" NERDTree settings 
let g:NERDTreeChDirMode=1
let g:NERDTreeShowHidden=1
let g:NERDTreeWinPos = "right"

" vim-go 

let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

" tagbar 

let g:tagbar_width = 60
let g:tagbar_type_typescript = {                                                  
  \ 'ctagsbin' : 'tstags',                                                        
  \ 'ctagsargs' : '-f-',                                                           
  \ 'kinds': [                                                                     
    \ 'e:enums:0:1',                                                               
    \ 'f:function:0:1',                                                            
    \ 't:typealias:0:1',                                                           
    \ 'M:Module:0:1',                                                              
    \ 'I:import:0:1',                                                              
    \ 'i:interface:0:1',                                                           
    \ 'C:class:0:1',                                                               
    \ 'm:method:0:1',                                                              
    \ 'p:property:0:1',                                                            
    \ 'v:variable:0:1',                                                            
    \ 'c:const:0:1',                                                              
  \ ],                                                                            
  \ 'sort' : 0                                                                    
\ }    

" KEY BINDINGS 

" disable arrow keys
noremap  <Up> ""
noremap! <Up> <Esc>
noremap  <Down> ""
noremap! <Down> <Esc>
noremap  <Left> ""
noremap! <Left> <Esc>
noremap  <Right> ""
noremap! <Right> <Esc>

 "taboo 
"noremap <leader>tr :TabooRename<space>
"noremap <leader>to :TabooOpen<space> 

" fugitive 
noremap <leader>gb :Gblame<cr>

" NERDTree

function! ChangeCWD() 
	call fzf#run({ 
		\ 'source': 'fd --type d --hidden . ~', 
		\ 'down': '~20%', 
		\ 'sink': 'chdir' })
endfunction

noremap <leader><tab>   :NERDTreeToggle<cr>
noremap <leader><s-tab> :NERDTreeFocus<cr>
noremap <leader>w       :call ChangeCWD()<cr>
noremap <leader>^       :NERDTreeFind<cr>
noremap <leader><s-S>   :NERDTreeMirror<cr>

" tagbar 
nnoremap <silent> <Leader>c :TagbarOpenAutoClose<CR>

" fzf 
noremap <leader>f  :Files<cr>
noremap <leader>F  :Files ~<cr>
noremap <leader>l  :Lines<cr>
noremap <leader>s  :Rg<cr>
noremap <leader>gc :Commits<cr>

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
nnoremap <silent> <space>a :<C-u>CocAction<cr>
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
autocmd BufWritePre *.md :%s/\s\+$//e

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

function! SwitchTheme() 
	if &background == 'dark' 
		set background=light 
	else 
		set background=dark
	endif 
endfunction

nnoremap <leader>tt :call SwitchTheme()<cr>

set background=dark
colorscheme edge

" highlight comments in jsonc correctly 
autocmd FileType json syntax match Comment +\/\/.\+$+

hi CursorLineNr ctermbg=none cterm=bold 
hi HighlightedyankRegion cterm=bold
hi Search ctermbg=8

hi Normal       ctermbg=none
hi EndOfBuffer  ctermbg=none
hi SignColumn   ctermbg=none
hi LineNr       ctermbg=none

"
" lightline settings
"

function! PrintWorkingDir() 
	let home = getenv('HOME')
	let cwd = getcwd()
	return substitute(cwd, home, '~', '')
endfunction

" disable status line on nerdtree
augroup filetype_nerdtree
    au!
    au FileType nerdtree call s:disable_lightline_on_nerdtree()
    au WinEnter,BufWinEnter,TabEnter * call s:disable_lightline_on_nerdtree()
augroup END

fu s:disable_lightline_on_nerdtree() abort
	let nerdtree_winnr = index(map(range(1, winnr('$')), {_,v -> getbufvar(winbufnr(v), '&ft')}), 'nerdtree') + 1
	call timer_start(0, {-> nerdtree_winnr && setwinvar(nerdtree_winnr, '&stl', '%#Normal#')})
endfu

let g:lightline = {
  \ 'colorscheme': 'edge',
  \ 'separator': { 'left': '▙', 'right': '▟' },
  \ 'subseparator': { 'left': '▸', 'right': '◂' }, 
  \ 'active': {
  \  'left': [ 
  \   [ 'mode', 'paste' ],
  \   [ 'ctrlpmark', 'cocstatus', 'readonly', 'modified', 'method' ], 
  \   [ 'relativepath', 'cwd', 'gitbranch' ]
  \  ], 
  \  'right': [ 
  \    [ 'lineinfo', 'percent' ],
  \    [ 'fileformat', 'fileencoding', 'filetype' ] 
  \  ]
  \  }, 
  \  'inactive': {
  \   'left': [ 
  \    [ 'filename' ], 
  \   ],
  \   'right': [ 
  \    [ 'percent' ]
  \   ]
  \  }, 
  \  'tabline': {
  \   'left': [ [ 'tabs' ] ],
  \   'right': [] 
  \  }, 
  \  'component_function': {
  \   'cocstatus': 'coc#status', 
  \   'gitbranch': 'fugitive#head', 
  \   'cwd': 'PrintWorkingDir'
  \  }
  \}

