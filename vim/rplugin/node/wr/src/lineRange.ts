import {getLine, Line, LineNumber} from "./line"
import { cxt } from "./env";

export type LineRange = {
    start: LineNumber
    end: LineNumber
    length: number
    lines: Line[]
}
export async function getHeaderRangeAtCursor(): Promise<LineRange> {
    const api = cxt.api!
    const cursor = await api.window.cursor

    const start = cursor[0] - 1
    let end = cursor[0]

    if (cursor[0] < await api.buffer.length) {
        const nextLine = await getLine(cursor[0] + 1)
        if (nextLine.txt.startsWith("===") || nextLine.txt.startsWith('---')) {
            end = cursor[0] + 1
        }
    }

    return {
        start: start,
        end: end,
        length: end - start,
        lines: (await api.buffer.getLines({
            start: start,
            end: end,
            strictIndexing: false
        })).map((txt, index) => {
            return { txt: txt, nr: index + start}
        })
    }
}
export async function getWordRangeAtCursor(): Promise<LineRange> {
    const api = cxt.api!
    const cursor = await api.window.cursor

    const start = cursor[0] - 1
    let end = cursor[0]

    if (cursor[0] < await api.buffer.length) {
        const nextLine = await getLine(cursor[0] + 1)
        if (nextLine.txt.startsWith("===") || nextLine.txt.startsWith('---')) {
            end = cursor[0] + 1
        }
    }

    return {
        start: start,
        end: end,
        length: end - start,
        lines: (await api.buffer.getLines({
            start: start,
            end: end,
            strictIndexing: false
        })).map((txt, index) => {
            return { txt: txt, nr: index + start}
        })
    }
}
export async function getLineAtCursor() {
    const api = cxt.api!
    const cursor = await api.window.cursor

    const start = cursor[0] - 1
    let end = cursor[0]

    return {
        start: start,
        end: end,
        length: end - start,
        lines: (await api.buffer.getLines({
            start: start,
            end: end,
            strictIndexing: false
        })).map((txt, index) => {
            return { txt: txt, nr: index + start}
        })
    }
}
export async function getVisualLineRange(): Promise<LineRange> {
    const api = cxt.api!
    const start = (await api.buffer.mark('<'))[0] - 1
    const end = (await api.buffer.mark('>'))[0]
    return {
        start: start,
        end: end,
        length: end - start,
        lines: (await api.buffer.getLines({
            start: start,
            end: end,
            strictIndexing: false
        })).map((txt, index) => {
            return { txt: txt, nr: index + start}
        })
    }
}
export function freshRange(lines: string[], lineRange: LineRange) {
    const api = cxt.api!
    api.buffer.setLines(lines,
                        { start: lineRange.start,
                            end: lineRange.end, strictIndexing: false}
                       )
}

