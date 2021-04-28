import { NvimPlugin, Neovim } from "neovim";

export let plugin: NvimPlugin | null = null
export function getPlugin() {
    return plugin
}

export function setPlugin(p:NvimPlugin) {
    plugin = p
}

interface Context {
    api?: Neovim
}

export let cxt: Context = {}
