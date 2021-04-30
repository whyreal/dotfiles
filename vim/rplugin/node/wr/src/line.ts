import { cxt } from "./env";

export type LineNumber = number

export type Line = {
    nr: LineNumber
    txt: string
}

export type LineGroup = {
    cur?: Line
    before?: Line[]
    after?: Line[]
}

export async function currentHeaderLine(): Promise<Line> {
    const api = cxt.api!
    const cursor = await api.window.cursor
    const doc = await api.buffer.lines

    for (let index = cursor[0]; index >= 0; index--) {
        api.outWrite(JSON.stringify([index, doc[index]]) + "\n")

        if (doc[index].startsWith("#")) {
            return {nr: index, txt: doc[index]}
        }
    }
    throw new Error("No header!");
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
