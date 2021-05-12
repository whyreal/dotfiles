import {sendToTmux as sendCmd} from "../infra/tmux";
import { NvimPlugin } from "neovim";
import {HttpRequest, parseHttpRequest} from "../domain/rest";
import {fetchRequestLines} from "../infra/line";

export function setup(plugin: NvimPlugin) {
    plugin.registerCommand("RestSendRequest", restSendRequest, {sync: false})
}

async function restSendRequest() {
    const lines = await fetchRequestLines()
    const cmd = getCurlCmd(parseHttpRequest(lines.join("\n")))
    sendCmd(cmd)
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

