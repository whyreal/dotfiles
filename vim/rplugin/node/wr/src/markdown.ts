import {cxt} from "./env";
import {deleteBlankLineScan, LineAction, mdHeaderLevelDownScan, mdHeaderLevelUpScan, mdListCreateScan, mdListDeleteScan, mdOrderListCreateScan} from "./lineScanner";
import { Line } from "./line";
import {getHeaderRange, getVisualLineRange, LineRange} from "./range";

function excuteAction(actions: Map<number, LineAction[]>,
                      lines: Line[]): string[] {

    const x = lines.map(line => {
        let newLine: string[] = []

        if (!actions.has(line.nr)) {
            return [line.txt]
        }
        const cla = actions.get(line.nr)!

        cla.forEach(a => {
            switch (a.name) {
                case "Delete":
                    newLine = []
                    break;
                case "Append":
                    newLine.concat(a.args).unshift(line.txt)
                    break;
                case "Insert":
                    newLine.concat(a.args).push(line.txt)
                    break;
                case "Replace":
                    newLine = a.args
                    break;
                case "LevelDown":
                    newLine = [downLevel(line.txt)];
                break;
                case "LevelUp":
                    newLine = [upLevel(line.txt)];
                    break;
                case "SetLevel":
                    newLine = [setLevel(line.txt, a.args)]
                    break;
                case "ListDelete":
                    newLine = [listDelete(line.txt)]
                    break;
                case "ListCreate":
                    newLine = [listCreate(line.txt)]
                    break;
                case "OrderListCreate":
                    newLine = [orderListCreate(line.txt, a.args)]
                    break;
                default:
                    break;
            }
        })
        return newLine
    })
    const y = x.reduce((acc, cur) => {
        return acc.concat(cur)
    })
    return y
}

function downLevel(line: string): string {
    if (line.startsWith("#")) {
        line = "#" + line
    } else {
        line= "# " + line
    }
    return line
}

function upLevel(line: string): string {
    line = line.replace(/^#\s*/, "")
    return line
}

function setLevel(line: string, level: number): string {
    let prefix = "#".repeat(level)
    if (level > 0) {
        prefix = prefix + " "
    }

    line = line.replace(/^#*\s*/, prefix)
    return line
}

function updateLineRange(lines: string[], lineRange: LineRange) {
    const api = cxt.api!
    api.buffer.setLines(lines,
                        { start: lineRange.start,
                            end: lineRange.end, strictIndexing: false}
                       )
}

function listDelete(txt: string): string {
    return txt.replace(/(\s*)(-|\d+\.)\s*(.*)/, "$1$3")
}

function listCreate(txt: string): string {
    return txt.replace(/(\s*)(.*)/, "$1- $2")
}

function orderListCreate(txt: string, order: number): string {
    return txt.replace(/(\s*)(.*)/, "$1"+ order +". $2")
}
export async function deleteBlankLine() {
    const lineRange = await getVisualLineRange()
    const actions = deleteBlankLineScan(lineRange)
    const lines = excuteAction(actions, lineRange.lines)

    updateLineRange(lines, lineRange)
}

export async function mdHeaderLevelUpRange() {
    const lineRange = await getVisualLineRange()
    const actions = mdHeaderLevelUpScan(lineRange)
    const lines = excuteAction(actions, lineRange.lines)

    updateLineRange(lines, lineRange)
}
export async function mdHeaderLevelDownRange() {
    const lineRange = await getVisualLineRange()
    const actions = mdHeaderLevelDownScan(lineRange)
    const lines = excuteAction(actions, lineRange.lines)

    updateLineRange(lines, lineRange)
}
export async function mdHeaderLevelDown() {
    const lineRange = await getHeaderRange()
    const actions = mdHeaderLevelDownScan(lineRange, true)
    const lines = excuteAction(actions, lineRange.lines)

    updateLineRange(lines, lineRange)
}
export async function mdHeaderLevelUp() {
    const lineRange = await getHeaderRange()
    const actions = mdHeaderLevelUpScan(lineRange)
    const lines = excuteAction(actions, lineRange.lines)

    updateLineRange(lines, lineRange)
}

export async function mdListCreate() {
    const lineRange = await getVisualLineRange()
    const actions = mdListCreateScan(lineRange)
    const lines = excuteAction(actions, lineRange.lines)

    updateLineRange(lines, lineRange)
}
export async function mdListDelete() {
    const lineRange = await getVisualLineRange()
    const actions = mdListDeleteScan(lineRange)
    const lines = excuteAction(actions, lineRange.lines)

    updateLineRange(lines, lineRange)
}
export async function mdOrderListCreate() {
    const lineRange = await getVisualLineRange()
    const actions = mdOrderListCreateScan(lineRange)
    const lines = excuteAction(actions, lineRange.lines)

    updateLineRange(lines, lineRange)
}
