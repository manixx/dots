local lsp = require("lspconfig")

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics, { update_in_insert = true }
)

-- #############################################################################
-- keybindings
-- #############################################################################

local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end


-- lsp 
local on_attach = function(client, bufnr) 
	local opts = { noremap=true, silent=true }

	buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)

	buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
	buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)

	buf_set_keymap('n', '<space>d', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
	buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
	buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
	
	-- compe 
	local compeOpts = { expr = true, silent = true }

	buf_set_keymap("i", "<C-Space>", "compe#complete()", compeOpts)
	buf_set_keymap("i", "<C-e>", [[compe#close("<C-e>")]], compeOpts)
	buf_set_keymap("i", "<CR>", [[compe#confirm("<CR>")]], compeOpts)

	buf_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
	buf_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})

	-- auto highlight 
	if client.resolved_capabilities.document_highlight then
		vim.api.nvim_exec([[
			hi LspReferenceRead  guibg=#394634
			hi LspReferenceText  guibg=#414550 gui=bold
			hi LspReferenceWrite guibg=#55393d

			augroup lsp_document_highlight
				autocmd! * <buffer>
				autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
				autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
			augroup END
			]], false)
	end
end

-- #############################################################################
-- compe 
-- #############################################################################

require'compe'.setup {
	enabled = true;
	autocomplete = true;
	debug = false;
	min_length = 1;
	preselect = 'always';
	throttle_time = 80;
	source_timeout = 200;
	incomplete_delay = 400;
	max_abbr_width = 100;
	max_kind_width = 100;
	max_menu_width = 100;
	documentation = true;

	source = {
		path = true;
		buffer = true;
		calc = false;
		nvim_lsp = true;
		nvim_lua = true;
		vsnip = true;
		ultisnips = false;
	};
}

-- #############################################################################
-- vnsip 
-- #############################################################################

local t = function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

_G.tab_complete = function()
	if vim.fn.pumvisible() == 1 then
		return vim.fn["compe#confirm"]()
	elseif vim.fn.call("vsnip#available", {1}) == 1 then
		return t("<Plug>(vsnip-expand-or-jump)")
	else
		return t("<Tab>")
	end
end

-- #############################################################################
-- lspfuzzy 
-- #############################################################################

require('lspfuzzy').setup {}

-- #############################################################################
-- tsserver 
-- #############################################################################

lsp.tsserver.setup{ on_attach = on_attach }

-- #############################################################################
-- gopls 
-- #############################################################################

lsp.gopls.setup{ on_attach = on_attach }

-- #############################################################################
-- ccls  
-- #############################################################################

lsp.ccls.setup{ on_attach = on_attach }

-- #############################################################################
-- ccls  
-- #############################################################################

lsp.yamlls.setup{ on_attach = on_attach }
