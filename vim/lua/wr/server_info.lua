local si = { }

function si:new(host, script)
	local o = {}

	o.host = vim.w.SI_host
	o.script = script or os.getenv("HOME") .. "/.vim/scripts/server_info.sh"
	o.cmd = "cat " .. o.script .." | ssh -T " .. o.host

	setmetatable(o, self)
	self.__index = self
	return o
end

function si:edit_remote_file(file)
    vim.cmd("set buftype=nofile")
	vim.cmd("e scp://" .. self.host .. "/" .. file)
end

function si:insert_cmd_output()
    local output = io.popen(self.cmd):read("*a"):split("\n")

	vim.api.nvim_buf_set_lines(0, 1, vim.api.nvim_buf_line_count(0), false, output)
end

function si:update_server_info()
    vim.cmd("set fdm=marker buftype=nofile")
	si:insert_cmd_output()
end

function si:split()
	vim.cmd[[new]]
    vim.cmd("set buftype=nofile")
	vim.w.SI_ip = self.host
end

return si
