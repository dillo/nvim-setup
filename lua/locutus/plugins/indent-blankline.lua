return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  ---@module "ibl"
  ---@type ibl.config
  opts = {
    indent = {
      char = "┊",
      highlight = { "QuietIndentGuide" },
    },
    scope = {
      enabled = true,
      highlight = "QuietIndentScope",
      show_start = false,
      show_end = false,
    },
    exclude = {
      filetypes = { "help", "alpha", "lazy" },
    },
  },

  config = function(_, opts)
    local ibl = require("ibl")
    ibl.setup(opts)
  end,
}
