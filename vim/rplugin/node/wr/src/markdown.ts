import {codeBlockCreateFromCodeLineScan, codeBlockCreateFromTableScan, codeBlockCreateScan, mdHeaderLevelDownScan, mdHeaderLevelUpScan, mdListCreateScan, mdListDeleteScan, mdOrderListCreateScan, wrapWordWithScan} from "./lineScan";
import {getHeaderRangeAtCursor, getVisualLineRange, LineRange, freshRange, getLineAtCursor} from "./lineRange";
import {excuteAction, LineAction} from "./lineAction";
import {curry} from "ramda";
import {NvimPlugin} from "neovim";
import {cxt} from "./env";

export function setup(plugin: NvimPlugin) {
    plugin.registerCommand("MdHeaderLevelUp", mdHeaderLevelUp, {sync: false})
    plugin.registerCommand("MdHeaderLevelDown", mdHeaderLevelDown, {sync: false})
    plugin.registerCommand("MdHeaderLevelUpRange", mdHeaderLevelUpRange, {range: ''})
    plugin.registerCommand("MdHeaderLevelDownRange", mdHeaderLevelDownRange, {range: ''})

    plugin.registerCommand("ListCreate", mdListCreate, {sync: false})
    plugin.registerCommand("ListDelete", mdListDelete, {sync: false})
    plugin.registerCommand("OrderListCreate", mdOrderListCreate, {sync: false})

    plugin.registerCommand("MdCreateCodeBlock", createCodeBlock, {range: ''})
    plugin.registerCommand("MdCreateCodeBlockFromeCodeLine", createCodeBlockFromeCodeLine, {range: ''})
    plugin.registerCommand("MdCreateCodeBlockFromeTable", mdCreateCodeBlockFromeTable, {range: ''})

    plugin.registerCommand("ToggleWordWrapWithBold", toggleWordWrap("**", "**"), {sync: false})
    plugin.registerCommand("ToggleWordWrapWithItalic", toggleWordWrap("*", "*"), {sync: false})
    plugin.registerCommand("ToggleWordWrapWithBackquote", toggleWordWrap("`", "`"), {sync: false})

    plugin.registerCommand("MdAddDefaultImgTxt", mdAddDefaultImgTxt, {sync: false})
}

type RangeSelector = () => Promise<LineRange>
type RangeScanner = (a: LineRange) => Map<number, LineAction[]>

async function updateRange(selector: RangeSelector, scanner: RangeScanner) {
    const lineRange = await selector()
    const actions = scanner(lineRange)

    const lines = excuteAction(actions, lineRange)
    freshRange(lines, lineRange)
}
function toggleWordWrap(left: string, right: string) {
    return () => {
        updateRange(getLineAtCursor, curry(wrapWordWithScan)(left, right))
    }
}
async function mdHeaderLevelUpRange() {
    updateRange(getVisualLineRange, mdHeaderLevelUpScan)
}
async function mdHeaderLevelDownRange() {
    updateRange(getVisualLineRange, curry(mdHeaderLevelDownScan)(false))
}
async function mdHeaderLevelDown() {
    updateRange(getHeaderRangeAtCursor, curry(mdHeaderLevelDownScan)(true))
}
async function mdHeaderLevelUp() {
    updateRange(getHeaderRangeAtCursor, mdHeaderLevelUpScan)
}
async function mdListCreate() {
    updateRange(getVisualLineRange, mdListCreateScan)
}
async function mdListDelete() {
    updateRange(getVisualLineRange, mdListDeleteScan)
}
async function mdOrderListCreate() {
    updateRange(getVisualLineRange, mdOrderListCreateScan)
}
async function createCodeBlock() {
    updateRange(getVisualLineRange, codeBlockCreateScan)
}
async function createCodeBlockFromeCodeLine() {
    updateRange(getVisualLineRange, codeBlockCreateFromCodeLineScan)
}
async function mdCreateCodeBlockFromeTable() {
    updateRange(getVisualLineRange, codeBlockCreateFromTableScan)
}

async function mdAddDefaultImgTxt() {
    const api = cxt.api!
    api.command('%s/!\\[\\]/![img]/g')
}
