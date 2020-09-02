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
" code completion & dev tools
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'editorconfig/editorconfig-vim'
Plug 'majutsushi/tagbar'
Plug 'fatih/vim-go'
" themes 
Plug 'sainnhe/edge'
call plug#end()

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
set background=dark
set termguicolors
set t_ut=

syntax      on
filetype    plugin on
colorscheme edge

hi CursorLineNr          ctermbg=none cterm=bold
hi HighlightedyankRegion cterm=bold
hi Search                ctermbg=8

let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:vim_json_syntax_conceal = 0
let g:NERDTreeChDirMode=1
let g:NERDTreeShowHidden=1
let g:NERDTreeWinPos = "right"
let g:lightline = {
  \ 'colorscheme': 'edge',
  \ 'separator': { 'left': '▙', 'right': '▟' },
  \ 'subseparator': { 'left': '▸', 'right': '◂' }, 
  \ 'active': {
  \  'left': [ 
  \   [ 'mode', 'paste' ],
  \   [ 'ctrlpmark', 'cocstatus', 'readonly', 'modified', 'method' ], 
  \   [ 'relativepath', 'gitbranch' ]
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

function! ChangeCWD() 
	call fzf#run({ 
		\ 'source': 'fd --type d --hidden . ~', 
		\ 'options': '--color fg:#5F6471', 
		\ 'down': '~20%', 
		\ 'sink': 'chdir' })
endfunction

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

function! PrintWorkingDir() 
	let home = getenv('HOME')
	let cwd = getcwd()
	return substitute(cwd, home, '~', '')
endfunction

noremap <leader>y       "+y
noremap <leader>p       "+p
noremap <leader><esc>   :noh<cr>
noremap <leader><tab>   :NERDTreeToggle<cr>
noremap <leader><s-tab> :NERDTreeFocus<cr>
noremap <leader>^       :NERDTreeFind<cr>
noremap <leader><s-S>   :NERDTreeMirror<cr>
noremap <leader>w       :call ChangeCWD()<cr>
noremap <leader>z       :setlocal foldmethod=syntax<cr>
noremap <leader>o       :TagbarOpenAutoClose<cr>
noremap <leader>eo      :lopen<cr>
noremap <leader>ec      :lclose<cr>
noremap <leader>ee      :lnext<cr>
" fzf 
noremap <leader>f       :Files<cr>
noremap <leader>F       :Files ~<cr>
noremap <leader>s       :Rg<cr>
noremap <leader>bl      :BLines<cr>
noremap <leader>l       :Lines<cr>
noremap <leader>gc      :Commits<cr>
noremap <leader>gbc     :BCommits<cr>
noremap <leader>sy      :Filetypes<cr>
" fugitive 
noremap <leader>gb      :Gblame<cr>
" nnn 
noremap <leader>b       :NnnPicker<cr>
" easy align  
xmap ga                 <Plug>(EasyAlign)
nmap ga                 <Plug>(EasyAlign)
" coc
nmap <silent>gd         <Plug>(coc-definition)
nmap <silent>gy         <Plug>(coc-type-definition)
nmap <silent>gi         <Plug>(coc-implementation)
nmap <silent>gr         <Plug>(coc-references)
nmap <leader>rn         <Plug>(coc-rename)
nnoremap <silent>K      :call <SID>show_documentation()<CR>
inoremap <silent><expr> <TAB>
			\ pumvisible() ? "\<C-n>" :
			\ <SID>check_back_space() ? "\<TAB>" :
			\ coc#refresh()
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <expr>         <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <silent><expr> <c-space> coc#refresh()
nnoremap <silent>       <space>y :<C-u>CocList -A --normal yank<cr>
nnoremap <silent>       <space>a :<C-u>CocAction<cr>
"nnoremap <silent>       <space>d :<C-u>CocList diagnostics<cr>
"nnoremap <silent>       <space>e :<C-u>CocList extensions<cr>
"nnoremap <silent>       <space>c :<C-u>CocList commands<cr>
"nnoremap <silent>       <space>o :<C-u>CocList outline<cr>
"nnoremap <silent>       <space>s :<C-u>CocList -I symbols<cr>
"nnoremap <silent>       <space>j :<C-u>CocNext<CR>
"nnoremap <silent>       <space>k :<C-u>CocPrev<CR>
"nnoremap <silent>       <space>p :<C-u>CocListResume<CR>
"nmap <silent>           <TAB> <Plug>(coc-range-select)
"xmap <silent>           <TAB> <Plug>(coc-range-select)
"nmap <leader>           qf <Plug>(coc-fix-current)
"nmap <silent>           [g <Plug>(coc-diagnostic-prev)
"nmap <silent>           ]g <Plug>(coc-diagnostic-next)
"xmap <leader>p          <Plug>(coc-format-selected)
"nmap <leader>p          <Plug>(coc-format-selected)
"xmap <leader>a          <Plug>(coc-codeaction-selected)
"nmap <leader>a          <Plug>(coc-codeaction-selected)
"nmap <leader>ac         <Plug>(coc-codeaction)
"xmap if                 <Plug>(coc-funcobj-i)
"xmap af                 <Plug>(coc-funcobj-a)
"omap if                 <Plug>(coc-funcobj-i)
"omap af                 <Plug>(coc-funcobj-a)

"nmap <expr> <silent> <C-d> <SID>select_current_word()

" Use `:Format` to format current buffer
"command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
"command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
"command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

autocmd FileType    json syntax match Comment +\/\/.\+$+
autocmd CursorHold  *    silent call CocActionAsync('highlight')
autocmd BufWritePre *.md :%s/\s\+$//e

augroup filetype_nerdtree
    au!
    au FileType nerdtree call s:disable_lightline_on_nerdtree()
    au WinEnter,BufWinEnter,TabEnter * call s:disable_lightline_on_nerdtree()
augroup END

fu s:disable_lightline_on_nerdtree() abort
	let nerdtree_winnr = index(map(range(1, winnr('$')), {_,v -> getbufvar(winbufnr(v), '&ft')}), 'nerdtree') + 1
	call timer_start(0, {-> nerdtree_winnr && setwinvar(nerdtree_winnr, '&stl', '%#Normal#')})
endfu

