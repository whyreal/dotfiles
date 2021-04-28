import {Line} from "./line";

type ReplaceAction = {
    name: "Replace",
    args: string
}
type AppendAction = {
    name: "Append",
    args: string[]
}
type InsertAction = {
    name: "Insert",
    args: string[]
}
type OrderListCreateAction = {
    name: "OrderListCreate",
    args: number
}
type SetLevelAction = {
    name: "SetLevel",
    args: number
}
export type LineAction = { name: "Delete" | "LevelUp" | "LevelDown" | "ListCreate" | "ListDelete"} |
    SetLevelAction | OrderListCreateAction |
    ReplaceAction | AppendAction | InsertAction

function downLevel(line: string): string {
    if (line.startsWith("#")) {
        line = "#" + line
    } else {
        line= "# " + line
    }
    return line
}

function upLevel(line: string): string {
    line = line.replace(/^#\s*/, "")
    return line
}

function setLevel(line: string, level: number): string {
    let prefix = "#".repeat(level)
    if (level > 0) {
        prefix = prefix + " "
    }

    line = line.replace(/^#*\s*/, prefix)
    return line
}

function listDelete(txt: string): string {
    return txt.replace(/(\s*)(-|\d+\.)\s*(.*)/, "$1$3")
}

function listCreate(txt: string): string {
    return txt.replace(/(\s*)(.*)/, "$1- $2")
}

function orderListCreate(txt: string, order: number): string {
    return txt.replace(/(\s*)(.*)/, "$1" + order + ". $2")
}

export function excuteAction(actions: Map<number, LineAction[]>,
                      lines: Line[]): string[] {

    const x = lines.map(line => {
        if (!actions.has(line.nr)) {
            return [line.txt]
        }
        const cla = actions.get(line.nr)!

        let txt: string | null = line.txt
        let linesBefore: string[] = []
        let linesAfter: string[] = []
        cla.forEach(a => {
            switch (a.name) {
                case "Delete":
                    txt = null;
                    break;
                case "Append":
                    linesAfter = a.args.concat(linesAfter);
                    break;
                case "Insert":
                    linesBefore = linesBefore.concat(a.args);
                    break;
                case "Replace":
                    txt = a.args;
                    break;
                case "LevelDown":
                    txt = downLevel(txt!);
                    break;
                case "LevelUp":
                    txt = upLevel(txt!);
                    break;
                case "SetLevel":
                    txt = setLevel(txt!, a.args);
                    break;
                case "ListDelete":
                    txt = listDelete(txt!);
                    break;
                case "ListCreate":
                    txt = listCreate(txt!);
                    break;
                case "OrderListCreate":
                    txt = orderListCreate(txt!, a.args);
                break;
                default:
                    break;
            }
        })

        return linesBefore.concat(txt ? [txt] : []).concat(linesAfter)
    })
    const y = x.reduce((acc, cur) => {
        return acc.concat(cur)
    })
    return y
}
