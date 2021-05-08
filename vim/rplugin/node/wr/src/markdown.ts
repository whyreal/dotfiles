import {codeBlockCreateFromCodeLineScan, codeBlockCreateFromTableScan, codeBlockCreateScan, mdHeaderLevelDownScan, mdHeaderLevelUpScan, mdListCreateScan, mdListDeleteScan, mdOrderListCreateScan, toggleRangeWrapScan, toggleWordWrapScan} from "./lineScan";
import {getHeaderRangeAtCursor, getVisualLineRange, LineRange, freshRange, getLineAtCursor, getWrapRange, WrapType} from "./lineRange";
import {excuteAction, LineAction} from "./lineAction";
import {curry} from "ramda";
import {NvimPlugin} from "neovim";
import {cxt} from "./env";
import {setPos} from "./cursor";

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

    plugin.registerCommand("ToggleRangeWrapWithBold",      toggleRangeWrap("**", "**"), {sync: false, range: ''})
    plugin.registerCommand("ToggleRangeWrapWithItalic",    toggleRangeWrap("*", "*"), {sync: false, range: ''})
    plugin.registerCommand("ToggleRangeWrapWithBackquote", toggleRangeWrap("`", "`"), {sync: false, range: ''})

    plugin.registerCommand("SelectBoldRangeInner", selectWrapRange("Inner", "**", "**"), {sync: true, range: ''})
    plugin.registerCommand("SelectBoldRangeAll", selectWrapRange("All", "**", "**"), {sync: true, range: ''})

    plugin.registerCommand("SelectItalicRangeInner", selectWrapRange("Inner", "*", "*"), {sync: true, range: ''})
    plugin.registerCommand("SelectItalicRangeAll", selectWrapRange("All", "*", "*"), {sync: true, range: ''})

    plugin.registerCommand("SelectBackquoteRangeInner", selectWrapRange("Inner", "`", "`"), {sync: true, range: ''})
    plugin.registerCommand("SelectBackquoteRangeAll", selectWrapRange("All", "`", "`"), {sync: true, range: ''})
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
    return async () => {
        updateRange(getLineAtCursor, curry(toggleWordWrapScan)(left, right))
    }
}
function toggleRangeWrap(left: string, right: string): Function {
    return async () => {
        updateRange(getVisualLineRange, curry(toggleRangeWrapScan)(left, right))
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
function selectWrapRange(type:WrapType, left: string, right: string) {
    return async () => {
        const api = cxt.api!
        const lineRange = await getWrapRange(type, left, right)
        if (!lineRange) {
            return
        }

        await setPos("<", lineRange.start)
        await setPos(">", lineRange.end)
        await api.command("normal gv")
    }
}
