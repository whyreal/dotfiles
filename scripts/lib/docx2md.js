"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const child_process_1 = require("child_process");
if (process.argv.length < 3) {
    console.error("give me a markfile file!!!");
    process.exit(1);
}
const docxFile = process.argv[2];
const mdFile = docxFile.replace(/docx$/, "md");
let args = ["-s", "-f", "docx", "-t", "markdown"];
// 目标格式
args.push("--extract-media=.");
args.push(docxFile);
args = args.concat(["-o", mdFile]);
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
