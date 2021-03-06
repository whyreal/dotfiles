"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const child_process_1 = require("child_process");
if (process.argv.length < 3) {
    console.error("give me a markfile file!!!");
    process.exit(1);
}
const mdFile = process.argv[2];
const pdfFile = mdFile.replace(/md$/, "pdf");
let args = ["-s", "--toc", "-f", "markdown", "-t", "pdf"];
// 渲染 mermaid 图形
//args = args.concat(["-F", "mermaid-filter"])
// pdf engine
args = args.concat("--pdf-engine", "wkhtmltopdf");
// font size
//args.push('--pdf-engine-opt="--minimum-font-size 14"')
args.push(mdFile);
args = args.concat(["-o", pdfFile]);
function convert() {
    const convertor = child_process_1.spawn("pandoc", args);
    console.log(convertor.spawnargs);
    convertor.stderr.on("data", (data) => {
        console.log(`${data}`);
    });
    convertor.stdout.on("data", (data) => {
        console.log(`${data}`);
    });
}
module.exports = {
    convert
};
