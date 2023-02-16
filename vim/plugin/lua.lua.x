HOME = vim.env.HOME
DefaultBrowser = "Microsoft Edge.app"

if vim.fn.has('gui_vimr') then
    package.path = HOME .. "/.luarocks/share/lua/5.1/?.lua;"
                .. HOME .. "/.luarocks/share/lua/5.1/?/init.lua;"
                .. package.path

    package.cpath = HOME .. "/.luarocks/lib/lua/5.1/?.so;" .. package.cpath
end

require("wr")
