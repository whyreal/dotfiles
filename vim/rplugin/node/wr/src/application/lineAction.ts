import {prop, curry, map, assoc} from "ramda";
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
        return (lg.before).concat(lg.cur).concat(lg.after)
    })
    const y = x.reduce((acc, cur) => {
        return acc.concat(cur)
    })
    return y.map(prop("txt"))
}
function lineGroupFromLine(line: Line): LineGroup {
    return {before: [], cur: [line], after: []}
}
function lineFromStr(str: string): Line {
    return {txt: str, ln: -1}
}

export const append = curry((lines: string[], lg: LineGroup): LineGroup => {
    lg.after = map(lineFromStr)(lines).concat(lg.after)
    return lg
})
export const insert = curry((lines: string[], lg: LineGroup): LineGroup => {
    lg.before = lg.before.concat(map(lineFromStr)(lines))
    return lg
})
export const replace = curry((str: string, lg: LineGroup): LineGroup => {
    lg.cur = map(assoc('txt', str))(lg.cur)
    return lg
})
export const deleteLine = assoc('cur', [])

export function downLevel(lg: LineGroup): LineGroup {
    lg.cur = map((l: Line) => {
        if (l.txt.startsWith("#")) {
            l.txt = "#" + l.txt
        } else {
            l.txt = "# " + l.txt
        }
        return l
    })(lg.cur)
    return lg
}

export const upLevel = (lg: LineGroup): LineGroup => {
    lg.cur = map((l: Line) => {
        l.txt = l.txt.replace(/^#\s*/, "")
        return l
    })(lg.cur)
    return lg
    
}
export const setLevel = curry((level: number, lg: LineGroup): LineGroup => {
    lg.cur = map((l: Line) => {
        let prefix = "#".repeat(level)
        if (level > 0) {
            prefix = prefix + " "
        }

        l.txt = l.txt.replace(/^#*\s*/, prefix)
        return l
    })(lg.cur)
    return lg
})
export const mdListDelete = (lg: LineGroup) => {
    lg.cur = map((l: Line) => {
        l.txt = l.txt.replace(/(\s*)(-|\d+\.)\s*(.*)/, "$1$3")
        return l
    })(lg.cur)
    return lg
}
export const mdListCreate = (lg: LineGroup) => {
    lg.cur = map((l: Line) => {
        l.txt = l.txt.replace(/(\s*)(.*)/, "$1- $2")
        return l
    })(lg.cur)
    return lg
}
export const mdOrderListCreate = curry((order: number, lg: LineGroup) => {
    lg.cur = map((l: Line) => {
        l.txt = l.txt.replace(/(\s*)(.*)/, "$1" + order + ". $2")
        return l
    })(lg.cur)
    return lg
})
export const toggleWordWrap = curry((left: string, right: string, charRange: {start: number, stop: number}, lg: LineGroup): LineGroup => {
    lg.cur = map((l: Line) => {
        const word = l.txt.slice(charRange.start, charRange.stop)
        if (word.startsWith(left) && word.endsWith(right)) {
            l.txt = l.txt.slice(0, charRange.start)
            + l.txt.slice(charRange.start + left.length, charRange.stop - right.length)
            + l.txt.slice(charRange.stop, l.txt.length)
        } else {
            l.txt = l.txt.slice(0, charRange.start) + left
            + l.txt.slice(charRange.start, charRange.stop) + right
            + l.txt.slice(charRange.stop, l.txt.length)
        }
        return l
    })(lg.cur)
    return lg
})
export const insertStr = curry((str: string, col: number, lg: LineGroup) => {
    // TODO: test
    lg.cur = map((l: Line) => {
        l.txt = l.txt.slice(0, col) + str
            + l.txt.slice(col, l.txt.length)
        return l
    })(lg.cur)
    return lg
})
export const deleteStr = curry((charRange: [start: number, stop: number], lg: LineGroup) => {
    // TODO: test
    lg.cur = map((l: Line) => {
        l.txt = l.txt.slice(0, charRange[0])
            + l.txt.slice(charRange[1], l.txt.length)
        return l
    })(lg.cur)
    return lg
})
