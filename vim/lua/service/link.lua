local Link = require"wr.Link"

local M = {}

--command -buffer CopyFragLinkW lua require[[wr.Link]]:copyFragLinkW(true)
--command -buffer CopyNoFragLinkW lua require[[wr.Link]]:copyFragLinkW()
--command -buffer CopyFragLinkB lua require[[wr.Link]]:copyFragLinkB()
--command -buffer CopyFragLinkJ lua require[[wr.Link]]:copyJoplinLink(true)
--command -buffer CopyNoFragLinkJ lua require[[wr.Link]]:copyJoplinLink(false)




--" open Link
--nmap <buffer> gf gl
--nmap <buffer> gl <cmd>lua require[[wr.Link]]:new():open()<CR>
--" resolv file in Finder
--nmap <buffer> gr <cmd>lua require[[wr.Link]]:new():resolv()<CR>
--" copy id (joplin) or path (local , path ...)
--nmap <buffer> gy <cmd>lua require[[wr.Link]]:new():copy()<CR>

function M.copy()
    vim.fn.setreg("+", Link:new().url)
end

function M.resolv()
    Link:new():resolv()
end

function M.open()
    Link:new():open()
end

return M
