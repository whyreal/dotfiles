import {getLines} from "../infra/lineRange";
import {Line} from "../domain/line";
import {getCursor} from "./cursor";
import { cxt } from "./env";

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
export async function fetchRequestLines() {
    const api = cxt.api!
    const reqLines: string[] = []
    const lines = await api.buffer.lines

    for (let index = 0; index <= lines.length - 1; index++) {
        if (lines[index].startsWith("###")) {
            break
        }
        reqLines.push(lines[index])
    }

    let start = await getCursor()
    for (let index = start[0]; index >= 0; index--) {
        if (lines[index].startsWith("###")) {
            start[0] = index + 1
            break
        }
    }

    let end = await getCursor()
    for (let index = end[0]; index < lines.length; index++) {
        if (lines[index].startsWith("###")) {
            end[0] = index - 1
            break
        } else if (index === lines.length - 1) {
            end[0] = index
            break
        }
    }

    return reqLines.concat(await getLines(start, end))
}
