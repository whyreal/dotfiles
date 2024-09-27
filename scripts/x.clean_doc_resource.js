import {existsSync, mkdirSync, readFileSync, readdirSync, renameSync, statSync} from 'fs'
import {docRoot} from './const.js'
import {basename} from 'path'

const imgMdLinkReg = new RegExp(/!\[.*\]\((?<link>http[^\s"?#)%]+)\)/, "g")
const imgHtmlLinkReg = new RegExp(/(?<link>_resources\/[^\s/"?#)]+)/, "g")

function init() {
    if (!existsSync("./_resources")) {
        process.chdir(docRoot)
        console.log(process.cwd())
    }

    mkdirSync("./uploaded")
    mkdirSync("./localed")
}

function clean() {
    renameSync("./_resources", "./deleted")
    renameSync("./localed", "./_resources")
}

function walk(path) {
    const files = readdirSync(path)
    files.forEach(f => {
        // ignore hidden files
        if (f.startsWith(".")) {return }

        const fpath = [path, f].join("/")
        const s = statSync(fpath)
        if (!s) {
            return
        }
        if (s.isFile()) {
            if (!fpath.endsWith(".md")) {
                return
            }
            processMd(fpath)
        }
        if (s.isDirectory()) {
            walk(fpath)
        }
    })
}

function processMd(fpath) {
    const content = readFileSync(fpath).toString('utf8')

    for (const l of content.matchAll(imgHtmlLinkReg)) {
        processUrl(l.groups.link)
    }
    for (const l of content.matchAll(imgMdLinkReg)) {
        processUrl(l.groups.link)
    }
}

function processUrl(url) {
    const fileName = basename(url)
    const from = [docRoot, "_resources", fileName].join("/")
    var to = ""
    if (!existsSync(from)) { return }
    //uploaded
    if (url.startsWith("https://raw.githubusercontent.com/whyreal/picgo")
        || url.startsWith("https://gitee.com/whyreal/picgo")) {
        to = [docRoot, "uploaded", fileName].join("/")
    }
    // localed
    if (url.startsWith("_resources")) {
        to = [docRoot, "localed", fileName].join("/")
    }
    return renameSync(from, to)
}

init()
walk(docRoot)
clean()
