local servers = {
  "bash_ls",
  "clangd",
  "ltex_plus",
  "lua_ls",
  "nixd",
  "rust_analyzer",
}

vim.lsp.enable(servers)

local group = vim.api.nvim_create_augroup("native_lsp", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  callback = function(event)
    local bufnr = event.buf
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    local function map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, {
        buffer = bufnr,
        silent = true,
        desc = desc,
      })
    end

    map("gd", vim.lsp.buf.definition, "LSP definition")
    map("gD", vim.lsp.buf.declaration, "LSP declaration")
    map("gr", vim.lsp.buf.references, "LSP references")
    map("gI", vim.lsp.buf.implementation, "LSP implementation")
    map("K", vim.lsp.buf.hover, "LSP hover")
    map("<leader>rn", vim.lsp.buf.rename, "LSP rename")
    map("<leader>ca", vim.lsp.buf.code_action, "LSP code action")

    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    end
  end,
})
