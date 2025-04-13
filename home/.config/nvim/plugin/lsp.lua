local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local localServer = {
	'ccls',
	'gopls',
	'bashls',
}

for _, lsp in ipairs(localServer) do
	lspconfig[lsp].setup{ capabilities = capabilities }
end
