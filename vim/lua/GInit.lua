local R = require"lamda"

_G.HOME = vim.env.HOME
_G.DefaultBrowser = "Microsoft Edge.app"
_G.PROJECTS = {
    Notes     = "~/Documents/Notes/",
    Downloads = "~/Downloads",
    dotfile   = "~/code/whyreal/dotfiles/",
    vimconfig = "~/code/whyreal/dotfiles/vim/"
}
_G.imap = require("wr.imap")
_G.smap = require("wr.smap")
_G.print = R.curry1(R.pipe(vim.inspect, print))

string.split = R.flip(R.split)
string.strip = R.flip(R.trim)
function string:find_left (pattern, index, plain)
	local len = self:len()
	local right, left

	if plain then
		right, left = string.find(self:reverse(), pattern:reverse(), len - index, plain)
	else
		right, left = string.find(self:reverse(), pattern, len - index, plain)
	end

	if right == nil then
		return nil, nil
	end

	left = len - left + 1
	right = len - right + 1

	return left, right
end

_G.S = {
markdown = require"service.markdown",
link = require"service.link"
}
