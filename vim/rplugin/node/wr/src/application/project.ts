import {NvimPlugin} from "neovim";
import {keys} from "ramda";
import { cxt } from "../infra/env";

export function setup(plugin: NvimPlugin) {
    plugin.registerFunction("ListProjects", listProject, {sync:true})
    plugin.registerCommand("GotoProject", gotoProject, {
        complete:"custom,ListProjects",
        nargs:"1"
    })
}

async function listProject() {
    const api = cxt.api!
    const projects = await api.getVar("projects") as {[key: string]: string}
    return keys(projects).join("\n")
}

async function gotoProject(p: string) {
    const api = cxt.api!
    const projects = await api.getVar("projects") as {[key: string]: string}
    api.command(`Explore ${projects[p]}`)
    api.command(`lcd ${projects[p]}`)
}
