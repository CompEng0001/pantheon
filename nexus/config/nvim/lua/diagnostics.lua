vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
  },
})

-- Old ALEDetail-style behaviour: show the complete diagnostic under cursor.
vim.keymap.set("n", "<leader>m", function()
  vim.diagnostic.open_float(nil, {
    focus = false,
    scope = "cursor",
  })
end, { silent = true, desc = "Diagnostic under cursor" })

vim.keymap.set("n", "<leader>d", function()
  vim.diagnostic.setqflist()
  vim.cmd.copen()
end, { silent = true, desc = "Diagnostics quickfix list" })

vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { silent = true, desc = "Previous diagnostic" })

vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { silent = true, desc = "Next diagnostic" })
