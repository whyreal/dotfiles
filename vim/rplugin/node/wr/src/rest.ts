import {parse, ASTKinds, varRef} from "./peg/httpRequest";
import {cxt} from "./env";
import {sendToTmux} from "./tmux";
import { NvimPlugin } from "neovim";
import {getCursor} from "./cursor";
import {getLines} from "./lineRange";

export function setup(plugin: NvimPlugin) {
    plugin.registerCommand("RestSendRequest", restSendRequest, {sync: false})
}

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

function parseHttpRequest(txt: string) {
    const vars = new Map<string, string>()
    const ast = parse(txt).ast!

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

function getCurlCmd(r: HttpRequest) {
    let cmd = `curl -X ${r.method} '${r.url}' `
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

async function restSendRequest() {
    const lines = await fetchRequestLines()
    const cmd = getCurlCmd(parseHttpRequest(lines.join("\n")))
    sendToTmux(cmd)
}
