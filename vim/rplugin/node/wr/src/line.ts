import {getCursor} from "./cursor";
import { cxt } from "./env";

export type LineNumber = number

export type Line = {
    ln: LineNumber
    txt: string
}

export type LineGroup = {
    cur?: Line
    before?: Line[]
    after?: Line[]
}

export async function currentHeaderLine(): Promise<Line> {
    const api = cxt.api!
    const cursor = await getCursor()
    const doc = await api.buffer.lines

    for (let index = cursor[0]; index >= 0; index--) {
        api.outWrite(JSON.stringify([index, doc[index]]) + "\n")

        if (doc[index].startsWith("#")) {
            return {ln: index, txt: doc[index]}
        }
    }
    throw new Error("No header!");
}

export async function getLine(): Promise<Line>
export async function getLine(nr: number): Promise<Line>
export async function getLine(nr?: number): Promise<Line> {
    const api = cxt.api!
    if (typeof nr === "number") {
        return {
            txt: (await api.buffer.getLines(
                {start: nr, end: nr + 1, strictIndexing: false}))[0],
            ln: nr
        }
    } else {
        return {
            txt: (await api.getLine())!,
            ln: (await getCursor())![0]
        }
    }
}
