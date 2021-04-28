import {codeBlockCreateFromCodeLineScan, codeBlockCreateFromTableScan, codeBlockCreateScan, deleteBlankLineScan, mdHeaderLevelDownScan, mdHeaderLevelUpScan, mdListCreateScan, mdListDeleteScan, mdOrderListCreateScan} from "./line";
import {getHeaderRange, getVisualLineRange, updateLineRange} from "./range";
import { excuteAction } from "./lineAction";

export async function deleteBlankLine() {
    const lineRange = await getVisualLineRange()
    const actions = deleteBlankLineScan(lineRange)
    const lines = excuteAction(actions, lineRange.lines)

    updateLineRange(lines, lineRange)
}

export async function mdHeaderLevelUpRange() {
    const lineRange = await getVisualLineRange()
    const actions = mdHeaderLevelUpScan(lineRange)
    const lines = excuteAction(actions, lineRange.lines)

    updateLineRange(lines, lineRange)
}
export async function mdHeaderLevelDownRange() {
    const lineRange = await getVisualLineRange()
    const actions = mdHeaderLevelDownScan(lineRange)
    const lines = excuteAction(actions, lineRange.lines)

    updateLineRange(lines, lineRange)
}
export async function mdHeaderLevelDown() {
    const lineRange = await getHeaderRange()
    const actions = mdHeaderLevelDownScan(lineRange, true)
    const lines = excuteAction(actions, lineRange.lines)

    updateLineRange(lines, lineRange)
}
export async function mdHeaderLevelUp() {
    const lineRange = await getHeaderRange()
    const actions = mdHeaderLevelUpScan(lineRange)
    const lines = excuteAction(actions, lineRange.lines)

    updateLineRange(lines, lineRange)
}

export async function mdListCreate() {
    const lineRange = await getVisualLineRange()
    const actions = mdListCreateScan(lineRange)
    const lines = excuteAction(actions, lineRange.lines)

    updateLineRange(lines, lineRange)
}
export async function mdListDelete() {
    const lineRange = await getVisualLineRange()
    const actions = mdListDeleteScan(lineRange)
    const lines = excuteAction(actions, lineRange.lines)

    updateLineRange(lines, lineRange)
}
export async function mdOrderListCreate() {
    const lineRange = await getVisualLineRange()
    const actions = mdOrderListCreateScan(lineRange)
    const lines = excuteAction(actions, lineRange.lines)

    updateLineRange(lines, lineRange)
}

export async function createCodeBlock() {
    const lineRange = await getVisualLineRange()
    const actions = codeBlockCreateScan(lineRange)
    const lines = excuteAction(actions, lineRange.lines)

    updateLineRange(lines, lineRange)
}
export async function createCodeBlockFromeCodeLine() {
    const lineRange = await getVisualLineRange()
    const actions = codeBlockCreateFromCodeLineScan(lineRange)
    const lines = excuteAction(actions, lineRange.lines)

    updateLineRange(lines, lineRange)
}

export async function mdCreateCodeBlockFromeTable() {
    const lineRange = await getVisualLineRange()
    const actions = codeBlockCreateFromTableScan(lineRange)
    const lines = excuteAction(actions, lineRange.lines)

    updateLineRange(lines, lineRange)
}
