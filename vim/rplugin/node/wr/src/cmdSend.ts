import {cxt} from "./env";
import {spawnSync} from "child_process";

export function sendToTmux(txt: string) {
    txt = txt.trim().replace(/;$/, "\\;")

    let args = ["send-keys", txt, "ENTER"]
    spawnSync("tmux", args)
}

export async function cmdSendRange() {
    const api = cxt.api!
    const start = await api.buffer.mark('<')
    const end = await api.buffer.mark('>')
    const lines = await api.buffer.getLines({
        start: start[0] - 1,
        end: end[0],
        strictIndexing: false
    })

    lines.forEach((l, i) => {
        // 发的太快的话 shell 中会出现  不知道是啥意思
        setTimeout(sendToTmux, i * 50, l)
    })
}

export async function cmdSendLine() {
    const api = cxt.api!
    sendToTmux(await api.line)
}
