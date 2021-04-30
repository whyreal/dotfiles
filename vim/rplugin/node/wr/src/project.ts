import { Neovim, NvimPlugin } from "neovim";
import { keys } from "ramda";

let api: Neovim

export function setup(plugin: NvimPlugin) {
    api = plugin.nvim

    plugin.registerFunction("ListProjects", listProject, {sync:true})
    plugin.registerCommand("GotoProject", gotoProject, {
        complete:"custom,ListProjects",
        nargs:"1"
    })
}

async function listProject() {
    const projects = await api.getVar("projects") as {[key: string]: string}
    return keys(projects).join("\n")
}

async function gotoProject(p: string) {
    const projects = await api.getVar("projects") as {[key: string]: string}
    api.command(`Explore ${projects[p]}`)
}
