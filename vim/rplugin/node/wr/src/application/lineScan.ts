import {Range} from "../domain/range";
import {append, deleteLine, downLevel, insert, LineAction, mdListCreate, mdListDelete, mdOrderListCreate, replace, setLevel, upLevel, toggleWordWrap} from "./lineAction";

export type RangeScanner = (a: Range) => Map<number, LineAction[]>

export function mdListDeleteScan(r: Range) {
    const actions = new Map<number, LineAction[]>()

    r.lines.map(line => {
        if (!line.txt.match(/^\s*$/)) {
            const cla = actions.get(line.ln) || []
            cla.push(mdListDelete)
            actions.set(line.ln, cla)
        }
    });
    return actions
}
export function mdOrderListCreateScan(r: Range) {
    const actions = new Map<number, LineAction[]>()

    let order = 1
    r.lines.forEach(line => {
        if (!line.txt.match(/^\s*$/)) {
            const cla = actions.get(line.ln) || []
            cla.push(mdOrderListCreate(order))
            actions.set(line.ln, cla)
            order++
        }
    });
    return actions
}
export function mdListCreateScan(r: Range) {
    const actions = new Map<number, LineAction[]>()

    r.lines.map(line => {
        if (!line.txt.match(/^\s*$/)) {
            const cla = actions.get(line.ln) || []
            cla.push(mdListCreate)
            actions.set(line.ln, cla)
        }
    });
    return actions
}
export function mdHeaderLevelUpScan(r: Range) {
    const actions = new Map<number, LineAction[]>()

    r.lines.map(line => {
        if (line.txt.startsWith("#")) {
            const cla = actions.get(line.ln) || []
            cla.push(upLevel)
            actions.set(line.ln, cla)
        } else if (line.txt.startsWith("==")) {
            const cla = actions.get(line.ln) || []
            const lla = actions.get(line.ln - 1) || []
            cla.push(deleteLine)
            lla.push(setLevel(0))
            actions.set(line.ln, cla)
            actions.set(line.ln - 1, lla)
        } else if (line.txt.startsWith("--")) {
            const cla = actions.get(line.ln) || []
            const lla = actions.get(line.ln - 1) || []
            cla.push(deleteLine)
            lla.push(setLevel(1))
            actions.set(line.ln, cla)
            actions.set(line.ln - 1, lla)
        }
    });
    return actions
}
export function deleteBlankLineScan(r: Range) {
    const actions = new Map<number, LineAction[]>()

    r.lines.map(line => {
        if (line.txt.trim() == "") {
            const cla = actions.get(line.ln) || []
            cla.push(deleteLine)
            actions.set(line.ln, cla)
        }
    });
    return actions
}
export function mdHeaderLevelDownScan(level0: boolean, r: Range) {
    const actions = new Map<number, LineAction[]>()

    r.lines.map(line => {
        if (line.txt.startsWith("#")) {
            const cla = actions.get(line.ln) || []
            cla.push(downLevel)
            actions.set(line.ln, cla)
        } else if (line.txt.startsWith("==")) {
            const cla = actions.get(line.ln) || []
            const lla = actions.get(line.ln - 1) || []
            cla.push(deleteLine)
            lla.push(setLevel(2))
            actions.set(line.ln, cla)
            actions.set(line.ln - 1, lla)
        } else if (line.txt.startsWith("--")) {
            const cla = actions.get(line.ln) || []
            const lla = actions.get(line.ln - 1) || []
            cla.push(deleteLine)
            lla.push(setLevel(3))
            actions.set(line.ln, cla)
            actions.set(line.ln - 1, lla)
        } else if (level0) {
            const cla = actions.get(line.ln) || []
            cla.push(setLevel(1))
            actions.set(line.ln, cla)
        }
    });

    return actions
}
export function codeBlockCreateScan(lineRange: Range) {
    const actions = new Map<number, LineAction[]>()

    const indent = lineRange.lines[0].txt.match(/^\s*/)
    lineRange.lines.map((line, index) => {
        if (index == 0) {
            const cla = actions.get(line.ln) || []
            cla.push(insert([indent + "```"]))
            actions.set(line.ln, cla)
        }
        if (index == lineRange.lineCount - 1) {
            const cla = actions.get(line.ln) || []
            cla.push(append([indent + "```"]))
            actions.set(line.ln, cla)
        }
    });
    return actions
}
export function codeBlockCreateFromCodeLineScan(lineRange: Range) {
    const actions = new Map<number, LineAction[]>()

    const indent = lineRange.lines[0].txt.match(/^\s*/)
    lineRange.lines.map((line, index) => {
        const cla = actions.get(line.ln) || []
        cla.push(replace(line.txt.replace(/`/g, "")))
        if (index == 0) {
            cla.push(insert([indent + "```"]))
        } else if (index == lineRange.lineCount - 1) {
            cla.push(append([indent + "```"]))
        }
        actions.set(line.ln, cla)
    });
    return actions
}
export function codeBlockCreateFromTableScan(lineRange: Range) {
    const actions = new Map<number, LineAction[]>()

    const indent = lineRange.lines[0].txt.match(/^\s*/)
    lineRange.lines.map((line, index) => {
        const cla = actions.get(line.ln) || []

        if (line.txt.match(/^\s*$/)) {
            cla.push(deleteLine)
        } else {
            cla.push(replace(line.txt.split("|")[2].replace(/`/g, "")))
        }
        if (index == 0) {
            cla.push(insert([indent + "```"]))
        } else if (index == lineRange.lineCount - 1) {
            cla.push(append([indent + "```"]))
        }

        actions.set(line.ln, cla)
    });
    return actions
}
export function toggleWordWrapScan(left: string, right: string, lineRange: Range) {
    const actions = new Map<number, LineAction[]>()

    const line = lineRange.lines[0]
    let charRange = {start: 0, stop: 0}
    const cursor = lineRange.cursor

    // word
    const wordReg = new RegExp(/(\S+)/, "g")

    for (const i of line.txt.matchAll(wordReg)) {
        if (typeof i.index == "undefined") {
            break
        }

        if (cursor[1] < i.index) {
            break
        }

        charRange.start = i.index
        charRange.stop = i.index + i[0].length
    }

    lineRange.lines.map(line => {
        const cla = actions.get(line.ln) || []
        cla.push(toggleWordWrap(left, right, charRange))
        actions.set(line.ln, cla)
    });
    return actions
}
export function toggleRangeWrapScan(left: string, right: string, lineRange: Range) {
    const actions = new Map<number, LineAction[]>()

    const fla = actions.get(lineRange.start[0]) || []
    const lla = actions.get(lineRange.end[0]) || []

    const fl = lineRange.lines[0]
    const ll = lineRange.lines.slice(-1)[0]

    //All
    if (fl.txt.substring(lineRange.start[1], lineRange.start[1] + left.length) === left &&
        ll.txt.substring(lineRange.end[1] - right.length + 1, lineRange.end[1] + 1) === right ) {
        
        if (fl.ln === ll.ln) {
            lla.push(replace(
                ll.txt.substring(0, lineRange.start[1]) +
                ll.txt.substring(lineRange.start[1] + left.length, lineRange.end[1] - right.length + 1) +
                ll.txt.substring(lineRange.end[1] + 1, fl.txt.length)
            ))
        } else {
            fla.push(replace(
                fl.txt.substring(0, lineRange.start[1]) +
                fl.txt.substring(lineRange.start[1] + left.length, fl.txt.length)
            ))
            lla.push(replace(
                ll.txt.substring(0, lineRange.end[1] - right.length + 1) +
                ll.txt.substring(lineRange.end[1] + 1, ll.txt.length)
            ))
        }
    } //Inner
    else if (fl.txt.substring(lineRange.start[1] - left.length, lineRange.start[1]) === left &&
        ll.txt.substring(lineRange.end[1] + 1, lineRange.end[1] + right.length + 1) === right ) {
        
        if (fl.ln === ll.ln) {
            lla.push(replace(
                ll.txt.substring(0, lineRange.start[1] - left.length) +
                ll.txt.substring(lineRange.start[1], lineRange.end[1] + 1) + 
                ll.txt.substring(lineRange.end[1] + right.length + 1, fl.txt.length)
            ))
        } else {
            fla.push(replace(
                fl.txt.substring(0, lineRange.start[1] - left.length) +
                fl.txt.substring(lineRange.start[1], fl.txt.length)
            ))
            lla.push(replace(
                ll.txt.substring(0, lineRange.end[1] + 1) +
                ll.txt.substring(lineRange.end[1] + right.length + 1, ll.txt.length)
            ))
        }
    } // None
    else {
        if (fl.ln === ll.ln) {
            lla.push(replace(
                ll.txt.substring(0, lineRange.start[1]) + left +
                ll.txt.substring(lineRange.start[1], lineRange.end[1] + 1) + right +
                ll.txt.substring(lineRange.end[1] + 1, ll.txt.length)
            ))
        } else {
            fla.push(replace(
                fl.txt.substring(0, lineRange.start[1]) + left +
                fl.txt.substring(lineRange.start[1], fl.txt.length)
            ))
            lla.push(replace(
                ll.txt.substring(0, lineRange.end[1] + 1) + right +
                ll.txt.substring(lineRange.end[1] + 1, ll.txt.length)
            ))
        }
    }

    actions.set(lineRange.start[0], fla)
    actions.set(lineRange.end[0], lla)

    return actions
}
