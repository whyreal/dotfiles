local luaunit = require('luaunit')
local C = require("wr.Cursor")
local l = require("wr.utils")

TestCursor = {}

TestCursor.test_new = function ()
	local c = C:new({2, 5})
	luaunit.assertEquals(c, {line = 2, col = 5})
end

TestCursor.test_fromVim = function ()
	local c = C:new({2, 5})
	c:fromVim()
	luaunit.assertEquals(c, {line = 2, col = 6})
end
TestCursor.test_toVim = function ()
	local c = C:new({2, 5})
	c:toVim()
	luaunit.assertEquals(c, {line = 2, col = 4})
end
TestCursor.test_moveToLineEnd = function ()
	local c = C:new({2, 5})
	c:moveToLineEnd()
	luaunit.assertEquals(c, {line = 2, col = 11})
end
TestCursor.test_moveToLineBegin = function ()
	local c = C:new({2, 5})
	c:moveToLineBegin()
	luaunit.assertEquals(c, {line = 2, col = 1})
end

os.exit(luaunit.LuaUnit.run())
