import { NvimPlugin } from "neovim";

module.exports = (plugin: NvimPlugin) => {
    plugin.setOptions({dev: false});

    plugin.registerCommand('EchoMessage', async () => {
        try {
            await plugin.nvim.outWrite('Dayman (ah-ah-ah) \n');
        } catch (err) {
            console.error(err);
        }
    }, {sync: false});

    plugin.registerFunction('SetLines', async () => {
        await plugin.nvim.setLine('May I offer you an egg in these troubling times');
        return console.log('Line should be set');
    }, {sync: false})
  
    //plugin.registerAutocmd('BufEnter', async (fileName) => {
    //await plugin.nvim.buffer.append('BufEnter for a JS File?')
    //}, {sync: false, pattern: '*.js', eval: 'expand("<afile>")'})

    plugin.registerCommand("GotoFirstChar", async () => {
        const l = await plugin.nvim.line
        const c = await plugin.nvim.window.cursor
        const fc = l.search(/[^\s]/)

        if (c[1] == fc) {
            plugin.nvim.window.cursor = [c[0], 0]
        } else {
            plugin.nvim.window.cursor = [c[0], fc]
        }
    });

};
