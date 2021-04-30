import {NvimPlugin} from "neovim";
import {cxt} from "./env";

import {setup as cursorSetup} from "./cursor";
import {setup as cmdSetup} from "./cmdSend";
import {setup as restSetup} from "./rest";
import {setup as linkSetup} from "./link";

import {setup as projectSetup} from "./project";
import { setup as mdSetup} from "./markdown";

function setup(plugin: NvimPlugin) {
    cxt.api = plugin.nvim

    plugin.setOptions({dev: false})
    //plugin.setOptions({dev: true, alwaysInit: true});

    mdSetup(plugin)
    projectSetup(plugin)
    linkSetup(plugin)
    restSetup(plugin)
    cmdSetup(plugin)
    cursorSetup(plugin)
};

module.exports = setup
