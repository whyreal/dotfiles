import {codeBlockCreateFromCodeLineScan, codeBlockCreateFromTableScan, codeBlockCreateScan, deleteBlankLineScan, mdHeaderLevelDownScan, mdHeaderLevelUpScan, mdListCreateScan, mdListDeleteScan, mdOrderListCreateScan} from "./lineScan";
import {getHeaderRange, getVisualLineRange, LineRange, freshRange} from "./range";
import {excuteAction, LineAction} from "./lineAction";
import {curry} from "ramda";

type RangeSelector = () => Promise<LineRange>
type RangeScanner = (a: LineRange) => Map<number, LineAction[]>

async function updateRange(selector: RangeSelector, scanner: RangeScanner) {
    const lineRange = await selector()

    const actions = scanner(lineRange)
    const lines = excuteAction(actions, lineRange)
    freshRange(lines, lineRange)
}

export async function deleteBlankLine() {
    updateRange(getVisualLineRange, deleteBlankLineScan)
}
export async function mdHeaderLevelUpRange() {
    updateRange(getVisualLineRange, mdHeaderLevelUpScan)
}
export async function mdHeaderLevelDownRange() {
    updateRange(getVisualLineRange, curry(mdHeaderLevelDownScan)(false))
}
export async function mdHeaderLevelDown() {
    updateRange(getHeaderRange, curry(mdHeaderLevelDownScan)(true))
}
export async function mdHeaderLevelUp() {
    updateRange(getHeaderRange, mdHeaderLevelUpScan)
}
export async function mdListCreate() {
    updateRange(getVisualLineRange, mdListCreateScan)
}
export async function mdListDelete() {
    updateRange(getVisualLineRange, mdListDeleteScan)
}
export async function mdOrderListCreate() {
    updateRange(getVisualLineRange, mdOrderListCreateScan)
}

export async function createCodeBlock() {
    updateRange(getVisualLineRange, codeBlockCreateScan)
}
export async function createCodeBlockFromeCodeLine() {
    updateRange(getVisualLineRange, codeBlockCreateFromCodeLineScan)
}

export async function mdCreateCodeBlockFromeTable() {
    updateRange(getVisualLineRange, codeBlockCreateFromTableScan)
}
