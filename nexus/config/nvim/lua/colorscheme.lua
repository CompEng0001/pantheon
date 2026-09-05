vim.cmd.colorscheme("tender")

-- Keep the terminal background visible.  Remove this if you want Tender's
-- normal background colour instead.
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
