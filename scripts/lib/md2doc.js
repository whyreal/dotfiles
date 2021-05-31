"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const child_process_1 = require("child_process");
if (process.argv.length < 3) {
    console.error("give me a markfile file!!!");
    process.exit(1);
}
const mdFile = process.argv[2];
const docxFile = mdFile.replace(/md$/, "docx");
let args = ["-s", "-f", "markdown", "-t", "docx"];
// enable \newpage \toc
args.push("--lua-filter=" + process.env["HOME"] + "/code/whyreal/dotfiles/pandoc/filter/docx-pagebreak.lua");
// 目标格式
args.push("--shift-heading-level-by=-1");
args.push("--reference-doc=" + process.env["HOME"] + "/Documents/pandoc/template.docx");
args.push(mdFile);
args = args.concat(["-o", docxFile]);
function convert() {
    const convertor = child_process_1.spawn("pandoc", args);
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
