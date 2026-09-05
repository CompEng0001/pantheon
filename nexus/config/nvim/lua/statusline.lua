local modes = {
  n = "NORMAL",
  i = "INSERT",
  v = "VISUAL",
  V = "V-LINE",
  ["\22"] = "V-BLOCK",
  c = "COMMAND",
  t = "TERMINAL",
  R = "REPLACE",
  s = "SELECT",
  S = "S-LINE",
  ["\19"] = "S-BLOCK",
}

local function setup_highlights()
  local pmenu = vim.api.nvim_get_hl(0, { name = "PmenuSel", link = false })
  local directory = vim.api.nvim_get_hl(0, { name = "Directory", link = false })
  local visual = vim.api.nvim_get_hl(0, { name = "Visual", link = false })

  vim.api.nvim_set_hl(0, "StlMode", { fg = pmenu.fg, bg = visual.bg })
  vim.api.nvim_set_hl(0, "StlGit", { fg = directory.fg, bg = pmenu.bg })
end

setup_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("statusline_colors", { clear = true }),
  callback = setup_highlights,
})

local function git(args, cwd)
  local cmd = { "git", "-C", cwd }
  vim.list_extend(cmd, args)

  local result = vim.system(cmd, { text = true }):wait()
  if result.code ~= 0 then
    return nil
  end

  return (result.stdout or ""):gsub("%s+$", "")
end

local function update_git_info(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  local cwd = name ~= "" and vim.fs.dirname(name) or vim.fn.getcwd()

  if not cwd or cwd == "" then
    vim.b[bufnr].git_branch = nil
    vim.b[bufnr].rel_path = "%f"
    return
  end

  local root = git({ "rev-parse", "--show-toplevel" }, cwd)
  if not root or root == "" then
    vim.b[bufnr].git_branch = nil
    vim.b[bufnr].rel_path = name ~= "" and vim.fn.fnamemodify(name, ":~:.") or "%f"
    return
  end

  vim.b[bufnr].git_branch = git({ "branch", "--show-current" }, cwd)

  if name:sub(1, #root + 1) == root .. "/" then
    vim.b[bufnr].rel_path = name:sub(#root + 2)
  else
    vim.b[bufnr].rel_path = name ~= "" and vim.fn.fnamemodify(name, ":~:.") or "%f"
  end
end

function _G.statusline()
  local mode = modes[vim.fn.mode()] or vim.fn.mode():upper()
  local branch = vim.b.git_branch and vim.b.git_branch ~= ""
      and ("%#StlGit# " .. vim.b.git_branch .. " %*")
    or ""
  local path = vim.b.rel_path or "%f"

  local diagnostic = ""
  local labels = {
    [vim.diagnostic.severity.ERROR] = { " ", "DiagnosticError" },
    [vim.diagnostic.severity.WARN] = { " ", "DiagnosticWarn" },
    [vim.diagnostic.severity.INFO] = { " ", "DiagnosticInfo" },
    [vim.diagnostic.severity.HINT] = { " ", "DiagnosticHint" },
  }

  local counts = vim.diagnostic.count(0)
  for severity = vim.diagnostic.severity.ERROR, vim.diagnostic.severity.HINT do
    local count = counts[severity] or 0
    if count > 0 then
      local item = labels[severity]
      diagnostic = diagnostic
        .. "%#"
        .. item[2]
        .. "#"
        .. item[1]
        .. count
        .. "%* "
    end
  end

  local filetype = vim.bo.filetype ~= "" and vim.bo.filetype or "text"

  return "%#StlMode# "
    .. mode
    .. " %*"
    .. branch
    .. " "
    .. path
    .. "%="
    .. diagnostic
    .. filetype
    .. " %l:%c"
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
  group = vim.api.nvim_create_augroup("statusline_git", { clear = true }),
  callback = function(args)
    update_git_info(args.buf)
  end,
})

vim.api.nvim_create_autocmd("DiagnosticChanged", {
  group = vim.api.nvim_create_augroup("statusline_diagnostics", { clear = true }),
  callback = function()
    vim.cmd("redrawstatus")
  end,
})

vim.o.statusline = "%!v:lua.statusline()"
