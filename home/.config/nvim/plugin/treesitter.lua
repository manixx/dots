require'nvim-treesitter.configs'.setup {
	ensure_installed = {
		"terraform",
		"go",
		"c",
	},
	auto_install = false,
	highlight    = { enable = true }
}
