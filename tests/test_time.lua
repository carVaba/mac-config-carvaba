-- Simple test runner for Lua
local function assert_eq(actual, expected, message)
    if actual ~= expected then
        error(string.format("Assertion failed: expected '%s', got '%s'. %s", tostring(expected), tostring(actual), message or ""))
    end
end

-- Mocking environment
_G.os = _G.os or {}
local real_os_time = os.time
local real_os_date = os.date

local mock_time_val = 0
os.time = function() return mock_time_val end

-- We need to mock os.date to be deterministic
os.date = function(fmt, time)
    local t = time or mock_time_val
    local hours = math.floor((t % 86400) / 3600)
    local mins = math.floor((t % 3600) / 60)
    return string.format("%02d:%02d", hours, mins)
end

-- Load the module
local time_utils = require("lua.alfbaro.utils.time")

print("Running tests for lima_time...")

-- Test Case 1: Midnight
mock_time_val = 0 -- 00:00
assert_eq(time_utils.lima_time(), "00:00", "Test Case 1 failed")

-- Test Case 2: Noon
mock_time_val = 12 * 3600 -- 12:00
assert_eq(time_utils.lima_time(), "12:00", "Test Case 2 failed")

-- Test Case 3: Late evening
mock_time_val = 23 * 3600 + 59 * 60 -- 23:59
assert_eq(time_utils.lima_time(), "23:59", "Test Case 3 failed")

print("All tests passed!")

-- Restore real os functions
os.time = real_os_time
os.date = real_os_date
