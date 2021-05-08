import {cxt} from "./env";
import {NvimPlugin} from "neovim";
import {sendToTmux} from "./tmux";
import {getVisualLineRange} from "./lineRange";


export function setup(plugin: NvimPlugin) {
    plugin.registerCommand("CmdSendLine", cmdSendLine, {sync: false})
    plugin.registerCommand("CmdSendRange", cmdSendRange, {range: ''})
}

async function cmdSendRange() {
    const lines = (await getVisualLineRange()).lines
    lines.forEach(l => {
        // 发的太快的话 shell 中会出现  不知道是啥意思
        setTimeout(sendToTmux, (l.ln - lines[0].ln) * 50, l.txt)
    })
}
async function cmdSendLine() {
    const api = cxt.api!
    sendToTmux(await api.line)
}
