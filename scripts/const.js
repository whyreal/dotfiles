import {dirname} from "path"

export const project_root = dirname(process.argv[1])

export const docRoot = process.env["HOME"] + "/Documents/DocBase/"
