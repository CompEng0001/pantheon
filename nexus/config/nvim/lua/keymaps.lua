local map = vim.keymap.set

-- Write and quit.
map("n", "<leader>w", "<cmd>write<cr>", { silent = true, desc = "Write" })
map("n", "<leader>q", "<cmd>quit<cr>", { silent = true, desc = "Quit" })

-- Redo.
map("n", "U", "<C-r>", { silent = true, desc = "Redo" })

-- Move between splits.
map("n", "<C-h>", "<C-w>h", { silent = true, desc = "Left split" })
map("n", "<C-j>", "<C-w>j", { silent = true, desc = "Lower split" })
map("n", "<C-k>", "<C-w>k", { silent = true, desc = "Upper split" })
map("n", "<C-l>", "<C-w>l", { silent = true, desc = "Right split" })

-- Writing mode.
map("n", "<leader>z", "<cmd>Goyo<cr>", { silent = true, desc = "Goyo" })

-- Minimap toggle.
map("n", "<leader>mm", "<cmd>MinimapToggle<cr>", {
  silent = true,
  desc = "Toggle minimap",
})
