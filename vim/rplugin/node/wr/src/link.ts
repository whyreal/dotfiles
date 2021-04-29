import {cxt} from "./env";
import {fileURLToPath, URL} from "url";
import { lookup } from "mime-types";
import * as path from "path";
import {spawnSync} from "child_process";


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
            api.command(`edit ${path}`)
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
