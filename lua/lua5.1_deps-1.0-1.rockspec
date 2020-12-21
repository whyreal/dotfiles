package = "lua5.1_deps"
version = "1.0-1"
source = {
   url = ""
}
description = {
   homepage = "",
   license = ""
}
dependencies = {
	"lua ~> 5.1",
	"dkjson >= 2.5-2",
	"inspect >= 3.1.1-0",
	"lpeglabel >= 1.6.0-1",
	"lua-lsp >= 0.1.0-2",
	"lua-resty-template >= 2.0-1",
    "luafilesystem >= 1.8.0-1"
}
build = {
   type = "builtin",
   modules = {
   }
}
