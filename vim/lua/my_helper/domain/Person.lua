M = {
    name = "",
    age = 0
}
function M:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function M:echo()
    print(self.name, self.age)
end

return M
