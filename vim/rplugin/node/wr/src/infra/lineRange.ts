import {getLine} from "./line"
import {cxt} from "./env";
import {getCursor, getPos} from "./cursor";
import {Range} from "../domain/range";
import {Cursor} from "../domain/cursor";

export function freshRange(lines: string[], lineRange: Range) {
    const api = cxt.api!
    api.buffer.setLines(lines,
                        { start: lineRange.start[0],
                            end: lineRange.end[0] + 1, strictIndexing: false}
    )
}
export function appendRange(lines: string[], lineRange: Range) {
    const api = cxt.api!
    api.buffer.setLines(lines,
                        { start: lineRange.end[0] + 1,
                            end: lineRange.end[0] + 1, strictIndexing: false}
    )
}
export async function newLineRange(start: Cursor, end: Cursor, c?: Cursor): Promise<Range> {
    const api = cxt.api!
    const cursor = c || await getCursor()
    const encoding = await api.getOption("encoding") as BufferEncoding
    const lines = (await api.buffer.getLines({
        start: start[0],
        end: end[0] + 1,
        strictIndexing: false
    })).map((txt, index) => {
        const ln = index + start[0]
        return {txt: txt, ln: ln}
    })

    return {
        start: start,
        end: end,
        cursor: cursor,
        encoding: encoding,
        lineCount: end[0] - start[0] + 1,
        lines: lines
    }
}
export async function getHeaderRangeAtCursor(): Promise<Range> {
    const api = cxt.api!
    const cursor = await getCursor()

    const start = cursor
    let end = cursor

    if (cursor[0] < await api.buffer.length) {
        const nextLine = await getLine(cursor[0])
        if (nextLine.txt.startsWith("==") || nextLine.txt.startsWith('--')) {
            end = [cursor[0], cursor[1]]
        }
    }

    return newLineRange(start, end, cursor)
}
export async function getWordRangeAtCursor(): Promise<Range> {
    const api = cxt.api!
    const cursor = await api.window.cursor

    const start = cursor
    let end = cursor

    if (cursor[0] < await api.buffer.length) {
        const nextLine = await getLine(cursor[0] + 1)
        if (nextLine.txt.startsWith("===") || nextLine.txt.startsWith('---')) {
            end = [cursor[0] + 1, cursor[1]]
        }
    }

    return newLineRange(start, end, cursor)
}
export async function getLineAtCursor(): Promise<Range> {
    const cursor = await getCursor()

    return newLineRange(cursor, cursor, cursor)
}
export async function getVisualLineRange(): Promise<Range> {
    const start = await getPos('<')
    const end = await getPos('>')
    return newLineRange(start, end)
}

export type WrapType = "Inner" | "All"

export async function getWrapRange(type: WrapType, left: string, right: string) {
    const api = cxt.api!
    const lines = await api.buffer.lines
    const cursor = await getCursor()

    let start: Cursor | null = null
    let end: Cursor | null = null

    left = left
    right = right
    const r = new RegExp(`(${escapeRegExp(left)}|${escapeRegExp(right)})`, 'g')

    let stack = 1
    for (let index = cursor[0]; index >= 0; index--) {
        for (const s of [...lines[index].matchAll(r)].reverse()) {

            if (index === cursor[0] && s.index! > cursor[1]) {
                continue
            }
            if (s[1] === left) {
                stack -= 1
            } else if (s[1] === right) {
                stack += 1
            }
            if (stack === 0) {
                if (type === "Inner") {
                    start = [index, s.index! + left.length]
                } else if (type === "All") {
                    start = [index, s.index!]
                }
                break
            }
        }
        if (start) {break}
    }

    stack = 1
    for (let index = cursor[0]; index < lines.length; index++) {
        for (const s of lines[index].matchAll(r)) {
            if (index === cursor[0] && s.index! < cursor[1]) {
                continue
            }
            if (s[1] === right) {
                stack -= 1
            } else if (s[1] === left) {
                stack += 1
            }
            if (stack === 0) {
                if (type === "Inner") {
                    if (s.index! === 0) {
                        end = [index - 1, lines[index - 1].length]
                    } else {
                        end = [index, s.index! - 1]
                    }
                } else if (type === "All") {
                    end = [index, s.index! + right.length - 1]
                }
                break
            }
        }
        if (end) {break}
    }

    if (start && end) {
        return newLineRange(start, end)
    }
}

function escapeRegExp(s: string) {
    return s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'); // $& means the whole matched string
}

export async function getLines(start: Cursor, end: Cursor) {
    const api = cxt.api!
    return await api.buffer.getLines({
        start: start[0],
        end: end[0] + 1,
        strictIndexing: false
    })
}
