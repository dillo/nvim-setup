local parsers = {
  "bash",
  "css",
  "dockerfile",
  "gitignore",
  "graphql",
  "html",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "prisma",
  "python",
  "query",
  "ruby",
  "svelte",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    { "windwp/nvim-ts-autotag", opts = {} },
  },
  config = function()
    local treesitter = require("nvim-treesitter")

    treesitter.setup()
    treesitter.install(parsers)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
        if lang and vim.list_contains(parsers, lang) and pcall(vim.treesitter.start, args.buf, lang) then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })

    -- Preserve the old incremental-selection keys using Neovim 0.12's
    -- built-in Tree-sitter selection API.
    vim.keymap.set("n", "<C-space>", function()
      vim.cmd.normal({ "v", bang = true })
      vim.treesitter.select("parent")
    end, { desc = "Start syntax node selection" })
    vim.keymap.set("x", "<C-space>", function()
      vim.treesitter.select("parent")
    end, { desc = "Select parent syntax node" })
    vim.keymap.set("x", "<BS>", function()
      vim.treesitter.select("child")
    end, { desc = "Select child syntax node" })
  end,
}
