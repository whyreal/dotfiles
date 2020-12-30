local luaunit = require('luaunit')
local l = require("wr.utils")

Test_link_parse = {
	test_markdown_link = function()
		local t = "[github](https://github.com:443/whyreal/NOTE?a=b#fragment1 Note)"
		local o = l.parse_link(t)
		luaunit.assertEquals(o.domain, "github.com")
		luaunit.assertEquals(o.schema, "https")
		luaunit.assertEquals(o.title, "Note")
		luaunit.assertEquals(o.id, "github")
		luaunit.assertEquals(o.port, "443")
		luaunit.assertEquals(o.query, "a=b")
		luaunit.assertEquals(o.fragment, "fragment1")
		luaunit.assertEquals(o.path, "/whyreal/NOTE")
	end,
	test_markdown_local_link = function()
		local t = "[github](whyreal/NOTE#fragment1 Note)"
		local o = l.parse_link(t)
		luaunit.assertEquals(o.title, "Note")
		luaunit.assertEquals(o.id, "github")
		luaunit.assertEquals(o.fragment, "fragment1")
		luaunit.assertEquals(o.path, "whyreal/NOTE")
	end,
	test_normal_link = function ()
		local t = "https://github.com/whyreal/NOTE?a=b#fragment1"
		local o = l.parse_link(t)
		luaunit.assertEquals(o.domain, "github.com")
		luaunit.assertEquals(o.schema, "https")
		luaunit.assertEquals(o.path, "/whyreal/NOTE")
		luaunit.assertEquals(o.query, "a=b")
		luaunit.assertEquals(o.fragment, "fragment1")

		local t = "https://github.com/whyreal/NOTE?a=b"
		local o = l.parse_link(t)
		luaunit.assertEquals(o.query, "a=b")

		local t = "https://github.com/whyreal/NOTE#fragment1"
		local o = l.parse_link(t)
		luaunit.assertEquals(o.fragment, "fragment1")

		local t = "https://github.com/whyreal/NOTE"
		local o = l.parse_link(t)
		luaunit.assertEquals(o.path, "/whyreal/NOTE")

		local t = "https://github.com/"
		local o = l.parse_link(t)
		luaunit.assertEquals(o.domain, "github.com")

		local t = "https://github.com"
		local o = l.parse_link(t)
		luaunit.assertEquals(o.domain, "github.com")
	end,
	test_normal_local_link = function ()
		local t = "/whyreal/NOTE#fragment1"
		local o = l.parse_link(t)
		luaunit.assertEquals(o.path, "/whyreal/NOTE")
		luaunit.assertEquals(o.fragment, "fragment1")

		local t = "whyreal/NOTE#fragment1"
		local o = l.parse_link(t)
		luaunit.assertEquals(o.path, "whyreal/NOTE")
		luaunit.assertEquals(o.fragment, "fragment1")
	end,
	test_fragment_link = function ()
		local t = "#fragment1"
		local o = l.parse_link(t)
		luaunit.assertEquals(o.fragment, "fragment1")
	end,
	test_nil_link = function ()
		local t = "[xxx]"
		local o = l.parse_link(t)
		luaunit.assertEquals(o, nil)
	end
}

Test_title_parse = {
	test_title_parse = function ()
		local t = "## tttt"
		local o = l.parse_title(t)
		luaunit.assertEquals(o, "tttt")
	end,
	test_link_parse = function ()
		local t = "## [tttt tttt](lsdkjf)"
		local o = l.parse_title(t)
		luaunit.assertEquals(o, "tttt tttt")
	end
}


os.exit(luaunit.LuaUnit.run())
