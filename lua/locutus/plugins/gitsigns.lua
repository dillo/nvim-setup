return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    current_line_blame = false,
    on_attach = function(bufnr)
      local gitsigns = require("gitsigns")

      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end

      map("n", "]c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gitsigns.nav_hunk("next")
        end
      end, "Next Git hunk")

      map("n", "[c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gitsigns.nav_hunk("prev")
        end
      end, "Previous Git hunk")

      map("n", "<leader>gp", gitsigns.preview_hunk, "Preview Git hunk")
      map("n", "<leader>gs", gitsigns.stage_hunk, "Stage or unstage Git hunk")
      map("v", "<leader>gs", function()
        gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Stage selected Git lines")
      map("n", "<leader>gr", gitsigns.reset_hunk, "Reset Git hunk")
      map("v", "<leader>gr", function()
        gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Reset selected Git lines")
      map("n", "<leader>gu", gitsigns.undo_stage_hunk, "Undo staged Git hunk")
      map("n", "<leader>gb", function()
        gitsigns.blame_line({ full = true })
      end, "Blame current line")
      map("n", "<leader>gd", gitsigns.diffthis, "Diff current file")
      map({ "o", "x" }, "ih", gitsigns.select_hunk, "Select Git hunk")
    end,
  },
}
