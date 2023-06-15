require'nvim-treesitter.configs'.setup {
	ensure_installed = {
		"terraform",
		"go"
	},
	auto_install = false,
	highlight    = { enable = true }
}
