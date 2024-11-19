print(package.path);

local Person = require"domain.Person"

local m = Person:new{name="whyreal", age=100}
m:echo()
