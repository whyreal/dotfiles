
package.path = vim.fn.getenv("HOME") .. "/.luarocks/share/lua/5.1/?.lua;"
             .. vim.fn.getenv("HOME") .. "/.luarocks/share/lua/5.1/?/init.lua;"
             .. package.path
package.cpath = vim.fn.getenv("HOME") .. "/.luarocks/lib/lua/5.1/?.so;" .. package.cpath

require('wr')
