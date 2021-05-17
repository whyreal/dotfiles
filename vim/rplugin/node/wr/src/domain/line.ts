export type LineNumber = number
export type Line = {
    ln: LineNumber
    txt: string
}
export type LineGroup = {
    cur: Line[]
    before: Line[]
    after: Line[]
}

