local capabilities = require('cmp_nvim_lsp').default_capabilities()

local lsps = {
	'gopls',
	'pyright',
	'svelte',
	'ts_ls',
	'docker_language_server',
	'cssls',
}

for _, lsp_name in ipairs(lsps) do
	vim.lsp.config(lsp_name, {
		capabilities = capabilities,
	})
	vim.lsp.enable(lsp_name)
end
