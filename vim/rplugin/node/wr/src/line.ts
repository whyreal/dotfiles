import { cxt } from "./env";

export type LineNumber = number

export type Line = {
    nr: number
    txt: string
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

