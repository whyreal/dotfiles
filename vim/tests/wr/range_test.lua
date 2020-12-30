local luaunit = require('luaunit')
local C = require("wr.Cursor")
local R = require("wr.Range")
local l = require("wr.utils")

TestRange = {}

TestRange.test_new = function ()
	local start = C:new({2, 5})
	local stop = C:new({3, 3})
	local r = R:new(start, stop)
	luaunit.assertEquals(r.start, start)
	luaunit.assertEquals(r.stop, stop)
end


TestRange.test_newFromFind = function ()
	local start = C:new({2, 5})
	local stop = C:new({3, 3})
	local r = R:newFromFind(C:new{3, 7}, "**", true, true)
	luaunit.assertEquals(r.start, C:new{3, 11})
	luaunit.assertEquals(r.stop, C:new{3, 12})

	local r = R:newFromFind(C:new{3, 7}, "**", false, true)
	luaunit.assertEquals(r.start, C:new{3, 4})
	luaunit.assertEquals(r.stop, C:new{3, 5})
end

TestRange.test_newFromVisual = function ()
	vim.fn.setpos("'<", {0, 2, 3, 0})
	vim.fn.setpos("'>", {0, 3, 4, 0})
	local r = R:newFromVisual()
	luaunit.assertEquals(r.start, C:new{2, 3})
	luaunit.assertEquals(r.stop, C:new{3, 4})
end

os.exit(luaunit.LuaUnit.run())
