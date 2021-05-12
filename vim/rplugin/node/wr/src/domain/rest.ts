import {parse, ASTKinds, varRef} from "../peg/httpRequest";

export interface HttpRequest {
    url: string
    proto?: string
    method: string
    headers: [string, string][]
    body?: string
}

export function parseHttpRequest(txt: string) {
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


