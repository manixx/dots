call plug#begin('~/.vim/plugged')

" common tools
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
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'towolf/vim-helm'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npm install'  }

" lsp
Plug 'neovim/nvim-lspconfig'
Plug 'ojroques/nvim-lspfuzzy'

" completion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp' " Lsp integration
Plug 'hrsh7th/cmp-vsnip'    " Snippet cmp integration
Plug 'hrsh7th/vim-vsnip'    " Snippets engine
Plug 'hrsh7th/cmp-buffer'   " Buffer words
Plug 'hrsh7th/cmp-cmdline'  " Command line completion

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
set completeopt=menu,menuone,noselect " cpm-nvim menu control

syntax      enable           " enable syntax highlights
filetype    plugin indent on " enable plugins
colorscheme edge

hi CursorLineNr gui=bold
hi Search       gui=bold
hi SignColumn   guibg=none
hi EndOfBuffer  guibg=none
hi Normal       guibg=none
hi Visual       guibg=Gray

" Set soft-tabs on YAML files
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

" indentLine
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_defaultGroup = 'SpecialKey'

" gitgutter
let g:gitgutter_map_keys = 0

" vim-javascript
let g:javascript_plugin_jsdoc = 1

" autopairs
lua <<EOF
require('nvim-autopairs').setup{}
EOF

" treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
	ensure_installed = {
		"bash",
		"c",
		"cmake",
		"comment",
		"commonlisp",
		"cpp",
		"css",
		"dockerfile",
		"dot",
		"erlang",
		"fish",
		"go",
		"gomod",
		"graphql",
		"haskell",
		"hcl",
		"help",
		"hjson",
		"html",
		"http",
		"java",
		"javascript",
		"jsdoc",
		"json",
		"json5",
		"jsonc",
		"lua",
		"make",
		"markdown",
		"ninja",
		"ocaml",
		"ocaml_interface",
		"org",
		"perl",
		"php",
		"pioasm",
		"python",
		"ql",
		"query",
		"regex",
		"ruby",
		"rust",
		"scheme",
		"scss",
		"slint",
		"toml",
		"tsx",
		"typescript",
		"vim",
		"vue",
		"yaml",
	},
  sync_install = true,
  highlight = {
    enable = true,
		disable = { "vim" }, -- looks better
    additional_vim_regex_highlighting = false,
  },
}
EOF

" lspfuzzy
lua <<EOF
	require('lspfuzzy').setup {}
EOF

" lsp & completion
lua <<EOF
	local cmp = require'cmp'
	local lsp = require'lspconfig'

	cmp.setup({
		snippet = {
			expand = function(args)
				vim.fn["vsnip#anonymous"](args.body)
				end,
		},
		mapping = {
			['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
			['<CR>'] = cmp.mapping.confirm({ select = true }),
		},
		sources = cmp.config.sources({
			{ name = 'nvim_lsp' },
			{ name = 'vsnip' },
		}, {
			{ name = 'buffer' },
			{ name = 'path' },
			{ name = 'spell' },
		})
	})

	cmp.setup.cmdline('/', {
		sources = {
			{ name = 'buffer' }
		}
	})

	local on_attach = function(_, bufnr)
		local opts = { noremap = true, silent = true }
		vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD',         '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd',         '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K',          '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi',         '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>',      '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D',  '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr',         '<cmd>lua vim.lsp.buf.references()<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e',  '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d',         '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d',         '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>q',  '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
		vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
	end

	local capabilities = require'cmp_nvim_lsp'.update_capabilities(
		vim.lsp.protocol.make_client_capabilities()
	)
	local servers = {
		'bashls',
		'vimls',
		'gopls',
		'yamlls',
	}
	for _, server in ipairs(servers) do
		lsp[server].setup { capabilities = capabilities, on_attach = on_attach }
	end
EOF

" common
noremap <leader>w  :call ChangeCWD()<cr>
noremap <leader>rf maggVG='a
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

" lsp
noremap <leader>lss :LspInfo<cr>

" lspfuzzy
noremap <leader>lsd :LspDiagnostics 0<cr>

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
