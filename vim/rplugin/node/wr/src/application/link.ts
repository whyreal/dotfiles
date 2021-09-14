import {fileURLToPath, URL} from "url";
import { lookup } from "mime-types";
import * as path from "path";
import {spawnSync} from "child_process";
import {currentHeaderLine} from "../infra/line";
import { decode } from "urlencode";
import {NvimPlugin} from "neovim";
import {cxt} from "../infra/env";
import {setCursor} from "../infra/cursor";
import {Line} from "../domain/line";
import {getLineAtCursor} from "../infra/lineRange";
import {Range} from "../domain/range";
import {upload} from "../infra/picgo"

export function setup(plugin: NvimPlugin) {
    plugin.registerCommand("OpenURL", openURL, {sync: false})
    plugin.registerCommand("RevealURL", revealURL, {sync: false})
    plugin.registerCommand("CopyURL", copyURL, {sync: false})

    plugin.registerCommand("CopyHeaderLink", copyHeaderLink, {sync: false})
    plugin.registerCommand("CopyWorkSpaceLinkWithHeader", copyWorkSpaceLinkWithHeader, {sync: false})
    plugin.registerCommand("CopyWorkSpaceLink", copyWorkSpaceLink, {sync: false})

    plugin.registerCommand("ImgUpload", imgUpload, {sync: false})
}
async function detectLink(): Promise<Range> {
    const line = await getLineAtCursor()
    const cursor = line.cursor
    const txt = line.lines[0].txt

    // [txt](url "title")
    let link = new RegExp(
        /(\[[^\[\]]*\]\()/.source // [txt](
        + /([^\(\)"]*)/.source // url
        + /(?:\s*"[^"]*")?\)/.source // "title")
        , 'g')

    let matched = txt.matchAll(link);
    for (const i of matched) {
        if (typeof i.index == "undefined") {
            break
        }
        if (cursor[1] >= i.index && cursor[1] <= i.index + i[0].length) {
            line.start = [cursor[0], i.index + i[1].length]
            line.end = [cursor[0], i.index + i[1].length + i[2].length]
            return line
        }
    }

    // <link>
    link = new RegExp(
        /<([^<>]*)>/.source //<link>
        , "g")

    matched = txt.matchAll(link);
    for (const i of matched) {
        if (typeof i.index == "undefined") {
            break
        }
        if (cursor[1] >= i.index && cursor[1] <= i.index + i[0].length) {
            line.start = [cursor[0], i.index + 1]
            line.end = [cursor[0], i.index + 1 + i[1].length]
            return line
        }
    }

    // src="http://xxxxx"
    link = new RegExp(
        /src="([^"]*)"/
        , "g")

    matched = txt.matchAll(link);
    for (const i of matched) {
        if (typeof i.index == "undefined") {
            break
        }
        if (cursor[1] >= i.index && cursor[1] <= i.index + i[0].length) {
            line.start = [cursor[0], i.index + 4]
            line.end = [cursor[0], i.index + 4 + i[1].length]
            return line
        }
    }

    // word
    link = new RegExp(
        /(\S+)/
        , "g")

    matched = txt.matchAll(link);
    for (const i of matched) {
        if (typeof i.index == "undefined") {
            break
        }
        if (cursor[1] >= i.index && cursor[1] <= i.index + i[0].length) {
            line.start = [cursor[0], i.index]
            line.end = [cursor[0], i.index + i[0].length]
            return line
        }
    }

    return line
}

type Opener = "vim" | "browser" | "system" | "hash" | "netrw"

type UrlWithOpener = {
    url: URL
    opener: "vim" | "browser" | "system" | "netrw"
} | {
    url: string
    opener: "hash"
}
async function parseUrl(txt: string): Promise<UrlWithOpener> {
    const api = cxt.api!
    let url: URL
    let opener: Opener = "system"

    if (txt.search(/^\w+:\/\//) >= 0) {  //local path
        if (txt.startsWith("workspace://")) {
            url = new URL(txt.replace(/^workspace:\/+/, "file:///"))
            url.pathname = path.join((await api.getVar("workspace")).toString(), url.pathname)
        } else if (txt.startsWith("scp://")) {
            url = new URL(txt)
            opener = "netrw"
        } else {
            url = new URL(txt)
            opener = "browser"
        }
    } else if (txt.startsWith("#")) {
        return {
            url: txt,
            opener: "hash"
        }
    } else if (txt.startsWith("/")) {
        url = new URL(txt.replace(/^\/+/, "file:///"))
    } else {
        const dir: string = await api.call("expand", "%:p:h")
        url = new URL(`file://${dir}/${txt}`)
    }

    if (url.protocol == "file:") {
        const mime = lookup(url.pathname)
        if (mime &&
            (mime.startsWith("text")
                || ["application/x-sh", "application/x-sql"].includes(mime))) {
            opener = "vim"
        }
    }
    return {
        url: url,
        opener: opener
    }
}
async function openURL() {
    const api = cxt.api!
    const link = await detectLink()
    const url = link.lines[0].txt.substr(link.start[1], link.end[1] - link.start[1])
    const uo = await parseUrl(url)
    let path: string = ""
    switch (uo.opener) {
        case "vim":
            path = fileURLToPath("file://" + uo.url.pathname)
            await api.command(`edit ${path}`);
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
        case "hash":
            gotoHeader(uo.url)
            break;
        case "netrw":
            await api.command(`edit ${uo.url.href}`);
            break;
        default:
            break;
    }
}
async function revealURL() {
    const api = cxt.api!
    const link = await detectLink()
    const url = link.lines[0].txt.substr(link.start[1], link.end[1] - link.start[1])
    const uo = await parseUrl(url)

    switch (uo.opener) {
        case "vim":
        case "system":
            const path = fileURLToPath(`file://${uo.url.pathname}`)
            api.command(`!open -R '${path}'`)
            break;
        default:
            break;
    }
}
async function copyURL() {
    const api = cxt.api!
    const link = await detectLink()
    const url = link.lines[0].txt.substr(link.start[1], link.end[1] - link.start[1])
    const uo = await parseUrl(url)

    switch (uo.opener) {
        case "hash":
            api.call("setreg", ["+", uo.url])
            break;
        default:
            api.call("setreg", ["+", uo.url.href])
            break;
    }
}
async function copyHeaderLink() {
    const api = cxt.api!
    const header: Line = await currentHeaderLine()
    //vim.fn.setreg("+", ("[%s](#%s)"): format(fragment, fragment))
    const hash = header.txt.trim().replace(/^#+\s*/, "").replace(/\s+/g, "-")
    api.call("setreg", ["+", `[${hash}](#${hash})`])
}
async function copyWorkSpaceLinkWithHeader() {
    const api = cxt.api!

    const header: Line = await currentHeaderLine()
    const hash = header.txt.trim().replace(/^#+\s*/, "")

    const workspace = await api.getVar("workspace") as string
    const p = await api.call("expand", ["%:p"])
    const filePathInWorkSpace = path.relative(workspace, p)

    api.call("setreg", ["+", `[${hash}](workspace://${filePathInWorkSpace}#${hash.replace(/\s+/g, "-")})`])
}
async function copyWorkSpaceLink() {
    const api = cxt.api!

    const workspace = await api.getVar("workspace") as string
    const p = await api.call("expand", ["%:p"])
    const filePathInWorkSpace = path.relative(workspace, p)

    api.call("setreg", ["+", `[${path.basename(p)}](workspace://${filePathInWorkSpace})`])
}
async function gotoHeader(hash: string) {
    const api = cxt.api!
    const doc = await api.buffer.lines

    doc.forEach(async (v, i) => {
        if(v.startsWith("#")
            && v.trim().replace(/^#+\s*/, "").replace(/\s+/g, "-") == decode(hash).replace(/^#/, "")
        ) {
            await setCursor([i, 1])
            await api.command("normal! zt")
            await api.command("normal! zO")
        }
    })
}

async function imgUpload(url: string | undefined) {
    if (url == undefined) {
        const link = await detectLink()
        url = link.lines[0].txt.substr(link.start[1], link.end[1] - link.start[1])
    }

    const suffix = /\.(png|jpg|jpeg|webp|gif|bmp|tiff|ico)$/;
    if (!suffix.test(url)) {
        return null
    }

    // remote 
    if (url.startsWith("http")) {
        return upload(url)
    }

    // local
    if (!url.startsWith("/")) {

    }

    //url = path.isAbsolute(url) ? url : path.join(Uri.parse(doc.uri).fsPath, '../', url);
    //if (fs.existsSync(result)) {
        //return vspicgo.upload([result]);
    //} else {
        //return workspace.showMessage('No such image.' + result);
    //}
    return upload(url)
}
