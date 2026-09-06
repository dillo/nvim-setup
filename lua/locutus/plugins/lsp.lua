return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
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
			local mason = require("mason")
			local mason_lspconfig = require("mason-lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Include completion capabilities for servers automatically enabled by Mason.
			vim.lsp.config("*", { capabilities = capabilities })

			mason.setup()
			mason_lspconfig.setup({
				ensure_installed = { "lua_ls", "ruby_lsp", "rubocop" },
				-- Keep server activation explicit, independent of installed Mason tools.
				automatic_enable = {
					"bashls",
					"cssls",
					"dockerls",
					"elixirls",
					"emmet_ls",
					"eslint",
					"graphql",
					"html",
					"jsonls",
					"prismals",
					"pyright", -- Use one Python language server.
					"svelte",
					"tailwindcss",
					"ts_ls",
				},
			})

			vim.lsp.config("lua_ls", { capabilities = capabilities })

			-- Enhanced Ruby LSP configuration
			vim.lsp.config("ruby_lsp", {
				capabilities = capabilities,
				settings = {
					ruby = {
						useBundler = true, -- Use bundler for gem management
						formatter = "auto", -- Use project's formatter
					},
				},
			})

			vim.lsp.config("rubocop", {
				capabilities = capabilities,
				-- Mason's RuboCop launcher is tied to an old Ruby installation.
				-- Let asdf select the correct Ruby and gem set for each project.
				cmd = { vim.fn.expand("~/.asdf/shims/rubocop"), "--lsp" },
				root_markers = { ".rubocop.yml", "Gemfile", ".git" },
				settings = {
					rubocop = {
						useBundler = true,
						autoCorrect = false, -- Let conform handle the formatting
						formatOnSave = false, -- Let conform handle the formatting
					},
				},
			})

			vim.lsp.enable({ "lua_ls", "ruby_lsp", "rubocop" })
		end,
	},
}
