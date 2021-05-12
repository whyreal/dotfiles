import {spawnSync} from "child_process";

export function sendToTmux(txt: string) {
    txt = txt.trim().replace(/;$/, "\\;")

    let args = ["send-keys", txt, "ENTER"]
    spawnSync("tmux", args)
}

