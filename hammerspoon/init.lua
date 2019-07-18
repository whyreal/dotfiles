------------------------
--  系统级 vim 按键绑定  --
------------------------
vim = hs.loadSpoon('VimMode')
-- Basic key binding to ctrl+;
-- You can choose any key binding you want here, see:
--   https://www.hammerspoon.org/docs/hs.hotkey.html#bind
hs.hotkey.bind({'ctrl'}, ';', function()
  vim:enter()
end)
--vim:disableForApp('MacVim')
--vim:disableForApp('Terminal')

------------------------
--   点击 ctrl 映射为 ESC, 长按不受影响  --
------------------------
-- Load Hammerspoon bits from https://github.com/jasonrudolph/ControlEscape.spoon
hs.loadSpoon('ControlEscape'):start()

require('keyboard') -- Load Hammerspoon bits from https://github.com/jasonrudolph/keyboard
