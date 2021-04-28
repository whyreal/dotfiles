import {LineAction} from "./action";
import { cxt } from "./env";

export type LineNumber = number

export type Line = {
    nr: number
    txt: string
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
            cla.push({name: "ListDelete"})
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
            cla.push({name: "OrderListCreate", args: order})
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
            cla.push({name: "ListCreate"})
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
            cla.push({name: "LevelUp"})
            actions.set(line.nr, cla)
        } else if (line.txt.startsWith("===")) {
            const cla = actions.get(line.nr) || []
            const lla = actions.get(line.nr - 1) || []
            cla.push({name: "Delete"})
            lla.push({name: "SetLevel", args: 0})
            actions.set(line.nr, cla)
            actions.set(line.nr - 1, lla)
        } else if (line.txt.startsWith("---")) {
            const cla = actions.get(line.nr) || []
            const lla = actions.get(line.nr - 1) || []
            cla.push({name: "Delete"})
            lla.push({name: "SetLevel", args: 1})
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
            cla.push({name: "Delete"})
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
            cla.push({name: "LevelDown"})
            actions.set(line.nr, cla)
        } else if (line.txt.startsWith("===")) {
            const cla = actions.get(line.nr) || []
            const lla = actions.get(line.nr - 1) || []
            cla.push({name: "Delete"})
            lla.push({name: "SetLevel", args: 2})
            actions.set(line.nr, cla)
            actions.set(line.nr - 1, lla)
        } else if (line.txt.startsWith("---")) {
            const cla = actions.get(line.nr) || []
            const lla = actions.get(line.nr - 1) || []
            cla.push({name: "Delete"})
            lla.push({name: "SetLevel", args: 3})
            actions.set(line.nr, cla)
            actions.set(line.nr - 1, lla)
        } else if (level0) {
            const cla = actions.get(line.nr) || []
            cla.push({name: "SetLevel", args: 1})
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
            cla.push({name: "Insert", args: [indent + "```"]})
            actions.set(line.nr, cla)
        } else if (index == lineRange.length - 1) {
            const cla = actions.get(line.nr) || []
            cla.push({name: "Append", args: [indent + "```"]})
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
        cla.push({name: "Replace", args: line.txt.replace(/`/g, "")})
        if (index == 0) {
            cla.push({name: "Insert", args: [indent + "```"]})
        } else if (index == lineRange.length - 1) {
            cla.push({name: "Append", args: [indent + "```"]})
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
            cla.push({name: "Delete"})
        } else {
            cla.push({name: "Replace", args: line.txt.split("|")[2].replace(/`/g, "")})
        }
        if (index == 0) {
            cla.push({name: "Insert", args: [indent + "```"]})
        } else if (index == lineRange.length - 1) {
            cla.push({name: "Append", args: [indent + "```"]})
        }
        actions.set(line.nr, cla)
        cxt.api?.outWrite(JSON.stringify(actions.get(line.nr)) + "\n")
    });
    return actions
}

