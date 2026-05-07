local M = {}

M.file_exists_in_root = function(filename)
    local root = vim.fn.getcwd()
    local filepath = root .. "/" .. filename
    return vim.fn.filereadable(filepath) == 1
end

return M
