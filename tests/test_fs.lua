-- Simple test runner for Lua
local function assert_eq(actual, expected, message)
    if actual ~= expected then
        error(string.format("Assertion failed: expected '%s', got '%s'. %s", tostring(expected), tostring(actual), message or ""))
    end
end

-- Mocking environment
_G.vim = _G.vim or {}
_G.vim.fn = _G.vim.fn or {}

local mock_cwd = "/home/user/project"
local readable_files = {
    ["/home/user/project/.swiftlint.yml"] = 1,
    ["/home/user/project/existing_file.txt"] = 1,
}

vim.fn.getcwd = function() return mock_cwd end
vim.fn.filereadable = function(path)
    return readable_files[path] or 0
end

-- Package path adjustment to find the module
package.path = package.path .. ";./?.lua"

-- Load the module
-- Since we are running from root, we need to provide the full path or adjust package.path
local fs_utils = require("lua.alfbaro.utils.fs")

print("Running tests for file_exists_in_root...")

-- Test Case 1: Existing file
assert_eq(fs_utils.file_exists_in_root(".swiftlint.yml"), true, "Test Case 1 failed: .swiftlint.yml should exist")

-- Test Case 2: Another existing file
assert_eq(fs_utils.file_exists_in_root("existing_file.txt"), true, "Test Case 2 failed: existing_file.txt should exist")

-- Test Case 3: Non-existing file
assert_eq(fs_utils.file_exists_in_root("missing_file.txt"), false, "Test Case 3 failed: missing_file.txt should not exist")

-- Test Case 4: Verify path concatenation
local last_path_checked = ""
local original_filereadable = vim.fn.filereadable
vim.fn.filereadable = function(path)
    last_path_checked = path
    return original_filereadable(path)
end

fs_utils.file_exists_in_root("some_file.lua")
assert_eq(last_path_checked, mock_cwd .. "/some_file.lua", "Test Case 4 failed: Incorrect path concatenation")

print("All tests passed!")
