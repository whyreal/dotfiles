import {prop, curry} from "ramda";
import {Line, LineGroup} from "../domain/line";
import {Range} from "../domain/range";

export type LineAction = (a: LineGroup) => LineGroup

export function excuteAction(actions: Map<number, LineAction[]>, lr: Range): string[] {
    const x = lr.lines.map(line => {
        let lg = lineGroupFromLine(line)

        if (actions.has(line.ln)) {
            actions.get(line.ln)?.forEach((action) => {
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
function lineGroupFromLine(line: Line): LineGroup {
    return {cur: line}
}
function lineListFromStringList(lines: string[]): Line[] {
    return lines.map((str) => {
        return {txt: str, ln: -1}
    })
}

export const append = curry((lines: string[], lg: LineGroup): LineGroup => {
    lg.after = lineListFromStringList(lines).concat(lg.after || [])
    return lg
})
export const insert = curry((lines: string[], lg: LineGroup): LineGroup => {
    lg.before = (lg.before || []).concat(lineListFromStringList(lines))
    return lg
})
export const replace = curry((str: string, lg: LineGroup): LineGroup => {
    if (lg.cur) {
        lg.cur.txt = str
    }
    return lg
})
export function deleteLine(lg: LineGroup): LineGroup {
    if (lg.cur) {
        delete lg.cur
    }
    return lg
}
export function downLevel(lg: LineGroup): LineGroup {
    if (lg.cur) {
        if (lg.cur.txt.startsWith("#")) {
            lg.cur.txt = "#" + lg.cur.txt
        } else {
            lg.cur.txt = "# " + lg.cur.txt
        }
    }
    return lg
}

export const upLevel = (lg: LineGroup): LineGroup => {
    if (lg.cur) {
        lg.cur.txt = lg.cur.txt.replace(/^#\s*/, "")
    }
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
export const mdListDelete = (lg: LineGroup) => {
    if (lg.cur) {
        lg.cur.txt = lg.cur.txt.replace(/(\s*)(-|\d+\.)\s*(.*)/, "$1$3")
    }
    return lg
}
export const mdListCreate = (lg: LineGroup) => {
    if (lg.cur) {
        lg.cur.txt = lg.cur.txt.replace(/(\s*)(.*)/, "$1- $2")
    }
    return lg
}
export const mdOrderListCreate = curry((order: number, lg: LineGroup) => {
    if (lg.cur) {
        lg.cur.txt = lg.cur.txt.replace(/(\s*)(.*)/, "$1" + order + ". $2")
    }
    return lg
})
export const toggleWordWrap = curry((left: string, right: string, charRange: {start: number, stop: number}, lg: LineGroup): LineGroup => {
    if (!lg.cur) {return lg}

    const txt = lg.cur.txt
    const word = txt.slice(charRange.start, charRange.stop)
    if (word.startsWith(left) && word.endsWith(right)) {
        lg.cur.txt = txt.slice(0, charRange.start)
            + txt.slice(charRange.start + left.length, charRange.stop - right.length)
            + txt.slice(charRange.stop, txt.length)
    } else {
        lg.cur.txt = txt.slice(0, charRange.start) + left
            + txt.slice(charRange.start, charRange.stop) + right
            + txt.slice(charRange.stop, txt.length)
    }
    return lg
})
export const insertStr = curry((str: string, col: number, lg: LineGroup) => {
    // TODO: test
    if (lg.cur) {
        const txt = lg.cur.txt
        lg.cur.txt = txt.slice(0, col) + str
            + txt.slice(col, txt.length)
    }
    return lg
})
export const deleteStr = curry((charRange: [start: number, stop: number], lg: LineGroup) => {
    // TODO: test
    if (lg.cur) {
        const txt = lg.cur.txt
        lg.cur.txt = txt.slice(0, charRange[0])
            + txt.slice(charRange[1], txt.length)
    }
    return lg
})
