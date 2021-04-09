#!/usr/bin/env lua5.1
package.path = "/Users/Real/.luarocks/share/lua/5.1/?.lua;"
             .. "/Users/Real/.luarocks/share/lua/5.1/?/init.lua;"
             .. "/Users/Real/Documents/vim-workspace/docs/dotfiles/vim/lua/?.lua;"
             .. "/Users/Real/Documents/vim-workspace/docs/dotfiles/vim/lua/?/init.lua;"
             .. package.path
package.cpath = "/Users/Real/.luarocks/lib/lua/5.1/?.so;" .. package.cpath


local R = require("lamda")
local lfs = require("lfs")

local x = R.maxBy(
	function (n)
	    print(n)
		return n
	end,
	0,
	{1,23,4}
)
print(x)
