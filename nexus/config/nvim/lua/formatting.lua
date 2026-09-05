local M = {}

local external = {
  lua = function()
    return { "stylua", "-" }
  end,

  javascript = function(path)
    return { "prettier", "--stdin-filepath", path }
  end,
  javascriptreact = function(path)
    return { "prettier", "--stdin-filepath", path }
  end,
  typescript = function(path)
    return { "prettier", "--stdin-filepath", path }
  end,
  typescriptreact = function(path)
    return { "prettier", "--stdin-filepath", path }
  end,
  json = function(path)
    return { "prettier", "--stdin-filepath", path }
  end,
  jsonc = function(path)
    return { "prettier", "--stdin-filepath", path }
  end,
}

local function external_format(bufnr, make_cmd)
  local path = vim.api.nvim_buf_get_name(bufnr)
  local cmd = make_cmd(path ~= "" and path or "stdin")

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local input = table.concat(lines, "\n") .. "\n"

  local result = vim.system(cmd, {
    stdin = input,
    text = true,
  }):wait()

  if result.code ~= 0 then
    vim.notify(
      string.format("Formatter failed: %s", result.stderr or table.concat(cmd, " ")),
      vim.log.levels.ERROR
    )
    return false
  end

  local output = result.stdout or ""
  local formatted = vim.split(output, "\n", { plain = true })

  if formatted[#formatted] == "" then
    table.remove(formatted)
  end

  local view = vim.fn.winsaveview()
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, formatted)
  vim.fn.winrestview(view)
  return true
end

function M.format(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  local ft = vim.bo[bufnr].filetype
  local formatter = external[ft]

  if formatter then
    external_format(bufnr, formatter)
    return
  end

  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    if client:supports_method("textDocument/formatting") then
      vim.lsp.buf.format({
        bufnr = bufnr,
        async = false,
        id = client.id,
        timeout_ms = 3000,
      })
      return
    end
  end
end

vim.api.nvim_create_user_command("Format", function()
  M.format(0)
end, { desc = "Format current buffer" })

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("format_on_save", { clear = true }),
  desc = "Format before saving",
  callback = function(args)
    M.format(args.buf)
  end,
})

return M
