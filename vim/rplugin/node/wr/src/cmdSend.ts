import {cxt} from "./env";
import {NvimPlugin} from "neovim";
import {sendToTmux} from "./tmux";


export function setup(plugin: NvimPlugin) {
    plugin.registerCommand("CmdSendLine", cmdSendLine, {sync: false})
    plugin.registerCommand("CmdSendRange", cmdSendRange, {range: ''})
}

async function cmdSendRange() {
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
async function cmdSendLine() {
    const api = cxt.api!
    sendToTmux(await api.line)
}
