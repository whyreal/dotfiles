import {NvimPlugin} from "neovim";
import {cxt} from "./env";

export function setup(plugin: NvimPlugin) {
    plugin.registerCommand("GotoFirstChar", gotoFirstChar, {sync: false})
}

async function gotoFirstChar() {
    const api = cxt.api!
    const l = await api.line
    const c = await api.window.cursor
    const fc = l.search(/[^\s]/)

    if (c[1] == fc) {
        api.window.cursor = [c[0], 0]
    } else {

        api.window.cursor = [c[0], fc]
    }
}
