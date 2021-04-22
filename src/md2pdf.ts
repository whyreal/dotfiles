import { spawn } from "child_process";

const mdFile: string = process.argv[2]

const pdfFile: string = mdFile.replace(/md$/, "pdf")

let args: string[] = ["-s", "--toc", "-f", "markdown", "-t", "pdf"]

// 渲染 mermaid 图形
//args = args.concat(["-F", "mermaid-filter"])

// pdf engine
args = args.concat("--pdf-engine", "wkhtmltopdf")
// font size
//args.push('--pdf-engine-opt="--minimum-font-size 14"')

args.push(mdFile)
args = args.concat(["-o", pdfFile])

function convert() {
        
    const convertor = spawn("pandoc", args)
    console.log(convertor.spawnargs);
    

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
