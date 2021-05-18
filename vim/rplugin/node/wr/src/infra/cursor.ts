import {Cursor} from "../domain/cursor";
import {cxt} from "./env";
import {getLine} from "./line";

export async function gotoFirstChar() {
    const api = cxt.api!
    const l = await api.line
    const c = await getCursor()
    const fc = l.search(/[^\s]/)

    if (c[1] == fc || fc < 0) {
        setCursor([c[0], 0])
    } else {
        setCursor([c[0], fc])
    }
}
export async function getPos(mark?: string) {
    const api = cxt.api!

    let cursor: Cursor
    if (mark) {
        cursor = (await api.buffer.mark(mark))
    } else {
        cursor = await api.window.cursor
    }

    cursor[0] = cursor[0] - 1 // ln base 1 to base 0

    const line = await getLine(cursor[0])
    const encoding = await api.getOption("encoding") as BufferEncoding
    charIndex(line.txt, cursor, encoding)

    return cursor
}
export async function setPos(mark: string, cursor: Cursor) {
    const api = cxt.api!

    const line = await getLine(cursor[0])
    byteIndex(line.txt, cursor)

    cursor = [cursor[0] + 1, cursor[1] + 1] // ln and col base 0 to base 1
    if (!(mark === ".")) {
        mark = "'" + mark
    }
    api.callFunction("setpos", [mark, [0, cursor[0], cursor[1], 0]])
}

export const getCursor = getPos
export async function setCursor(cursor: Cursor) {
    const line = await getLine(cursor[0])
    byteIndex(line.txt, cursor)

    cursor[0] = cursor[0] + 1 // ln base 0 to base 1

    const api = cxt.api!
    api.window.cursor = cursor
}

export function charIndex(txt: string, cursor: Cursor, encoding: BufferEncoding) {
    // covert byte index to char index
    cursor[1] = Buffer.from(txt).toString(encoding as BufferEncoding, 0, cursor[1] + 1).length - 1
}
export function byteIndex(txt: string, cursor: Cursor) {
    // covert char index to byte index
    cursor[1] = Buffer.from(txt.substring(0, cursor[1])).length
}
