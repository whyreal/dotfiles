import {NvimPlugin} from "neovim";
import {cxt} from "./infra/env";

import {setup as cmdSetup} from "./infra/cmdSend";
import {gotoFirstChar} from "./infra/cursor";

import {setup as restSetup} from "./application/rest";
import {setup as linkSetup} from "./application/link";
import {setup as projectSetup} from "./application/project";
import {setup as mdSetup} from "./application/markdown";
import { setup as tplSetup} from "./application/template";

function setup(plugin: NvimPlugin) {
  cxt.api = plugin.nvim

  plugin.setOptions({dev: false})
  //plugin.setOptions({dev: true, alwaysInit: true});

  //mdSetup(plugin)
  //projectSetup(plugin)
  //linkSetup(plugin)
  //restSetup(plugin)
  //cmdSetup(plugin)
  //tplSetup(plugin)

  //plugin.registerCommand("GotoFirstChar", gotoFirstChar, {sync: false})
};

module.exports = setup
