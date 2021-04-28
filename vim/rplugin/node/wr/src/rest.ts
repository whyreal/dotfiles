import {parse, ASTKinds, varRef} from "./peg/httpRequest";
import {cxt} from "./env";
import {sendToTmux} from "./tmux";

function replaceVarAndJoin(c: (string | varRef)[] | undefined, vars: Map<string, string>) : string {
    if (c === undefined) {
        return ""
    }

    return c.map((value) => {
        if (typeof value === "string") {
            return value
        } else if (value.kind === ASTKinds.varRef) {
            return vars.get(value.name.join(""))
        }
    }).join("")
}

interface HttpRequest {
    url: string
    proto?: string
    method: string
    headers: [string, string][]
    body?: string
}

export function parseHttpRequest(txt: string) {
    const vars = new Map<string, string>()
    const ast = parse(txt).ast

    // proto 不能省略
    const req: HttpRequest = {url: "", method: "GET", headers:[]}

    ast?.vars.forEach((l) => {
        if (l.kind == ASTKinds.varLine) {
            const name = l.name.join("")
            const value = replaceVarAndJoin(l.value, vars)
            vars.set(name, value)
        }
    })

    req.method = ast?.req.method!
    req.url = replaceVarAndJoin(ast?.req.url, vars)
    if (ast?.req.proto) {
        req.proto = replaceVarAndJoin(ast?.req.proto, vars)
    }

    ast?.headers.forEach((h) => {
        const name = h.name.join("")
        const value = replaceVarAndJoin(h.value, vars)
        req.headers.push([name, value])
    })

    req.body = ast?.body.map((l) => {return l.value}).join("\n")
    return req
}

async function fetchRequestLines() {
    const api = cxt.api!
    const reqLines: string[] = []
    const lines = await api.buffer.lines
    const c = await api.window.cursor

    for (let index = 0; index <= lines.length - 1; index++) {
        if (lines[index].startsWith("###")) {
            break
        }
        reqLines.push(lines[index])
    }

    let start = c[0] - 1
    let stop:number = 0
    for (let index = start; index >= 0; index--) {
        if (lines[index].startsWith("###")) {
            start = index + 1
        }
    }

    for (let index = c[0]; index <= lines.length - 1; index++) {
        if (lines[index].startsWith("###")) {
            stop = index
        }
    }
    if (stop == 0) {
        stop = lines.length
    }

    return reqLines.concat(await api.buffer.getLines({start: start, end: stop, strictIndexing: false}))
}

export function getCurlCmd(r: HttpRequest) {
    let cmd = `curl -X ${r.method} ${r.url} `
    if (r.headers.length > 0) {
        cmd += r.headers.map((h) => {
            return `-H '${h[0]}: ${h[1]}' `
        }).join(" ")
    }
    if (r.body) {
        cmd += `-d '${r.body}'`
    }
    return cmd
}

export async function restSendRequest() {
    const lines = await fetchRequestLines()
    const cmd = getCurlCmd(parseHttpRequest(lines.join("\n")))
    sendToTmux(cmd)
}
