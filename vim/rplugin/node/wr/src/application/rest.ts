import {sendToTmux as sendCmd} from "../infra/tmux";
import { NvimPlugin } from "neovim";
import {HttpRequest, parseHttpRequest} from "../domain/rest";
import {fetchRestLines} from "../infra/line";
import {always, ap, cond, curry, has, join, map, of, pipe, prop, T} from "ramda";

export function setup(plugin: NvimPlugin) {
    plugin.registerCommand("RestSendRequest", restSendRequest, {sync: false})
}

function restSendRequest() {
    fetchRestLines().then(pipe(
        join("\n"),
        parseHttpRequest,
        getCurlCmd,
        sendCmd
    ))
}

function getCurlCmd(req: HttpRequest): string {
    return pipe(
        curry(of),
        ap<HttpRequest, string>([
            r => `curl -X ${r.method} '${r.url}' `,

            pipe(prop("headers"),
                map((h: [string, string]) => `-H '${h[0]}: ${h[1]}' `),
                join(" ")),

            cond([
                [has('body'), r => `-d '${r.body}'`],
                [T, always("")]
            ])
        ]),
        join(" ")
    )(req)
}
