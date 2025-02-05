if vim.fn.has("nvim-0.7.0") == 0 then
	vim.api.nvim_err_writeln("streamline requires at least nvim-0.7.0")
	return
end

-- Prevent loading twice
if vim.g.loaded_streamline ~= nil then
	return
end

vim.g.loaded_streamline = 1
