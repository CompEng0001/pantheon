local cached_cwd = nil
local cached_files = nil

local function project_files()
  local cwd = vim.fn.getcwd()

  if cached_cwd == cwd and cached_files then
    return cached_files
  end

  local result = vim.system({
    "rg",
    "--files",
    "--hidden",
    "--glob", "!.git/*",
    "--glob", "!node_modules/*",
    "--glob", "!.cache/*",
    "--glob", "!dist/*",
    "--glob", "!build/*",
  }, { text = true }):wait()

  if result.code ~= 0 and (result.stdout or "") == "" then
    cached_cwd = cwd
    cached_files = {}
    return cached_files
  end

  cached_cwd = cwd
  cached_files = vim.split(result.stdout or "", "\n", {
    plain = true,
    trimempty = true,
  })

  return cached_files
end

function _G.native_find(text, _)
  return vim.fn.matchfuzzy(project_files(), text)
end

vim.opt.findfunc = "v:lua.native_find"

vim.keymap.set("n", "<leader>f", ":find ", {
  silent = false,
  desc = "Find file",
})

vim.api.nvim_create_autocmd("DirChanged", {
  group = vim.api.nvim_create_augroup("find_cache", { clear = true }),
  callback = function()
    cached_cwd = nil
    cached_files = nil
  end,
})
