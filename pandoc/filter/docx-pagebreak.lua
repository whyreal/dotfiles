--[[
port from https://github.com/pandocker/pandoc-docx-pagebreak-py

pandoc-docx-pagebreakpy
Pandoc filter to insert pagebreak as openxml RawBlock
Only for docx output
--]] 

local pandoc = require("pandoc")

local toc = pandoc.RawBlock("openxml", [[
<w:sdt>
    <w:sdtContent xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
        <w:p>
            <w:r>
                <w:fldChar w:fldCharType="begin" w:dirty="true" />
                <w:instrText xml:space="preserve">TOC \o "1-3" \h \z \u</w:instrText>
                <w:fldChar w:fldCharType="separate" />
                <w:fldChar w:fldCharType="end" />
            </w:r>
        </w:p>
    </w:sdtContent>
</w:sdt>
]])

local pagebreak = pandoc.RawBlock("openxml", [[
<w:p>
	<w:r>
		<w:br w:type="page" />
	</w:r>
</w:p>
]])


local sectionbreak = pandoc.RawBlock("openxml", [[
<w:p>
	<w:pPr>
		<w:sectPr><w:type w:val="nextPage" /></w:sectPr>
	</w:pPr>
</w:p>",
]])

local function docx_page_break(elem)
	if elem.text == "\\newpage" then
		if FORMAT:match 'docx' then
			print("Page Break")
			elem = pagebreak
		else
			elem = {}
		end

	elseif elem.text == "\\toc" then
		if FORMAT:match 'docx' then
			print("Table of Contents")
			local attr = {}
			attr["custom-style"] = "TOC Heading"
			div = pandoc.Div({pandoc.Para(pandoc.Str("目录"))}, attr)
			elem = {div, toc}
		else
			elem = {}
		end
	end

	return elem
end

return {
	{
		RawBlock = docx_page_break
	}
}
