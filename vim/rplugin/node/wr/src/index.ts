import {NvimPlugin} from "neovim";
import {cxt} from "./env";

import {gotoFirstChar} from "./cursor";
import {cmdSendLine, cmdSendRange} from "./cmdSend";
import {restSendRequest} from "./rest";
import {mdHeaderLevelUp, mdHeaderLevelDown, mdHeaderLevelDownRange, mdHeaderLevelUpRange, mdListCreate, mdListDelete, mdOrderListCreate, createCodeBlock, createCodeBlockFromeCodeLine, mdCreateCodeBlockFromeTable} from "./markdown";
import {copyHeaderLink, copyURL, copyWorkSpaceLink, copyWorkSpaceLinkWithHeader, openURL, revealURL} from "./link";

import { setup as projectSetup} from "./project";

function setup(plugin: NvimPlugin) {
    cxt.api = plugin.nvim

    plugin.setOptions({dev: false})
    //plugin.setOptions({dev: true, alwaysInit: true});

    plugin.registerCommand("GotoFirstChar", gotoFirstChar, {sync: false})

    plugin.registerCommand("CmdSendLine", cmdSendLine, {sync: false})
    plugin.registerCommand("CmdSendRange", cmdSendRange, {range: ''})

    plugin.registerCommand("RestSendRequest", restSendRequest, {sync: false})

    plugin.registerCommand("MdHeaderLevelUp", mdHeaderLevelUp, {sync: false})
    plugin.registerCommand("MdHeaderLevelDown", mdHeaderLevelDown, {sync: false})
    plugin.registerCommand("MdHeaderLevelUpRange", mdHeaderLevelUpRange, {range: ''})
    plugin.registerCommand("MdHeaderLevelDownRange", mdHeaderLevelDownRange, {range: ''})

    plugin.registerCommand("ListCreate", mdListCreate, {sync: false})
    plugin.registerCommand("ListDelete", mdListDelete, {sync: false})
    plugin.registerCommand("OrderListCreate", mdOrderListCreate, {sync: false})

    plugin.registerCommand("OpenURL", openURL, {sync: false})
    plugin.registerCommand("RevealURL", revealURL, {sync: false})
    plugin.registerCommand("CopyURL", copyURL, {sync: false})

    plugin.registerCommand("CopyHeaderLink", copyHeaderLink, {sync: false})
    plugin.registerCommand("CopyWorkSpaceLinkWithHeader", copyWorkSpaceLinkWithHeader, {sync: false})
    plugin.registerCommand("CopyWorkSpaceLink", copyWorkSpaceLink, {sync: false})

    plugin.registerCommand("MdCreateCodeBlock", createCodeBlock, {range: ''})
    plugin.registerCommand("MdCreateCodeBlockFromeCodeLine", createCodeBlockFromeCodeLine, {range: ''})
    plugin.registerCommand("MdCreateCodeBlockFromeTable", mdCreateCodeBlockFromeTable, {range: ''})
    projectSetup(plugin)
};

module.exports = setup
