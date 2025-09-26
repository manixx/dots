local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config('ccls', {
	capabilities = capabilities,
})
vim.lsp.enable('ccls')

vim.lsp.config('gopls', {
	capabilities = capabilities,
})
vim.lsp.enable('gopls')

vim.lsp.config('pyright', {
	capabilities = capabilities,
})
vim.lsp.enable('pyright')
