import {cxt} from "./env";
import {append, deleteLine, downLevel, insert, LineAction, mdListCreate, mdListDelete, mdOrderListCreate, replace, setLevel, upLevel, toggleWordWith} from "./lineAction";
import {LineRange} from "./lineRange";

export async function mdListDeleteScan(r: LineRange) {
    const actions = new Map<number, LineAction[]>()

    r.lines.map(line => {
        if (!line.txt.match(/^\s*$/)) {
            const cla = actions.get(line.nr) || []
            cla.push(mdListDelete)
            actions.set(line.nr, cla)
        }
    });
    return actions
}
export async function mdOrderListCreateScan(r: LineRange) {
    const actions = new Map<number, LineAction[]>()

    let order = 1
    r.lines.forEach(line => {
        if (!line.txt.match(/^\s*$/)) {
            const cla = actions.get(line.nr) || []
            cla.push(mdOrderListCreate(order))
            actions.set(line.nr, cla)
            order++
        }
    });
    return actions
}
export async function mdListCreateScan(r: LineRange) {
    const actions = new Map<number, LineAction[]>()

    r.lines.map(line => {
        if (!line.txt.match(/^\s*$/)) {
            const cla = actions.get(line.nr) || []
            cla.push(mdListCreate)
            actions.set(line.nr, cla)
        }
    });
    return actions
}
export async function mdHeaderLevelUpScan(r: LineRange) {
    const actions = new Map<number, LineAction[]>()

    r.lines.map(line => {
        if (line.txt.startsWith("#")) {
            const cla = actions.get(line.nr) || []
            cla.push(upLevel)
            actions.set(line.nr, cla)
        } else if (line.txt.startsWith("==")) {
            const cla = actions.get(line.nr) || []
            const lla = actions.get(line.nr - 1) || []
            cla.push(deleteLine)
            lla.push(setLevel(0))
            actions.set(line.nr, cla)
            actions.set(line.nr - 1, lla)
        } else if (line.txt.startsWith("--")) {
            const cla = actions.get(line.nr) || []
            const lla = actions.get(line.nr - 1) || []
            cla.push(deleteLine)
            lla.push(setLevel(1))
            actions.set(line.nr, cla)
            actions.set(line.nr - 1, lla)
        }
    });
    return actions
}
export async function deleteBlankLineScan(r: LineRange) {
    const actions = new Map<number, LineAction[]>()

    r.lines.map(line => {
        if (line.txt.trim() == "") {
            const cla = actions.get(line.nr) || []
            cla.push(deleteLine)
            actions.set(line.nr, cla)
        }
    });
    return actions
}
export async function mdHeaderLevelDownScan(level0: boolean, r: LineRange) {
    const actions = new Map<number, LineAction[]>()

    r.lines.map(line => {
        if (line.txt.startsWith("#")) {
            const cla = actions.get(line.nr) || []
            cla.push(downLevel)
            actions.set(line.nr, cla)
        } else if (line.txt.startsWith("==")) {
            const cla = actions.get(line.nr) || []
            const lla = actions.get(line.nr - 1) || []
            cla.push(deleteLine)
            lla.push(setLevel(2))
            actions.set(line.nr, cla)
            actions.set(line.nr - 1, lla)
        } else if (line.txt.startsWith("--")) {
            const cla = actions.get(line.nr) || []
            const lla = actions.get(line.nr - 1) || []
            cla.push(deleteLine)
            lla.push(setLevel(3))
            actions.set(line.nr, cla)
            actions.set(line.nr - 1, lla)
        } else if (level0) {
            const cla = actions.get(line.nr) || []
            cla.push(setLevel(1))
            actions.set(line.nr, cla)
        }
    });

    return actions
}
export async function codeBlockCreateScan(lineRange: LineRange) {
    const actions = new Map<number, LineAction[]>()

    const indent = lineRange.lines[0].txt.match(/^\s*/)
    lineRange.lines.map((line, index) => {
        if (index == 0) {
            const cla = actions.get(line.nr) || []
            cla.push(insert([indent + "```"]))
            actions.set(line.nr, cla)
        }
        if (index == lineRange.length - 1) {
            const cla = actions.get(line.nr) || []
            cla.push(append([indent + "```"]))
            actions.set(line.nr, cla)
        }
    });
    return actions
}
export async function codeBlockCreateFromCodeLineScan(lineRange: LineRange) {
    const actions = new Map<number, LineAction[]>()

    const indent = lineRange.lines[0].txt.match(/^\s*/)
    lineRange.lines.map((line, index) => {
        const cla = actions.get(line.nr) || []
        cla.push(replace(line.txt.replace(/`/g, "")))
        if (index == 0) {
            cla.push(insert([indent + "```"]))
        } else if (index == lineRange.length - 1) {
            cla.push(append([indent + "```"]))
        }
        actions.set(line.nr, cla)
    });
    return actions
}
export async function codeBlockCreateFromTableScan(lineRange: LineRange) {
    const actions = new Map<number, LineAction[]>()

    const indent = lineRange.lines[0].txt.match(/^\s*/)
    lineRange.lines.map((line, index) => {
        const cla = actions.get(line.nr) || []

        if (line.txt.match(/^\s*$/)) {
            cla.push(deleteLine)
        } else {
            cla.push(replace(line.txt.split("|")[2].replace(/`/g, "")))
        }
        if (index == 0) {
            cla.push(insert([indent + "```"]))
        } else if (index == lineRange.length - 1) {
            cla.push(append([indent + "```"]))
        }

        actions.set(line.nr, cla)
    });
    return actions
}
export async function wrapWordWithScan(left: string, right: string, lineRange: LineRange) {
    const actions = new Map<number, LineAction[]>()

    const line = lineRange.lines[0]
    let charRange = {start: 0, stop: 0}
    const cursor = await cxt.api?.window.cursor

    // word
    const wordReg = new RegExp(/(\S+)/, "g")

    for (const i of line.txt.matchAll(wordReg)) {
        if (typeof i.index == "undefined") {
            break
        }
        if (cursor![1] >= i.index && cursor![1] <= i.index + i[0].length) {
            charRange.start = i.index
            charRange.stop = i.index + i[0].length
        }
    }

    lineRange.lines.map(line => {
        const cla = actions.get(line.nr) || []
        cla.push(toggleWordWith(left, right, charRange))
        actions.set(line.nr, cla)
    });
    return actions
}

