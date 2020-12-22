local si = {}
function si.edit_remote_file(file)
    vim.command("set buftype=nofile")
    local remote_host = exists("w:remote_host")
    if remote_host then
        vim.command("e scp://" .. remote_host .. "/" .. file)
    end
end

local function insert_cmd_output(cmd)
    local b = vim.buffer()

    local output = io.popen(cmd)
    for line in output:lines() do
        b:insert(line)
    end
    btarget[1] = nil
end

function si.update_server_info()
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

return si