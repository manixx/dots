local lsp = require("lspconfig")

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
				vim.lsp.diagnostic.on_publish_diagnostics, { update_in_insert = true }
)

-- #############################################################################
-- keybindings
-- #############################################################################

local on_attach = function(client, bufnr) 
				local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
				local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

				local opts = { noremap=true, silent=true }

				--buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
				buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
				buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
				buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
				buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
				buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
				buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
				buf_set_keymap('n', '<space>d', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
				buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
				buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)

				local compeOpts = { expr = true, silent = true }

				buf_set_keymap("i", "<C-Space>", "compe#complete()", compeOpts)
				buf_set_keymap("i", "<C-e>", [[compe#close("<C-e>")]], compeOpts)
				vim.api.nvim_set_keymap("i", "<CR>", [[compe#confirm("<CR>")]], compeOpts)

				buf_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
				buf_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
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
-- tsserver 
-- #############################################################################

lsp.tsserver.setup{ on_attach = on_attach }

-- #############################################################################
-- bashls 
-- #############################################################################

lsp.bashls.setup{}

-- #############################################################################
-- gopls 
-- #############################################################################

-- lsp.gopls.setup{}

-- #############################################################################
-- Dockerfiles
-- #############################################################################

-- lsp.dockerls.setup{}

-- #############################################################################
-- lua 
-- #############################################################################

-- #############################################################################
-- c/c++/objective-c
-- #############################################################################

-- #############################################################################
-- GraphQL
-- #############################################################################

lsp.graphql.setup{ on_attach = on_attach }

-- #############################################################################
-- HTML
-- #############################################################################

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lsp.html.setup {
				on_attach = on_attach,
				capabilities = capabilities,
}

-- #############################################################################
-- CSS
-- #############################################################################

lsp.angularls.setup{ on_attach = on_attach }

-- #############################################################################
-- CSS
-- #############################################################################

-- #############################################################################
-- Haskell
-- #############################################################################

-- #############################################################################
-- JSON
-- #############################################################################

-- #############################################################################
-- PHP
-- #############################################################################

-- #############################################################################
-- Python
-- #############################################################################

-- #############################################################################
-- Rust
-- #############################################################################

-- #############################################################################
-- Terraform
-- #############################################################################

lsp.terraformls.setup{ on_attach = on_attach }

-- #############################################################################
-- XML
-- #############################################################################

-- #############################################################################
-- YAML
-- #############################################################################
