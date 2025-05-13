return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  ---@module "ibl"
  ---@type ibl.config
  opts = {
    indent = {
      -- char = "▏",
      -- char = "│",
      char = "┊",
      -- char = "┆",
      -- char = "┊",
      -- char = "│",
      -- char = "▏",
      -- char = "┆",
      -- char = "┊",
      -- char = "│",
      -- char = "▏",
      highlight = { "NonText" },
    },
    scope = {
      enabled = true,
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

