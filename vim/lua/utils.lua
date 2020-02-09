require("lib")

local template = require "resty.template"
template.print = function(s) return s end

function docs_add_favorite(target)
    os.execute("cd ~/Documents/vim-workspace/docs/ && ln -s " .. target .. " ./")
end

function coc_list_open_file_with(coc_list_context, cmd)
    local list_name = coc_list_context["name"]
    local label_name = coc_list_context["targets"][0]["label"]
    if list_name == "files" then
        os.execute(cmd .. " " .. label_name)
    end
end

function cd_workspace(path)
    vim.command("cd " .. path)
    vim.command("Explore" .. path)
end

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

function toggle_home_zero()
    local char_postion, _ = vim.buffer()[vim.window().line]:find("[^%s]")
    if vim.window().col == char_postion then
        vim.window().col = 1
    else
        vim.window().col = char_postion
    end
end

function detect_voom_type()
    local fdm = vim.eval("&fdm")
    local ft = vim.eval("&ft")
    local voom_ft_modes = vim.eval("g:voom_ft_modes")

    if fdm == "marker" then
        voom_ft_modes[ft] = "fmr"
    end
end

function template_set()
    view = table.slice(vim.buffer(), vim.firstline, vim.lastline)
    view = table.concat(view, "\n")
end

function template_render()
    vim.buffer():insert("", vim.lastline)
    local data_lines = table.slice(vim.buffer(), vim.firstline, vim.lastline)
    for _, data in ipairs(data_lines) do

        local output = template.render(view, {l = string.split(data)})

        for i, output_line in ipairs(string.split(output, "\n")) do
            -- 前面插入了一个空行, 这里正好从 lastline 的下一行开始插入
            vim.buffer():insert(output_line, vim.lastline + i)
        end
    end
end
