import {append, deleteLine, downLevel, insert, LineAction, listCreate, listDelete, orderListCreate, replace, setLevel, upLevel} from "./lineAction";
import { cxt } from "./env";

export type LineNumber = number

export type Line = {
    nr: LineNumber
    txt: string
}

export type LineGroup = {
    cur?: Line
    before?: Line[]
    after?: Line[]
}

export async function getLine(): Promise<Line>
export async function getLine(nr: number): Promise<Line>
export async function getLine(nr?: number): Promise<Line> {
    const api = cxt.api!
    if (nr) {
        return {
            txt: (await api.buffer.getLines(
                {start: nr - 1, end: nr, strictIndexing: false}))[0],
            nr: nr
        }
    } else {
        return {
            txt: (await api.getLine())!,
            nr: (await api.window.cursor)![0]
        }
    }
}

import {LineRange} from "./range"

export function mdListDeleteScan(r: LineRange) {
    const actions = new Map<number, LineAction[]>()

    r.lines.map(line => {
        if (!line.txt.match(/^\s*$/)) {
            const cla = actions.get(line.nr) || []
            cla.push(listDelete)
            actions.set(line.nr, cla)
        }
    });
    return actions
}
export function mdOrderListCreateScan(r: LineRange) {
    const actions = new Map<number, LineAction[]>()

    let order = 1
    r.lines.forEach(line => {
        if (!line.txt.match(/^\s*$/)) {
            const cla = actions.get(line.nr) || []
            cla.push(orderListCreate(order))
            actions.set(line.nr, cla)
            order++
        }
    });
    return actions
}
export function mdListCreateScan(r: LineRange) {
    const actions = new Map<number, LineAction[]>()

    r.lines.map(line => {
        if (!line.txt.match(/^\s*$/)) {
            const cla = actions.get(line.nr) || []
            cla.push(listCreate)
            actions.set(line.nr, cla)
        }
    });
    return actions
}
export function mdHeaderLevelUpScan(r: LineRange) {
    const actions = new Map<number, LineAction[]>()

    r.lines.map(line => {
        if (line.txt.startsWith("#")) {
            const cla = actions.get(line.nr) || []
            cla.push(upLevel)
            actions.set(line.nr, cla)
        } else if (line.txt.startsWith("===")) {
            const cla = actions.get(line.nr) || []
            const lla = actions.get(line.nr - 1) || []
            cla.push(deleteLine)
            lla.push(setLevel(0))
            actions.set(line.nr, cla)
            actions.set(line.nr - 1, lla)
        } else if (line.txt.startsWith("---")) {
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
export function deleteBlankLineScan(r: LineRange) {
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
export function mdHeaderLevelDownScan(r: LineRange, level0: boolean): Map<number, LineAction[]>
export function mdHeaderLevelDownScan(r: LineRange): Map<number, LineAction[]>
export function mdHeaderLevelDownScan(r: LineRange, level0?: boolean): Map<number, LineAction[]> {
    const actions = new Map<number, LineAction[]>()

    r.lines.map(line => {
        if (line.txt.startsWith("#")) {
            const cla = actions.get(line.nr) || []
            cla.push(downLevel)
            actions.set(line.nr, cla)
        } else if (line.txt.startsWith("===")) {
            const cla = actions.get(line.nr) || []
            const lla = actions.get(line.nr - 1) || []
            cla.push(deleteLine)
            lla.push(setLevel(2))
            actions.set(line.nr, cla)
            actions.set(line.nr - 1, lla)
        } else if (line.txt.startsWith("---")) {
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
export function codeBlockCreateScan(lineRange: LineRange) {
    const actions = new Map<number, LineAction[]>()

    const indent = lineRange.lines[0].txt.match(/^\s*/)
    lineRange.lines.map((line, index) => {
        if (index == 0) {
            const cla = actions.get(line.nr) || []
            cla.push(insert([indent + "```"]))
            actions.set(line.nr, cla)
        } else if (index == lineRange.length - 1) {
            const cla = actions.get(line.nr) || []
            cla.push(append([indent + "```"]))
            actions.set(line.nr, cla)
        }
    });
    return actions
}
export function codeBlockCreateFromCodeLineScan(lineRange: LineRange) {
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
        cxt.api?.outWrite(JSON.stringify(actions.get(line.nr)) + "\n")
    });
    return actions
}
export function codeBlockCreateFromTableScan(lineRange: LineRange) {
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
        cxt.api?.outWrite(JSON.stringify(actions.get(line.nr)) + "\n")
    });
    return actions
}

