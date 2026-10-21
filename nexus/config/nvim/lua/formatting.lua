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
		return { "prettier", "--parser", "jsonc", "--stdin-filepath", path }
	end,
}

local function external_format(bufnr, make_cmd)
	local path = vim.api.nvim_buf_get_name(bufnr)
	local cmd = make_cmd(path ~= "" and path or "stdin")

	-- Check whether the executable exists.
	if vim.fn.executable(cmd[1]) == 0 then
		return false
	end

	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local input = table.concat(lines, "\n") .. "\n"

	local ok, result = pcall(function()
		return vim.system(cmd, {
			stdin = input,
			text = true,
		}):wait()
	end)

	if not ok then
		vim.notify(string.format("Unable to execute formatter: %s", cmd[1]), vim.log.levels.WARN)
		return false
	end

	if result.code ~= 0 then
		vim.notify(string.format("Formatter failed: %s", result.stderr or table.concat(cmd, " ")), vim.log.levels.ERROR)
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

local function lsp_format(bufnr)
	local clients = vim.lsp.get_clients({ bufnr = bufnr })

	for _, client in ipairs(clients) do
		if client:supports_method("textDocument/formatting") then
			vim.lsp.buf.format({
				bufnr = bufnr,
				async = false,
				id = client.id,
				timeout_ms = 3000,
			})

			return true
		end
	end

	return false
end

function M.format(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	local ft = vim.bo[bufnr].filetype
	local formatter = external[ft]

	-- Prefer external formatter when available.
	if formatter and external_format(bufnr, formatter) then
		return
	end

	-- Fall back to LSP formatting.
	lsp_format(bufnr)
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
