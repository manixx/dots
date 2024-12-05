local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local localServer = {
	'ccls',
}

local dockerServer = {
	'gopls',
}

for _, lsp in ipairs(localServer) do
	lspconfig[lsp].setup{ capabilities = capabilities }
end

for _, lsp in ipairs(dockerServer) do
	cmd = {
		'docker', 'run', '-i',
		'-v', vim.fn.getcwd() .. ':' .. vim.fn.getcwd(),
		'-w', vim.fn.getcwd(),
		'lsp-containers/' .. lsp,
	}

	lspconfig[lsp].setup{ cmd = cmd, capabilities = capabilities }
end
