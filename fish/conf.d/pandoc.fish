function md2docx
    pandoc -o (echo $argv[1] | sed 's/.md$/.docx/') $argv[1] \
        --lua-filter=$HOME/code/whyreal/dotfiles/pandoc/filter/docx-pagebreak.lua \
        --shift-heading-level-by=-1 \
        --reference-doc=$HOME/Documents/pandoc/template_new.docx
end

function md2pdf
        # 渲染 mermaid 图形
        #args = args.concat(["-F", "mermaid-filter"])

        # font size
        #args.push('--pdf-engine-opt="--minimum-font-size 14"')
    pandoc -o (echo $argv[1] | sed 's/.md$/.pdf/') $argv[1] \
        --pdf-engine wkhtmltopdf
end

function docx2md
    pandoc -o (echo $argv[1] | sed 's/.docx?$/.md/') $argv[1] \
        --extract-media=.
end
