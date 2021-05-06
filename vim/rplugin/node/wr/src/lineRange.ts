import {getLine, Line} from "./line"
import {cxt} from "./env";

type Cursor = [number, number]

export type LineRange = {
    start: Cursor
    end: Cursor
    cursor: Cursor
    lineCount: number
    lines: Line[]
}
export async function getHeaderRangeAtCursor(): Promise<LineRange> {
    const api = cxt.api!
    const cursor = await api.window.cursor

    const start = [cursor[0] - 1, cursor[1]] as Cursor
    let end = cursor

    if (cursor[0] < await api.buffer.length) {
        const nextLine = await getLine(cursor[0] + 1)
        if (nextLine.txt.startsWith("==") || nextLine.txt.startsWith('--')) {
            end = [cursor[0] + 1, cursor[1]]
        }
    }

    return {
        start: start,
        end: end,
        cursor: cursor,
        lineCount: end[0] - start[0],
        lines: (await api.buffer.getLines({
            start: start[0],
            end: end[0],
            strictIndexing: false
        })).map((txt, index) => {
            return { txt: txt, nr: index + start[0]}
        })
    }
}
export async function getWordRangeAtCursor(): Promise<LineRange> {
    const api = cxt.api!
    const cursor = await api.window.cursor

    const start = [cursor[0] - 1, cursor[1]] as Cursor
    let end = cursor

    if (cursor[0] < await api.buffer.length) {
        const nextLine = await getLine(cursor[0] + 1)
        if (nextLine.txt.startsWith("===") || nextLine.txt.startsWith('---')) {
            end = [cursor[0] + 1, cursor[1]]
        }
    }

    return {
        start: start,
        end: end,
        lineCount: end[0] - start[0],
        cursor: cursor,
        lines: (await api.buffer.getLines({
            start: start[0],
            end: end[0],
            strictIndexing: false
        })).map((txt, index) => {
            return { txt: txt, nr: index + start[0]}
        })
    }
}
export async function getLineAtCursor(): Promise<LineRange> {
    const api = cxt.api!
    const cursor = await api.window.cursor

    const start = [cursor[0] - 1, cursor[1]] as Cursor
    let end = cursor as Cursor

    return {
        start: start,
        end: end,
        lineCount: end[0] - start[0],
        cursor: cursor,
        lines: (await api.buffer.getLines({
            start: start[0],
            end: end[0],
            strictIndexing: false
        })).map((txt, index) => {
            return { txt: txt, nr: index + start[0]}
        })
    }
}
export async function getVisualLineRange(): Promise<LineRange> {
    const api = cxt.api!
    const start = (await api.buffer.mark('<'))
    const end = (await api.buffer.mark('>'))
    const cursor = await api.window.cursor
    return {
        start: [start[0] -1 , start[1]],
        end: end,
        lineCount: end[0] - start[0],
        cursor: cursor,
        lines: (await api.buffer.getLines({
            start: start[0],
            end: end[0],
            strictIndexing: false
        })).map((txt, index) => {
            return { txt: txt, nr: index + start[0]}
        })
    }
}
export function freshRange(lines: string[], lineRange: LineRange) {
    const api = cxt.api!
    api.buffer.setLines(lines,
                        { start: lineRange.start[0],
                            end: lineRange.end[0], strictIndexing: false}
                       )
}

