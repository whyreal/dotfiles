import {prop, curry} from "ramda";
import {cxt} from "./env";
import {Line, LineGroup} from "./line";

export type LineAction = (a: LineGroup) => LineGroup

export function downLevel(lg: LineGroup): LineGroup {
    cxt.api!.outWrite(JSON.stringify(lg) + "downLevel()\n")
    if (lg.cur) {
        if (lg.cur.txt.startsWith("#")) {
            lg.cur.txt = "#" + lg.cur.txt
        } else {
            lg.cur.txt = "# " + lg.cur.txt
        }
    }
    return lg
}
export function deleteLine(lg: LineGroup): LineGroup {
    if (lg.cur) {
        delete lg.cur
    }
    return lg
}
export const append = curry((lines: string[], lg: LineGroup): LineGroup => {
    lg.after = lineListFromStringList(lines).concat(lg.after || [])
    return lg
})
export const insert = curry((lines:string[], lg:LineGroup): LineGroup => {
    lg.before = (lg.before || []).concat(lineListFromStringList(lines))
    return lg
})
export const replace = curry((str: string, lg: LineGroup): LineGroup => {
    if (lg.cur) {
        lg.cur.txt = str
    }
    return lg
})
export const upLevel = (lg: LineGroup): LineGroup => {
    if (lg.cur) {
        lg.cur.txt = lg.cur.txt.replace(/^#\s*/, "")
    }
    cxt.api!.outWrite(JSON.stringify(lg) + "upLevel()\n")
    return lg
}
export const setLevel = curry((level: number, lg: LineGroup): LineGroup => {
    if (lg.cur) {
        let prefix = "#".repeat(level)
        if (level > 0) {
            prefix = prefix + " "
        }

        lg.cur.txt = lg.cur.txt.replace(/^#*\s*/, prefix)
    }
    return lg
})
export const listDelete = (lg: LineGroup) => {
    if (lg.cur) {
        lg.cur.txt = lg.cur.txt.replace(/(\s*)(-|\d+\.)\s*(.*)/, "$1$3")
    }
    return lg
}
export function listCreate(lg: LineGroup) {
    if (lg.cur) {
        lg.cur.txt = lg.cur.txt.replace(/(\s*)(.*)/, "$1- $2")
    }
    return lg
}
export const orderListCreate = curry((order: number, lg: LineGroup) => {
    if (lg.cur) {
        lg.cur.txt = lg.cur.txt.replace(/(\s*)(.*)/, "$1" + order + ". $2")
    }
    return lg
})

function lineGroupFromLine(line: Line): LineGroup{
    return {cur: line}
}

export function excuteAction(actions: Map<number, LineAction[]>,
                      lines: Line[]): string[] {

    const x = lines.map(line => {
        let lg = lineGroupFromLine(line)

        if (actions.has(line.nr)) {
            actions.get(line.nr)?.forEach((action) => {
                lg = action(lg)
            })
        }
        return (lg.before || []).concat(lg.cur && [lg.cur] || []).concat(lg.after || [])
    })
    const y = x.reduce((acc, cur) => {
        return acc.concat(cur)
    })
    return y.map(prop("txt"))
}

function lineListFromStringList(lines: string[]): Line[] {
    return lines.map((str) => {
        return {txt: str, nr: -1}
    })
}
