"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const child_process_1 = require("child_process");
class Pandoc {
    constructor(inputFile, from, to) {
        this.from = from;
        this.to = to;
        this.inputFile = inputFile;
        this.outputFile = inputFile.replace(new RegExp(from + "$"), to);
    }
    getArgs() {
        const args = ["-o", this.outputFile, this.inputFile];
        switch ([this.from, this.to].toString()) {
            case ["md", "docx"].toString():
                // enable \newpage \toc
                return args.concat([
                    "--lua-filter="
                        + process.env["HOME"]
                        + "/code/whyreal/dotfiles/pandoc/filter/docx-pagebreak.lua",
                    "--shift-heading-level-by=-1",
                    "--reference-doc="
                        + process.env["HOME"]
                        + "/Documents/pandoc/template.docx"
                ]);
            case ["md", "pdf"].toString():
                // 渲染 mermaid 图形
                //args = args.concat(["-F", "mermaid-filter"])
                // font size
                //args.push('--pdf-engine-opt="--minimum-font-size 14"')
                return args.concat(["--pdf-engine", "wkhtmltopdf"]);
            case ["docx", "md"].toString():
                return args.concat(["--extract-media=."]);
            default:
                return args;
        }
    }
    /**
     * convert
     */
    convert() {
        const convertor = child_process_1.spawn("pandoc", this.getArgs());
        //console.log(convertor.spawnargs);
        convertor.stderr.on("data", (data) => {
            console.log(`${data}`);
        });
        convertor.stdout.on("data", (data) => {
            console.log(`${data}`);
        });
    }
}
module.exports = {
    Pandoc
};
