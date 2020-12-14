function table.slice(tbl, first, last, step)
    local sliced = {}

    for i = first or 1, last or #tbl, step or 1 do
        sliced[#sliced+1] = tbl[i]
    end

    return sliced
end

function string.split(inputstr, sep)
    if sep == nil then sep = "%s" end

    local t={}

	if inputstr == nil then return t end

    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

string.find_right = string.find
string.find_left = function (s, pattern, index, plain)
	local len = string.len(s)
	local right, left

	if plain then
		right, left = string.find(s:reverse(), pattern:reverse(), len - index, plain)
	else
		right, left = string.find(s:reverse(), pattern, len - index, plain)
	end

	if right == nil then
		return nil, nil
	end

	left = len - left + 1
	right = len - right + 1

	return left, right
end
