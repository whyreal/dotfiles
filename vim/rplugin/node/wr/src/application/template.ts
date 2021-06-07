import {render} from "eta"
import {NvimPlugin} from "neovim"
import {Line} from "../domain/line"
import {appendRange, getVisualLineRange} from "../infra/lineRange"

export function setup(plugin: NvimPlugin) {
    plugin.registerCommand("TplSet", templateSet, {sync: false, range: ''})
    plugin.registerCommand("TplRender", templateRener, {sync: false, range:''})
}

let view: string

async function templateSet() {
    view = (await getVisualLineRange())
        .lines.map(l => l.txt)
        .join("\n")
        .replace(/\$(\d+)/g, "<%= it[$1] %>")
}

async function templateRener() {
    const dr = await getVisualLineRange()

    Promise.all(dr.lines.map((l: Line) => {
        const data = l.txt.split(/\s+/)
        data.unshift(l.txt)
        return render(view, data, {autoTrim: [false, false]})
    }))
    .then(ss => {
        let result = ["", "-----Result-----",""]
        ss.map(s => {
            if (!s) {return }
            result = result.concat(s.split("\n"))
        })
        appendRange(result, dr)
    })
}
