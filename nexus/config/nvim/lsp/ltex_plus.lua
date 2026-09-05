local language_ids = {
  bib = "bibtex",
  pandoc = "markdown",
  plaintex = "tex",
  rnoweb = "rsweave",
  rst = "restructuredtext",
  tex = "latex",
  text = "plaintext",
}

local filetypes = {
  "bib",
  "context",
  "gitcommit",
  "html",
  "mail",
  "markdown",
  "mdx",
  "org",
  "pandoc",
  "plaintex",
  "quarto",
  "rmd",
  "rnoweb",
  "rst",
  "tex",
  "text",
  "typst",
  "xhtml",
}

local function language_id(_, filetype)
  return language_ids[filetype] or filetype
end

local enabled = {}
local seen = {}
for _, filetype in ipairs(filetypes) do
  local id = language_id(nil, filetype)
  if not seen[id] then
    seen[id] = true
    table.insert(enabled, id)
  end
end

---@type vim.lsp.Config
return {
  cmd = { "ltex-ls-plus" },
  filetypes = filetypes,
  get_language_id = language_id,
  root_dir = function(bufnr, on_dir)
    local name = vim.api.nvim_buf_get_name(bufnr)
    local root = vim.fs.root(name, { ".git" })
      or vim.fs.dirname(name)
      or vim.fn.getcwd()
    on_dir(root)
  end,
  settings = {
    ltex = {
      enabled = enabled,
    },
  },
}
