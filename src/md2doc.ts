import { spawn } from "child_process";

const mdFile: string = process.argv[2]

const docxFile: string = mdFile.replace(/md$/, "docx")

let args: string[] = ["-s", "-f", "markdown", "-t", "docx"]

// enable \newpage \toc
args.push("--lua-filter=" + process.env["HOME"] + "/code/whyreal/dotfiles/pandoc/filter/docx-pagebreak.lua")

// 目标格式
args.push("--shift-heading-level-by=-1")
args.push("--reference-doc=" + process.env["HOME"] + "/Documents/pandoc/template.docx")

args.push(mdFile)
args = args.concat(["-o", docxFile])

function convert() {
        
    const convertor = spawn("pandoc", args)

    convertor.stderr.on("data", (data: Buffer) => {
        console.log(`${data}`);
        
    } )
    convertor.stdout.on("data", (data: Buffer) => {
        console.log(`${data}`);
        
    } )
}

module.exports = {
    convert
}
