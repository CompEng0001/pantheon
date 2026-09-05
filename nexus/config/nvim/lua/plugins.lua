-- This file only configures plugins installed by Nix.  There is no Lua plugin
-- manager in ~/.config/nvim.

-- indentLine.
vim.g.indentLine_char_list = { "|", "¦", "┆", "┊" }
vim.g.indentLine_setColors = 1
vim.g.indentLine_fileTypeExclude = { "help", "main", "netrw", "json" }

-- vim-better-whitespace.  This plugin provides :StripWhitespace.
vim.g.better_whitespace_filetypes_blacklist = {
  "diff",
  "gitcommit",
  "help",
  "markdown",
  "netrw",
}

vim.keymap.set("n", "<leader>sw", "<cmd>StripWhitespace<cr>", {
  silent = true,
  desc = "Strip trailing whitespace",
})

-- vim-signify.
-- updatetime is set to 100 in options.lua so signs refresh quickly.

-- Goyo + Limelight.
vim.g.limelight_default_coefficient = 0.7

local writing_group = vim.api.nvim_create_augroup("writing_plugins", { clear = true })

vim.api.nvim_create_autocmd("User", {
  group = writing_group,
  pattern = "GoyoEnter",
  callback = function()
    pcall(vim.cmd, "Limelight")
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = writing_group,
  pattern = "GoyoLeave",
  callback = function()
    pcall(vim.cmd, "Limelight!")
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  group = writing_group,
  callback = function()
    pcall(vim.cmd, "Limelight 0.7")
  end,
})

-- vimtex.
vim.g.tex_flavor = "latex"

-- vim-hexokinase.
vim.g.Hexokinase_highlighters = { "backgroundfull" }
vim.g.Hexokinase_refreshEvents = {
  "TextChanged",
  "TextChangedI",
  "InsertLeave",
  "BufRead",
}

-- minimap-vim.
vim.g.minimap_auto_start = 1
vim.g.minimap_auto_start_win_enter = 1
