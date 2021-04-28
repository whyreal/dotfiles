import {LineRange} from "./range"

type ReplaceAction = {
    name: "Replace",
    args: string[]
}
type AppendAction = {
    name: "Append",
    args: string[]
}
type InsertAction = {
    name: "Insert",
    args: string[]
}
type OrderListCreateAction = {
    name: "OrderListCreate",
    args: number
}
type SetLevelAction = {
    name: "SetLevel",
    args: number
}
export type LineAction = { name: "Delete" | "LevelUp" | "LevelDown" | "ListCreate" | "ListDelete"} |
    SetLevelAction | OrderListCreateAction |
    ReplaceAction | AppendAction | InsertAction

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

