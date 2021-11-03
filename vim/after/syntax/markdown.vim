unlet! b:current_syntax
syn region markdownFrontMatter matchgroup=Delimiter start="\%^---$" end="^\(---\|\.\.\.\)$" contains=@yamlFrontMatter keepend
syn include @yamlFrontMatter syntax/yaml.vim

let b:current_syntax = "markdown"

