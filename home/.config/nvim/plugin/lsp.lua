local capabilities = require('cmp_nvim_lsp').default_capabilities()

local lsps = {
	'ccls',
	'gopls',
	'pyright',
}

local function binary_exists(name)
	return vim.fn.executable(name) == 1
end

for _, lsp_name in ipairs(lsps) do
	if binary_exists(lsp_name) then
		vim.lsp.config(lsp_name, {
			capabilities = capabilities,
		})
		vim.lsp.enable(lsp_name)
	end
end
