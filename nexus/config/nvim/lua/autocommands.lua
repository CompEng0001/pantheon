-- Highlight yanked text briefly.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  desc = "Highlight selection on yank",
  callback = function()
    vim.highlight.on_yank({ timeout = 200, visual = true })
  end,
})

-- Restore the cursor position from the previous editing session.
vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("restore_cursor", { clear = true }),
  desc = "Restore cursor position",
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)

    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(args.buf) then
          vim.cmd("normal! zz")
        end
      end)
    end
  end,
})

-- Make 'autoread' useful when files are changed by another program.
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  group = vim.api.nvim_create_augroup("check_external_changes", { clear = true }),
  desc = "Check whether files changed outside Neovim",
  callback = function()
    if vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
})
