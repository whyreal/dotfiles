require("lib")

local template = require "resty.template"

function toggle_home_zero()
    local char_postion, _ = vim.api.nvim_get_current_line():find("[^%s]") - 1
    local position = vim.api.nvim_win_get_cursor(0)
    if position[2] == char_postion then
        vim.api.nvim_win_set_cursor(0, {position[1], 0})
    else
        vim.api.nvim_win_set_cursor(0, {position[1], char_postion})
    end
end

function template_set(firstline, lastline)
    view = vim.api.nvim_buf_get_lines(0, firstline - 1, lastline, false)
    view = table.concat(view, "\n")
end

function template_render(firstline, lastline)
	local data_lines = vim.api.nvim_buf_get_lines(0, firstline - 1, lastline, false)
	for _, data in ipairs(data_lines) do
		local output = template.process(view, {d = string.split(data)})
		vim.api.nvim_buf_set_lines(0, lastline, lastline, false, string.split(output, "\n"))
	end
end

function coc_list_open_file_with(coc_list_context, cmd)
    local list_name = coc_list_context["name"]
    local label_name = coc_list_context["targets"][1]["label"]
	label_name = string.gsub(label_name, " ", "\\ ")
    if list_name == "files" then
        os.execute(cmd .. " " .. label_name)
    end
end

function cd_workspace(path)
	vim.api.nvim_command("lcd " .. path)
    vim.api.nvim_command("Explore " .. path)
end

function add_blank_line_before()
	local current_line = vim.api.nvim_win_get_cursor(0)[1]
	vim.api.nvim_buf_set_lines(0, current_line - 1, current_line - 1,0, {""})
end

function add_blank_line_after()
	local current_line = vim.api.nvim_win_get_cursor(0)[1]
	vim.api.nvim_buf_set_lines(0, current_line, current_line,0, {""})
end

--------------------------------------
--------------------------------------
function exists(v)
    if vim.eval("exists(" .. v .. ")") then
        return vim.eval(v)
    else
        return nil
    end
end

function edit_remote_file(file)
    vim.command("set buftype=nofile")
    remote_host = exists("w:remote_host")
    if remote_host then
        vim.command("e scp://" .. remote_host .. "/" .. file)
    end
end

function insert_cmd_output(cmd)
    b = vim.buffer()

    output = io.popen(cmd)
    for line in output:lines() do
        b:insert(line)
    end
    btarget[1] = nil
end

function update_server_info()
    vim.command("set fdm=marker buftype=nofile")
    local script = "~/.vim/scripts/server_info.sh"

    local remote_host = exists("w:remote_host")
    if remote_host then
        local cmd = "cat " .. script .." | ssh -T " .. remote_host
        vim.window().line = 1
        vim.command("normal dG")
        insert_cmd_output(cmd)
        vim.window().line = 1
    end
end

