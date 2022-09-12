call plug#begin('~/.vim/plugged')

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
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npm install'  }
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/vim-vsnip'      " snippet engine
Plug 'hrsh7th/nvim-cmp'       " completion engine
Plug 'hrsh7th/cmp-nvim-lsp'   " source for lsp
Plug 'hrsh7th/cmp-buffer'     " for buffer words
Plug 'hrsh7th/cmp-path'       " paths and folders
Plug 'hrsh7th/cmp-cmdline'    " cmd line completion
Plug 'hrsh7th/cmp-vsnip'      " vsnip integration
Plug 'ojroques/nvim-lspfuzzy' " fuzzy search lsp

call plug#end()

set colorcolumn=80                    " draw line at col 80
set rnu nu                            " line numbers, relative
set list                              " show hidden characters
set cursorline                        " highlight line where cursor is
set signcolumn=yes                    " show always
set background=dark
set termguicolors                     " enable true colors
set showtabline=2                     " always show tabbar
set noshowmode                        " lightline takes care
set shiftwidth=2
set tabstop=2                         " width of one tab
set spelllang=en,de                   " not enabled by default, check bindings
set completeopt=menu,menuone,noselect " required by nvim-cmp

syntax      enable           " enable syntax highlights
filetype    plugin indent on " enable plugins
colorscheme edge

hi CursorLineNr gui=bold
hi Search       gui=bold
hi SignColumn   guibg=none
hi Normal       guibg=none
hi EndOfBuffer  guibg=none
hi Visual       guibg=Gray

" Set soft-tabs on YAML files and disable annoying auto indent
autocmd FileType yaml,helm setlocal ts=2 sts=2 sw=2 expandtab indentkeys-=<:>
" Strip trailing spaces, but keep cursor position
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
let g:NERDTreeRemoveFileCmd = 'trash ' " use trash-cli
let g:NERDTreeRemoveDirCmd = 'trash '  " use trash-cli

" indentLine
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_defaultGroup = 'SpecialKey'

" gitgutter
let g:gitgutter_map_keys = 0

" json.vim
let g:vim_json_conceal = 0 " do not hide quotes on JSON files

lua <<EOF
require'nvim-autopairs'.setup{}
require'lspfuzzy'.setup {}

local cmp = require'cmp'

cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-e>']     = cmp.mapping.abort(),
		['<CR>']      = cmp.mapping.confirm({ select = false }),
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'vsnip' },
	}, {
		{ name = 'buffer' },
	})
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
	{ name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
	}, {
	{ name = 'buffer' },
	})
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	})
})

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local lsp = require'lspconfig'

local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap=true, silent=true, buffer=bufnr }
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
	vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set('n', '<space>wl', function()
	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
	vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
	vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
	vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end

lsp['tsserver'].setup { on_attach = on_attach, capabilities = capabilities }
lsp['bashls'].setup   { on_attach = on_attach, capabilities = capabilities, filetypes = { "sh", "zsh" }}
lsp['gopls'].setup    { on_attach = on_attach, capabilities = capabilities }
lsp['yamlls'].setup   { on_attach = on_attach, capabilities = capabilities }
lsp['dockerls'].setup { on_attach = on_attach, capabilities = capabilities }
EOF

" common
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
noremap <leader>gg :Git<cr>

" gitgutter
nmap    ]c         <Plug>(GitGutterNextHunk)
nmap    [c         <Plug>(GitGutterPrevHunk)
noremap <leader>gf :GitGutterFold<cr>

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
