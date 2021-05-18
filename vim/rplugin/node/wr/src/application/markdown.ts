import {codeBlockCreateFromCodeLineScan, codeBlockCreateFromTableScan, codeBlockCreateScan, mdHeaderLevelDownScan, mdHeaderLevelUpScan, mdListCreateScan, mdListDeleteScan, mdOrderListCreateScan, RangeScanner, toggleRangeWrapScan, toggleWordWrapScan} from "./lineScan";
import {getHeaderRangeAtCursor, getVisualLineRange, freshRange, getLineAtCursor, getWrapRange, WrapType} from "../infra/lineRange";
import {curry} from "ramda";
import {NvimPlugin} from "neovim";
import {cxt} from "../infra/env";
import {setPos} from "../infra/cursor";
import { Range } from "../domain/range";
import {excuteAction} from "./lineAction";

export function setup(plugin: NvimPlugin) {
    plugin.registerCommand("MdHeaderLevelUp", mdHeaderLevelUp, {sync: false})
    plugin.registerCommand("MdHeaderLevelDown", mdHeaderLevelDown, {sync: false})
    plugin.registerCommand("MdHeaderLevelUpRange", mdHeaderLevelUpRange, {range: ''})
    plugin.registerCommand("MdHeaderLevelDownRange", mdHeaderLevelDownRange, {range: ''})

    plugin.registerCommand("ListCreate", mdListCreate, {sync: false})
    plugin.registerCommand("ListDelete", mdListDelete, {sync: false})
    plugin.registerCommand("OrderListCreate", mdOrderListCreate, {sync: false})

    plugin.registerCommand("MdCreateCodeBlock", createCodeBlock, {range: '', nargs:'?'})
    plugin.registerCommand("MdCreateCodeBlockFromeCodeLine", createCodeBlockFromeCodeLine, {range: ''})
    plugin.registerCommand("MdCreateCodeBlockFromeTable", mdCreateCodeBlockFromeTable, {range: ''})

    plugin.registerFunction("ToggleWordWrapWith", toggleWordWrap, {sync: false})

    plugin.registerCommand("MdAddDefaultImgTxt", mdAddDefaultImgTxt, {sync: false})

    plugin.registerCommand("ToggleRangeWrapWith", toggleRangeWrap, {range: '', nargs: '+'})

    plugin.registerFunction("SelectWrapRange", selectWrapRange)
}

async function updateRange(lr: Range, scanner: RangeScanner) {
    const c = lr.cursor
    const actions = scanner(lr)

    const lines = excuteAction(actions, lr)
    freshRange(lines, lr)
    setPos(".", c)
}
async function toggleWordWrap(args: string[]) {
    const [left, right] = args
    updateRange(await getLineAtCursor(), curry(toggleWordWrapScan)(left, right))
}
async function toggleRangeWrap(args: string[]){
    const [left, right] = args
    updateRange(await getVisualLineRange(), curry(toggleRangeWrapScan)(left, right))
}
async function mdHeaderLevelUpRange() {
    updateRange(await getVisualLineRange(), mdHeaderLevelUpScan)
}
async function mdHeaderLevelDownRange() {
    updateRange(await getVisualLineRange(), curry(mdHeaderLevelDownScan)(false))
}
async function mdHeaderLevelDown() {
    updateRange(await getHeaderRangeAtCursor(), curry(mdHeaderLevelDownScan)(true))
}
async function mdHeaderLevelUp() {
    updateRange(await getHeaderRangeAtCursor(), mdHeaderLevelUpScan)
}
async function mdListCreate() {
    updateRange(await getVisualLineRange(), mdListCreateScan)
}
async function mdListDelete() {
    updateRange(await getVisualLineRange(), mdListDeleteScan)
}
async function mdOrderListCreate() {
    updateRange(await getVisualLineRange(), mdOrderListCreateScan)
}
async function createCodeBlock(lang: string) {
    lang = lang || ""
    updateRange(await getVisualLineRange(), curry(codeBlockCreateScan)(lang))
}
async function createCodeBlockFromeCodeLine() {
    updateRange(await getVisualLineRange(), codeBlockCreateFromCodeLineScan)
}
async function mdCreateCodeBlockFromeTable() {
    updateRange(await getVisualLineRange(), codeBlockCreateFromTableScan)
}
async function mdAddDefaultImgTxt() {
    const api = cxt.api!
    api.command('%s/!\\[\\]/![img]/g')
}
async function selectWrapRange(args: [WrapType, string, string]) {
    const [type, left, right] = args
    const api = cxt.api!
    const lineRange = await getWrapRange(type, left, right)
    if (!lineRange) {
        return
    }

    await setPos("<", lineRange.start)
    await setPos(">", lineRange.end)
    await api.command("normal gv")
}
