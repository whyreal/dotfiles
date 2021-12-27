-- Specify Spoons which will be loaded
_G.hspoon_list = {
    "AClock",
    "BingDaily",
    -- "Calendar",
    "CircleClock",
    "ClipShow",
    "CountDown",
    "FnMate",
    "HCalendar",
    "HSaria2",
    "HSearch",
    -- "KSheet",
    "SpeedMenu",
    -- "TimeFlow",
    -- "UnsplashZ",
    "WinWin",
}

-- appM environment keybindings. Bundle `id` is prefered, but application `name` will be ok.
_G.hsapp_list = {
    {key = 'a', name = 'Atom'},
    {key = 'c', id = 'com.google.Chrome'},
    {key = 'd', name = 'ShadowsocksX'},
    {key = 'e', name = 'Emacs'},
    {key = 'f', name = 'Finder'},
    {key = 'i', name = 'iTerm'},
    {key = 'k', name = 'KeyCastr'},
    {key = 'l', name = 'Sublime Text'},
    {key = 'm', name = 'MacVim'},
    {key = 'o', name = 'LibreOffice'},
    {key = 'p', name = 'mpv'},
    {key = 'r', name = 'VimR'},
    {key = 's', name = 'Safari'},
    {key = 't', name = 'Terminal'},
    {key = 'v', id = 'com.apple.ActivityMonitor'},
    {key = 'w', name = 'Mweb'},
    {key = 'y', id = 'com.apple.systempreferences'},
}

-- Modal supervisor keybinding, which can be used to temporarily disable ALL modal environments.
_G.hsupervisor_keys = {{"cmd", "shift", "ctrl"}, "Q"}

-- Reload Hammerspoon configuration
_G.hsreload_keys = {{"cmd", "shift", "ctrl"}, "R"}

-- Toggle help panel of this configuration.
_G.hshelp_keys = {{"alt", "shift"}, "/"}

-- aria2 RPC host address
_G.hsaria2_host = "http://localhost:6800/jsonrpc"
-- aria2 RPC host secret
_G.hsaria2_secret = "token"

----------------------------------------------------------------------------------------------------
-- Those keybindings below could be disabled by setting to {"", ""} or {{}, ""}

-- Window hints keybinding: Focuse to any window you want
_G.hswhints_keys = {"alt", "tab"}

-- appM environment keybinding: Application Launcher
_G.hsappM_keys = {"alt", "A"}

-- clipshowM environment keybinding: System clipboard reader
_G.hsclipsM_keys = {"alt", "C"}

-- Toggle the display of aria2 frontend
_G.hsaria2_keys = {"alt", "D"}

-- Launch Hammerspoon Search
_G.hsearch_keys = {"alt", "G"}

-- Read Hammerspoon and Spoons API manual in default browser
_G.hsman_keys = {"alt", "H"}

-- countdownM environment keybinding: Visual countdown
_G.hscountdM_keys = {"alt", "I"}

-- Lock computer's screen
_G.hslock_keys = {"alt", "L"}

-- resizeM environment keybinding: Windows manipulation
_G.hsresizeM_keys = {"alt", "R"}

-- cheatsheetM environment keybinding: Cheatsheet copycat
_G.hscheats_keys = {"alt", "S"}

-- Show digital clock above all windows
_G.hsaclock_keys = {"alt", "T"}

-- Type the URL and title of the frontmost web page open in Google Chrome or Safari.
_G.hstype_keys = {"alt", "V"}

-- Toggle Hammerspoon console
_G.hsconsole_keys = {"alt", "Z"}
