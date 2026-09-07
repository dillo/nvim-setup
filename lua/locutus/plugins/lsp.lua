return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			local mason = require("mason")
			local mason_lspconfig = require("mason-lspconfig")
			local mason_tool_installer = require("mason-tool-installer")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local rubocop_launcher = vim.fn.stdpath("config") .. "/bin/rubocop-project"
			local rubocop_fallback = vim.fn.expand("~/.asdf/shims/rubocop")
			local bundler = vim.fn.expand("~/.asdf/shims/bundle")

			-- Include completion capabilities for servers automatically enabled by Mason.
			vim.lsp.config("*", { capabilities = capabilities })

			mason.setup()
			mason_lspconfig.setup({
				ensure_installed = {
					"bashls",
					"cssls",
					"dockerls",
					"emmet_ls",
					"eslint",
					"graphql",
					"herb_ls",
					"html",
					"jsonls",
					"lua_ls",
					"prismals",
					"pyright",
					"ruff",
					"ruby_lsp",
					"rubocop",
					"svelte",
					"tailwindcss",
					"ts_ls",
				},
				-- Keep server activation explicit, independent of installed Mason tools.
				automatic_enable = {
					"bashls",
					"cssls",
					"dockerls",
					"emmet_ls",
					"eslint",
					"graphql",
					"herb_ls", -- HTML+ERB diagnostics for Rails views.
					"html",
					"jsonls",
					"prismals",
					"pyright", -- Types and completion only; see the ruff config below.
					"ruff", -- Linting, import sorting, and formatting for Python.
					"svelte",
					"tailwindcss",
					"ts_ls",
				},
			})
			mason_tool_installer.setup({
				ensure_installed = {
					"prettier",
					"stylua",
				},
				run_on_start = true,
				start_delay = 3000,
				debounce_hours = 24,
			})

			vim.lsp.config("lua_ls", { capabilities = capabilities })

			-- Ruff owns linting, import sorting, and formatting; Pyright owns types
			-- and hover. Disabling Ruff's hover prevents duplicate popups.
			vim.lsp.config("ruff", {
				capabilities = capabilities,
				on_attach = function(client)
					client.server_capabilities.hoverProvider = false
				end,
			})

			-- Defer to Ruff for import organisation so the two servers do not
			-- both offer the same code action.
			vim.lsp.config("pyright", {
				capabilities = capabilities,
				settings = {
					pyright = { disableOrganizeImports = true },
					python = { analysis = { typeCheckingMode = "standard" } },
				},
			})

			-- Herb ships filetypes { "html", "eruby" }. Restrict it to eruby so it
			-- does not overlap with the dedicated HTML language server.
			vim.lsp.config("herb_ls", {
				capabilities = capabilities,
				filetypes = { "eruby" },
			})

			-- Enhanced Ruby LSP configuration
			vim.lsp.config("ruby_lsp", {
				capabilities = capabilities,
				-- Nested Rails engines may have a Gemfile but share the root lockfile.
				root_markers = { "Gemfile.lock", ".git" },
				init_options = {
					-- Conform and the dedicated RuboCop LSP own these responsibilities.
					formatter = "none",
					linters = {},
				},
			})

			vim.lsp.config("rubocop", {
				capabilities = capabilities,
				cmd = function(dispatchers, config)
					return vim.lsp.rpc.start(
						{ rubocop_launcher, rubocop_fallback, bundler, "--lsp" },
						dispatchers,
						config and config.root_dir and { cwd = config.root_dir }
					)
				end,
				root_markers = { ".rubocop.yml", "Gemfile", ".git" },
			})

			vim.lsp.enable({ "lua_ls", "ruby_lsp", "rubocop" })
		end,
	},
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found.
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
}
