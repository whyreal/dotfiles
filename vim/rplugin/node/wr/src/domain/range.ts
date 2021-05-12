import {Cursor} from "./cursor";
import {Line} from "./line";

export type RangeSelector = () => Promise<Range>

export type Range = {
    start: Cursor
    end: Cursor
    cursor: Cursor
    encoding: string
    lineCount: number
    lines: Line[]
}
