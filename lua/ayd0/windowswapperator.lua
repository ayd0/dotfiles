local api = vim.api;
local start, next;
local w = 50;

local swapWindows = function(selected, unselected, makeNarrow)
    local maxScreenSize;
    api.nvim_set_current_win(selected)
    if makeNarrow
        then
            api.nvim_win_set_width(unselected, w)
        else
            api.nvim_win_set_width(unselected, 0)
            maxScreenSize = api.nvim_win_get_width(selected)
            api.nvim_win_set_width(unselected, math.floor(maxScreenSize / 2))
        end
end

-- open new split window
vim.keymap.set("n", "<leader>r", function()
    if start == nil
        then
            start = api.nvim_get_current_win()
            vim.cmd("vs \"normal\" "..string.gsub(vim.api.nvim_buf_get_name(0), vim.loop.cwd(), ''):sub(1, -1))
            next = api.nvim_get_current_win()
        else
            print("second window already open, press `<leader>R` to close window")
        end
end)

-- close last split window
vim.keymap.set("n", "<leader>R", function()
    vim.cmd("close")
    start = nil;
    next = nil;
end)

-- set active window to start or next and lower unselected width
vim.keymap.set("n", "<leader>t", function()
    if api.nvim_get_current_win() == start
        then swapWindows(next, start, true)
        else swapWindows(start, next, true)
        end
end)

-- set active window to start or next and reset widths to half
vim.keymap.set("n", "<leader>T", function()
    if api.nvim_get_current_win() == start
        then swapWindows(next, start, false)
        else swapWindows(start, next, false)
        end
end)
