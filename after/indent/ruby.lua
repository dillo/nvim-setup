-- Neovim's Ruby indent file re-indents the line whenever "." is typed (for
-- leading-dot method chains). With the Tree-sitter indentexpr, the half-typed
-- line (e.g. `sorted_arr.`) doesn't parse, so it gets indented to column 0.
vim.opt_local.indentkeys:remove(".")
