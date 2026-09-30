return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    local transparent = false -- set to true if you would like to enable transparency

    require("catppuccin").setup({
      flavour = "macchiato",
      transparent_background = transparent,
      custom_highlights = function(colors)
        return {
          -- Keep guides close to the background, with a subtly stronger active scope.
          QuietIndentGuide = { fg = colors.surface0, nocombine = true },
          QuietIndentScope = { fg = colors.surface1, nocombine = true },
        }
      end,
    })

    vim.cmd("colorscheme catppuccin")
  end,
}
