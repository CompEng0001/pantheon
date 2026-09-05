vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.g.netrw_browse_split = 0
vim.g.netrw_altfile = 1

vim.keymap.set("n", "<leader>e", "<cmd>Lexplore<cr>", {
  silent = true,
  desc = "File explorer",
})

-- netrw's built-in '%' creates a new file in the netrw window.  Create it in
-- the selected directory, then open it in the previous editing window instead.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("netrw_custom", { clear = true }),
  pattern = "netrw",
  callback = function()
    vim.keymap.set("n", "%", function()
      local name = vim.fn.input("Enter filename: ")
      if name == "" then
        return
      end

      local dir = vim.b.netrw_curdir or vim.fn.getcwd()
      local path = vim.fs.joinpath(dir, name)

      if vim.fn.filereadable(path) == 1 or vim.fn.isdirectory(path) == 1 then
        vim.notify("Already exists: " .. name, vim.log.levels.WARN)
        return
      end

      if name:match("/$") then
        vim.fn.mkdir(path, "p")
        vim.cmd("edit")
        return
      end

      local parent = vim.fs.dirname(path)
      if parent then
        vim.fn.mkdir(parent, "p")
      end

      local file, err = io.open(path, "w")
      if not file then
        vim.notify("Failed to create " .. name .. ": " .. tostring(err), vim.log.levels.ERROR)
        return
      end
      file:close()

      if vim.fn.winnr("#") ~= 0 then
        vim.cmd("wincmd p")
      end
      vim.cmd("edit " .. vim.fn.fnameescape(path))
    end, {
      buffer = true,
      silent = true,
      desc = "Create file in previous window",
    })
  end,
})
