import {cxt} from "./env";
import {fileURLToPath, URL} from "url";
import { lookup } from "mime-types";
import * as path from "path";
import {spawnSync} from "child_process";
import {Line} from "./line";
import {currentHeaderLine} from "./range";
import { decode } from "urlencode";


async function detectUrl(): Promise<string> {
    const api = cxt.api!
    const line = await api.getLine()
    const cursor = await api.window.cursor

    // [txt](url "title")
    let link = new RegExp(
        /\[[^\[\]]*\]/.source // [txt]
        + /\(([^\(\)"]*)/.source // (url
        + /(?:\s*"[^"]*")?/.source // "title")
        , 'g')

    let matched = line.matchAll(link);
    for (const i of matched) {
        if (typeof i.index == "undefined") {
            break
        }
        if (cursor[1] >= i.index && cursor[1] <= i.index + i[0].length) {
            return i[1]
        }
    }

    // <link>
    link = new RegExp(
        /<([^<>]*)>/.source //<link>
        , "g")

    matched = line.matchAll(link);
    for (const i of matched) {
        if (typeof i.index == "undefined") {
            break
        }
        if (cursor[1] >= i.index && cursor[1] <= i.index + i[0].length) {
            return i[1]
        }
    }

    // src="lskdjflkj"
    link = new RegExp(
        /src="([^"]*)"/
        , "g")

    matched = line.matchAll(link);
    for (const i of matched) {
        if (typeof i.index == "undefined") {
            break
        }
        if (cursor[1] >= i.index && cursor[1] <= i.index + i[0].length) {
            return i[1]
        }
    }

    // word
    link = new RegExp(
        /(\S+)/
        , "g")

    matched = line.matchAll(link);
    for (const i of matched) {
        if (typeof i.index == "undefined") {
            break
        }
        if (cursor[1] >= i.index && cursor[1] <= i.index + i[0].length) {
            return i[1]
        }
    }

    return ""
}

type UrlWithOpener = {
    url: URL
    opener: string
}
export async function parseUrl(txt: string): Promise<UrlWithOpener> {
    const api = cxt.api!
    let url: URL
    let opener = "system"

    if (txt.search(/^\w+:\/\//) >= 0) {  //local path
        if (txt.startsWith("workspace://")) {
            url = new URL(txt.replace(/^workspace:\/+/, "file:///"))
            url.pathname = path.join((await api.getVar("workspace")).toString(), url.pathname)
        } else {
            url = new URL(txt)
            opener = "browser"
        }
    } else {
        if (txt.startsWith("/")) {
            url = new URL(txt.replace(/^\/+/, "file:///"))
        } else {
            const dir: string = await api.call("expand", "%:p:h")
            url = new URL(`file://${dir}/${txt}`)
        }
    }

    if (url.protocol == "file:") {
        const mime = lookup(url.pathname)
        if (mime && mime.startsWith("text")) {
            opener = "vim"
        }
    }
    return {
        url: url,
        opener: opener
    }
}
export async function openURL() {
    const api = cxt.api!
    const urltxt = await detectUrl()
    const uo = await parseUrl(urltxt)
    let path: string = ""
    switch (uo.opener) {
        case "vim":
            path = fileURLToPath("file://" + uo.url.pathname)
            await api.command(`edit ${path}`)
            if (uo.url.hash) {
                gotoHeader(uo.url.hash)
            }
            break;
        case "system":
            path = fileURLToPath("file://" + uo.url.pathname)
            spawnSync("open", [path])
            break;
        case "browser":
            spawnSync("open", ["-a", "Microsoft Edge.app", uo.url.href])
            break;
        default:
            break;
    }
}
export async function revealURL() {
    const api = cxt.api!
    const urltxt = await detectUrl()
    const uo = await parseUrl(urltxt)
    let path: string = ""
    switch (uo.opener) {
        case "vim":
        case "system":
            path = fileURLToPath(`file://${uo.url.pathname}`)
            api.command(`!open -R '${path}'`)
            break;
        default:
            break;
    }
}
export async function copyURL() {
    const api = cxt.api!
    const urltxt = await detectUrl()
    const uo = await parseUrl(urltxt)

    api.call("setreg", ["+", uo.url.href])
}
export async function copyHeaderLink() {
    const api = cxt.api!
    const header: Line = await currentHeaderLine()
    //vim.fn.setreg("+", ("[%s](#%s)"): format(fragment, fragment))
    const hash = header.txt.trim().replace(/^#+\s*/, "").replace(/\s+/g, "-")
    api.call("setreg", ["+", `[${hash}][#${hash}]`])
}
export async function copyWorkSpaceLinkWithHeader() {
    const api = cxt.api!

    const header: Line = await currentHeaderLine()
    const hash = header.txt.trim().replace(/^#+\s*/, "")

    const workspace = await api.getVar("workspace") as string
    const p = await api.call("expand", ["%:p"])
    const filePathInWorkSpace = path.relative(workspace, p)

    api.call("setreg", ["+", `[${hash}](workspace://${filePathInWorkSpace}#${hash.replace(/\s+/g, "-")})`])
}
export async function copyWorkSpaceLink() {
    const api = cxt.api!

    const workspace = await api.getVar("workspace") as string
    const p = await api.call("expand", ["%:p"])
    const filePathInWorkSpace = path.relative(workspace, p)

    api.call("setreg", ["+", `[${path.basename(p)}](workspace://${filePathInWorkSpace})`])
}

async function gotoHeader(hash: string) {
    const api = cxt.api!
    const doc = await api.buffer.lines

    for (let index = 0; index < doc.length; index++) {
        if (doc[index].startsWith("#")
            && doc[index].trim().replace(/^#+\s*/, "").replace(/\s+/g, "-") == decode(hash).replace(/^#/, "")
           ) {
               api.window.cursor = [index + 1, 1]
               await api.command("normal! zt")
               await api.command("normal! zO")
           }
    }
}
