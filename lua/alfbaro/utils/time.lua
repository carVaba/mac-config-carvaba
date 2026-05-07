local M = {}

M.lima_time = function()
    -- Lima is the user's local timezone.
    -- Returning local time without offset.
    return os.date("%H:%M", os.time())
end

return M
