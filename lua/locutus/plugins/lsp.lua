return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"williamboman/mason.nvim",
				"williamboman/mason-lspconfig.nvim", -- Add mason-lspconfig
				"folke/lazydev.nvim",
				ft = "lua", -- only load on lua files
				opts = {
					library = {
						-- See the configuration section for more details
						-- Load luvit types when the `vim.uv` word is found
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
					},
				},
			},
		},
		config = function()
			local lspconfig = require("lspconfig")
			local mason = require("mason")
			local mason_lspconfig = require("mason-lspconfig")

			mason.setup()
			mason_lspconfig.setup({
				ensure_installed = { "lua_ls", "ruby_lsp", "rubocop" },
			})

			lspconfig.lua_ls.setup({})

			-- Enhanced Ruby LSP configuration
			lspconfig.ruby_lsp.setup({
				settings = {
					ruby = {
						useBundler = true, -- Use bundler for gem management
						formatter = "auto", -- Use project's formatter
					},
				},
			})

      lspconfig.rubocop.setup({
        settings = {
          rubocop = {
            useBundler = true,
            autoCorrect = false, -- Let conform handle the formatting
            formatOnSave = false, -- Let conform handle the formatting
          }
        }
      })
		end,
	},
}
