--   █████╗ ██╗    ██╗███████╗███████╗ ██████╗ ███╗   ███╗███████╗██╗    ██╗███╗   ███╗
--  ██╔══██╗██║    ██║██╔════╝██╔════╝██╔═══██╗████╗ ████║██╔════╝██║    ██║████╗ ████║
--  ███████║██║ █╗ ██║█████╗  ███████╗██║   ██║██╔████╔██║█████╗  ██║ █╗ ██║██╔████╔██║
--  ██╔══██║██║███╗██║██╔══╝  ╚════██║██║   ██║██║╚██╔╝██║██╔══╝  ██║███╗██║██║╚██╔╝██║
--  ██║  ██║╚███╔███╔╝███████╗███████║╚██████╔╝██║ ╚═╝ ██║███████╗╚███╔███╔╝██║ ╚═╝ ██║
--  ╚═╝  ╚═╝ ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝ ╚══╝╚══╝ ╚═╝     ╚═╝
--[[
     Awesome WM configuration
     github.com/kaixili
--]]
--------------------------------------------------------------------------------

-- {{{ Required libraries
local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag
local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type

local gears         = require("gears")
local awful         = require("awful")
                      require("awful.autofocus")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
--local menubar       = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget                      
require("awful.hotkeys_popup.keys") 
local my_table      = awful.util.table or gears.table -- 4.{0,1} compatibility

local lain          = require("lain")
-- local tyrannical    = require("tyrannical")
-- local freedesktop   = require("freedesktop")
-- }}}

-- Theme {{{
local themes = {
    "multicolor", -- 1 --
    "manta",
}
local chosen_theme = themes[1]
beautiful.init(string.format(gears.filesystem.get_configuration_dir() .. "/themes/%s/theme.lua", chosen_theme))

local theme_name = themes[2]
local theme_dir = os.getenv("HOME") .. "/.config/awesome/themes/"
beautiful.init( theme_dir .. theme_name .. "/theme.lua" )

local helpers = require("helpers")
local bars = require("bars")
-- local keys = require("keys")
local titlebars = require("titlebars")
-- }}}
--


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
            title = "Oops, there were errors during startup!",
        text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                title = "Oops, an error happened!",
            text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Autostart windowless processes

-- This function will run once every time Awesome is started
local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
    end
end

run_once({
        -- 窗口渲染器
        "compton &", 
        -- 打字避免触摸板滑动
        --    "syndaemon -i 0.5 -t -K -R -d",
        -- 隐藏鼠标
        "unclutter -root",
        -- 网络管理
        --    "nm-applet --sm-disable &",
        -- Chrome 加快启动速度
        "google-chrome-stable --no-startup-window &",
        -- 输入法
        "fcitx &",
        "flameshot &"
    })
--]]

-- }}}

-- {{{ Variable definitions

local modkey       = "Mod4"
local altkey       = "Mod1"
local terminal     = "konsole" or "urxvtc" or "xterm"
local editor       = os.getenv("EDITOR") or "vim" or "nano"
local gui_editor   = terminal .. "-e vim" or "subl3"
local guieditor    = gui_editor
local browser      = "google-chrome-stable"
local screenlocker = "i3lock-fancy -f Press-Start-2P -p --"
-- local screenshot   = "scrot -s ~/tmp/`date +'%Y-%m-%dT%H:%M:%S'`.png"
local screenshot   = "flameshot gui"
local tabview      = "rofi -show window"
local runview      = "rofi -show run"


awful.util.terminal = terminal
awful.util.tagnames = { '', '[2:Web]', '[3:Term]', '[4]' ,'[5:Music]', '[6:Other]' }
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.max,
    --awful.layout.suit.tile.left,
    --awful.layout.suit.tile.bottom,
    --awful.layout.suit.tile.top,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.corner.nw,
    --awful.layout.suit.corner.ne,
    --awful.layout.suit.corner.sw,
    --awful.layout.suit.corner.se,
    --lain.layout.cascade,
    --lain.layout.cascade.tile,
    --lain.layout.centerwork,
    --lain.layout.centerwork.horizontal,
    --lain.layout.termfair,
    --lain.layout.termfair.center,
}

awful.util.taglist_buttons = my_table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
    )

awful.util.tasklist_buttons = awful.util.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            -- Without this, the following
            -- :isvisible() makes no sense
            c.minimized = false
            if not c:isvisible() and c.first_tag then
                c.first_tag:view_only()
            end
            -- This will also un-minimize
            -- the client, if needed
            client.focus = c
            c:raise()
        end
    end),
    awful.button({ }, 3, function ()
        if instance then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ width=250 })
        end
    end),
    awful.button({ }, 4, function ()
        awful.client.focus.byidx(1)
        if client.focus then client.focus:raise() end
    end),
    awful.button({ }, 5, function ()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end))

    -- awful.util.tasklist_buttons = my_table.join(
    --     awful.button({ }, 1, function (c)
    --         if c == client.focus then
    --             c.minimized = true
    --         else
    --             c:emit_signal("request::activate", "tasklist", {raise = true})
    --         end
    --     end),
    --     awful.button({ }, 3, function ()
    --         local instance = nil

    --         return function ()
    --             if instance and instance.wibox.visible then
    --                 instance:hide()
    --                 instance = nil
    --             else
    --                 instance = awful.menu.clients({theme = {width = 250}})
    --             end
    --         end
    --     end),
    --     awful.button({ }, 4, function () awful.client.focus.byidx(1) end),
    --     awful.button({ }, 5, function () awful.client.focus.byidx(-1) end)
    -- )

    -- lain layout
    lain.layout.termfair.nmaster           = 3
    lain.layout.termfair.ncol              = 1
    lain.layout.termfair.center.nmaster    = 3
    lain.layout.termfair.center.ncol       = 1
    lain.layout.cascade.tile.offset_x      = 2
    lain.layout.cascade.tile.offset_y      = 32
    lain.layout.cascade.tile.extra_padding = 5
    lain.layout.cascade.tile.nmaster       = 5
    lain.layout.cascade.tile.ncol          = 2

    -- naughty
    --
    naughty.config.defaults.timeout = 5
    naughty.config.defaults.screen = 1
    naughty.config.defaults.position = "top_right"
    naughty.config.defaults.margin = 8
    naughty.config.defaults.gap = 2
    naughty.config.defaults.ontop = true
    naughty.config.defaults.font = "xos4 Terminus 12"
    naughty.config.defaults.icon = nil
    naughty.config.defaults.icon_size = 40
    naughty.config.defaults.fg = beautiful.fg_tooltip
    naughty.config.defaults.bg = beautiful.bg_tooltip
    naughty.config.defaults.border_color = beautiful.border_tooltip


    -- }}}

-- {{{ Menu
-- local myawesomemenu = {
--     { "hotkeys", function() return false, hotkeys_popup.show_help end },
--     { "manual", terminal .. " -e man awesome" },
--     { "edit config", string.format("%s -e %s %s", terminal, editor, awesome.conffile) },
--     { "restart", awesome.restart },
--     { "quit", function() awesome.quit() end }
-- }
-- awful.util.mymainmenu = freedesktop.menu.build({
--     icon_size = beautiful.menu_height or 16,
--     before = {
--         { "Awesome", myawesomemenu, beautiful.awesome_icon },
--         -- other triads can be put here
--     },
--     after = {
--         { "Open terminal", terminal },
--         -- other triads can be put here
--     }
-- })
--menubar.utils.terminal = terminal -- Set the Menubar terminal for applications that require it
-- }}}

-- {{{ Screen
local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
        -- gears.wallpaper.centered(wallpaper, s, null, 1.1)
   end
end
 
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
    set_wallpaper(s)
end)
-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s) 
    -- Quake application
    s.quake = lain.util.quake({ app = awful.util.terminal })
    set_wallpaper(s)
    -- Tags
    awful.tag(awful.util.tagnames, s, awful.layout.layouts)
    if beautiful.at_screen_connect then
        beautiful.at_screen_connect(s) 
    end
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(my_table.join(
        -- awful.button({ }, 3, function () awful.util.mymainmenu:toggle() end),
        -- awful.button({ }, 4, awful.tag.viewnext),
        -- awful.button({ }, 5, awful.tag.viewprev)
    ))
-- }}}

-- {{{ Key bindings
globalkeys = my_table.join(
    -- Take a screenshot
    awful.key({ modkey,           }, "p", function() os.execute(screenshot) end,
        {description = "take a screenshot", group = "hotkeys"}),

    -- X screen locker
    awful.key({ modkey,         }, "F11", function () os.execute(screenlocker) end,
        {description = "lock screen", group = "hotkeys"}),

    -- Hotkeys
    awful.key({ modkey,           }, "/",      hotkeys_popup.show_help,
        {description = "show help", group="awesome"}),
    -- Tag browsing
    -- awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
    --           {description = "view previous", group = "tag"}),
    -- awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
    --           {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "`", awful.tag.history.restore,
        {description = "go back", group = "tag"}),

    -- Non-empty tag browsing
    awful.key({ modkey,           }, "Left", function () lain.util.tag_view_nonempty(-1) end,
        {description = "view  previous nonempty", group = "tag"}),
    awful.key({ modkey,           }, "Right", function () lain.util.tag_view_nonempty(1) end,
        {description = "view  previous nonempty", group = "tag"}),
    awful.key({ modkey,           }, "j", function () lain.util.tag_view_nonempty(-1) end,
        {description = "view  previous nonempty", group = "tag"}),
    awful.key({ modkey,           }, "k", function () lain.util.tag_view_nonempty(1) end,
        {description = "view  previous nonempty", group = "tag"}),

    -- Default client focus
    awful.key({ altkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
        ),
    awful.key({ altkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
        ),

    -- By direction client focus
    awful.key({ modkey }, "j",
        function()
            awful.client.focus.global_bydirection("down")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus down", group = "client"}),
    awful.key({ modkey }, "k",
        function()
            awful.client.focus.global_bydirection("up")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus up", group = "client"}),
    awful.key({ modkey }, "h",
        function()
            awful.client.focus.global_bydirection("left")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus left", group = "client"}),
    awful.key({ modkey }, "l",
        function()
            awful.client.focus.global_bydirection("right")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus right", group = "client"}),

    -- awful.key({ modkey,           }, "w", function () awful.util.mymainmenu:show() end,
    --           {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
        {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
        {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
        {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
        {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
        {description = "jump to urgent client", group = "client"}),
    awful.key({ altkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),
    awful.key({ modkey,           }, "Tab", function() os.execute("rofi -show window") end,
        {description = "jump to selected client", group = "client"}),
    awful.key({ modkey,           }, "`", function()  end,
        {description = "jump to selected client", group = "client"}),

    -- Show/Hide Wibox
    awful.key({ modkey }, "b", function ()
        for s in screen do
            s.mywibox.visible = not s.mywibox.visible
            if s.mybottomwibox then
                s.mybottomwibox.visible = not s.mybottomwibox.visible
            end
        end
    end,
    {description = "toggle wibox", group = "awesome"}),

-- On the fly useless gaps change
awful.key({ altkey, "Control" }, "+", function () lain.util.useless_gaps_resize(1) end,
    {description = "increment useless gaps", group = "tag"}),
awful.key({ altkey, "Control" }, "-", function () lain.util.useless_gaps_resize(-1) end,
    {description = "decrement useless gaps", group = "tag"}),

-- Dynamic tagging
awful.key({ modkey, "Shift" }, "n", 
    function ()  awful.tag.add("my new tag", {
                screen = screen.primary,
                layout = awful.layout.suit.max,
            })
    end,
    {description = "add new tag", group = "tag"}),
awful.key({ modkey, "Shift" }, "r", function () lain.util.rename_tag() end,
    {description = "rename tag", group = "tag"}),
awful.key({ modkey, "Shift" }, "Left", function () lain.util.move_tag(-1) end,
    {description = "move tag to the left", group = "tag"}),
awful.key({ modkey, "Shift" }, "Right", function () lain.util.move_tag(1) end,
    {description = "move tag to the right", group = "tag"}),
awful.key({ modkey, "Shift" }, "d", function () lain.util.delete_tag() end,
    {description = "delete tag", group = "tag"}),

-- Standard program
awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
    {description = "open a terminal", group = "launcher"}),
awful.key({ modkey, "Control" }, "r", awesome.restart,
    {description = "reload awesome", group = "awesome"}),
awful.key({ modkey, "Control"   }, "q", awesome.quit,
    {description = "quit awesome", group = "awesome"}),

awful.key({ altkey, "Shift"   }, "l",     function () awful.tag.incmwfact( 0.05)          end,
    {description = "increase master width factor", group = "layout"}),
awful.key({ altkey, "Shift"   }, "h",     function () awful.tag.incmwfact(-0.05)          end,
    {description = "decrease master width factor", group = "layout"}),
awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
    {description = "increase the number of master clients", group = "layout"}),
awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
    {description = "decrease the number of master clients", group = "layout"}),
awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
    {description = "increase the number of columns", group = "layout"}),
awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
    {description = "decrease the number of columns", group = "layout"}),
awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
    {description = "select next", group = "layout"}),
awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
    {description = "select previous", group = "layout"}),

awful.key({ altkey,              }, ";",
    function ()
        local c = awful.client.restore()
        -- Focus restored client
        if c then
            client.focus = c
            c:raise()
        end
    end,
    {description = "restore minimized", group = "client"}),


-- Dropdown application
awful.key({ modkey, }, "z", function () awful.screen.focused().quake:toggle() end,
    {description = "dropdown application", group = "launcher"}),

-- Widgets popups
awful.key({ altkey, }, "c", function () lain.widget.calendar.show(7) end,
    {description = "show calendar", group = "widgets"}),
awful.key({ altkey, }, "h", function () if beautiful.fs then beautiful.fs.show(7) end end,
    {description = "show filesystem", group = "widgets"}),
awful.key({ altkey, }, "w", function () if beautiful.weather then beautiful.weather.show(7) end end,
    {description = "show weather", group = "widgets"}),

-- Brightness
awful.key({ }, "XF86MonBrightnessUp", function () os.execute("xbacklight -inc 8") end,
    {description = "+10%", group = "hotkeys"}),
awful.key({ }, "XF86MonBrightnessDown", function () os.execute("xbacklight -dec 8") end,
    {description = "-10%", group = "hotkeys"}),

-- ALSA volume control
awful.key({ altkey }, "Up",
    function ()
        os.execute("amixer -D pulse sset Master 2%+")
    end,
    {description = "volume up", group = "hotkeys"}),
awful.key({ altkey }, "Down",
    function ()
        os.execute("amixer -D pulse sset Master 2%-")
    end,
    {description = "volume down", group = "hotkeys"}),
awful.key({ altkey }, "m",
    function ()
        os.execute("amixer -D pulse sset Master toggle")
        --os.execute(string.format("amixer -q set %s toggle", beautiful.volume.togglechannel or beautiful.volume.channel))
    end,
    {description = "toggle mute", group = "hotkeys"}),
awful.key({ altkey, "Control" }, "0",
    function ()
        os.execute(string.format("amixer -q set %s 0%%", beautiful.volume.channel))
        beautiful.volume.update()
    end,
    {description = "volume 0%", group = "hotkeys"}),

-- MPD control
awful.key({ altkey, "Control" }, "Up",
    function ()
        os.execute("mpc toggle")
        beautiful.mpd.update()
    end,
    {description = "mpc toggle", group = "widgets"}),
awful.key({ altkey, "Control" }, "Down",
    function ()
        os.execute("mpc stop")
        beautiful.mpd.update()
    end,
    {description = "mpc stop", group = "widgets"}),
awful.key({ altkey, "Control" }, "Left",
    function ()
        os.execute("mpc prev")
        beautiful.mpd.update()
    end,
    {description = "mpc prev", group = "widgets"}),
awful.key({ altkey, "Control" }, "Right",
    function ()
        os.execute("mpc next")
        beautiful.mpd.update()
    end,
    {description = "mpc next", group = "widgets"}),
awful.key({ altkey }, "0",
    function ()
        local common = { text = "MPD widget ", position = "top_middle", timeout = 2 }
        if beautiful.mpd.timer.started then
            beautiful.mpd.timer:stop()
            common.text = common.text .. lain.util.markup.bold("OFF")
        else
            beautiful.mpd.timer:start()
            common.text = common.text .. lain.util.markup.bold("ON")
        end
        naughty.notify(common)
    end,
    {description = "mpc on/off", group = "widgets"}),

-- Copy primary to clipboard (terminals to gtk)
awful.key({ modkey }, "c", function () awful.spawn.with_shell("xsel | xsel -i -b") end,
    {description = "copy terminal to gtk", group = "hotkeys"}),
-- Copy clipboard to primary (gtk to terminals)
awful.key({ modkey }, "v", function () awful.spawn.with_shell("xsel -b | xsel") end,
    {description = "copy gtk to terminal", group = "hotkeys"}),

-- User programs
-- awful.key({ modkey }, "q", function () awful.spawn(browser) end,
--           {description = "run browser", group = "launcher"}),
-- awful.key({ modkey }, "a", function () awful.spawn(guieditor) end,
--           {description = "run gui editor", group = "launcher"}),

-- Default
--[[ Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"})
    --]]
--[[ dmenu
    awful.key({ modkey }, "x", function ()
            os.execute(string.format("dmenu_run -i -fn 'Monospace' -nb '%s' -nf '%s' -sb '%s' -sf '%s'",
            beautiful.bg_normal, beautiful.fg_normal, beautiful.bg_focus, beautiful.fg_focus))
        end,
        {description = "show dmenu", group = "launcher"})
    --]]
-- Prompt
awful.key({ modkey }, "r", function () os.execute(runview) end,
    {description = "run prompt", group = "launcher"}),
-- awful.key({ modkey }, "r", function () awful.screen.focused().mypromptbox:run() end,
--           {description = "run prompt", group = "launcher"}),


awful.key({ modkey }, "x",
    function ()
        awful.prompt.run {
            prompt       = "Run Lua code: ",
            textbox      = awful.screen.focused().mypromptbox.widget,
            exe_callback = awful.util.eval,
            history_path = awful.util.get_cache_dir() .. "/history_eval"
        }
    end,
    {description = "lua execute prompt", group = "awesome"})
--]]
)






clientkeys = my_table.join(

    awful.key({ altkey, "Shift"   }, "m",      lain.util.magnify_client,
        {description = "magnify client", group = "client"}),
    awful.key({ modkey,           }, ";",      lain.util.magnify_client,
        {description = "magnify client", group = "client"}),
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
        {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
        {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
        {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
        {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
        {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "maximize", group = "client"})
    )

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
    local descr_view, descr_toggle, descr_move, descr_toggle_focus
    if i == 1 or i == 9 then
        descr_view = {description = "view tag #", group = "tag"}
        descr_toggle = {description = "toggle tag #", group = "tag"}
        descr_move = {description = "move focused client to tag #", group = "tag"}
        descr_toggle_focus = {description = "toggle focused client on tag #", group = "tag"}
    end
    globalkeys = my_table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            descr_view),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            descr_toggle),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            descr_move),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            descr_toggle_focus)
        )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
    )

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- set client shapre rounded rect
    -- c.shape = gears.shape.rounded_rect
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end
    if awesome.startup and
        not c.size_hints.user_position
        and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end

    -- Hide titlebars if required by the theme
    if not beautiful.titlebars_enabled then
        awful.titlebar.hide(c, beautiful.titlebar_position)
    end

    -- If the layout is not floating, every floating client that appears is centered
    if awful.layout.get(mouse.screen) ~= awful.layout.suit.floating then
        awful.placement.centered(c,{honor_workarea=true})
    else
        -- If the layout is floating, and there is no other client visible, center it
        if #mouse.screen.clients == 1 then
            awful.placement.centered(c,{honor_workarea=true})
        end
    end
end)

if beautiful.border_radius ~= 0 then
    client.connect_signal("manage", function (c, startup)
        if not c.fullscreen then
            c.shape = helpers.rrect(beautiful.border_radius)
        end
    end)

    -- Make sure fullscreen clients do not have rounded corners
    client.connect_signal("property::fullscreen", function (c)
        if c.fullscreen then
            -- Use delayed_call in order to avoid flickering when corners
            -- change shape
            gears.timer.delayed_call(function()
                c.shape = helpers.rect()
            end)
        else
            c.shape = helpers.rrect(beautiful.border_radius)
        end
    end)

    beautiful.notification_shape = helpers.rrect(beautiful.notification_border_radius)
    beautiful.snap_shape = helpers.rrect(beautiful.border_radius * 2)
    beautiful.taglist_shape = helpers.rrect(beautiful.taglist_item_roundness)
end

-- Add a titlebar if titlebars_enabled is set to true in the rules.
-- client.connect_signal("request::titlebars", function(c)
--     -- Custom
--     if beautiful.titlebar_fun then
--         beautiful.titlebar_fun(c)
--         return
--     end
-- 
--     -- Default
--     -- buttons for the titlebar
--     local buttons = my_table.join(
--         awful.button({ }, 1, function()
--             c:emit_signal("request::activate", "titlebar", {raise = true})
--             awful.mouse.client.move(c)
--         end),
--         awful.button({ }, 3, function()
--             c:emit_signal("request::activate", "titlebar", {raise = true})
--             awful.mouse.client.resize(c)
--         end)
--         )
-- 
--     awful.titlebar(c, {size = 16}) : setup {
--         { -- Left
--             awful.titlebar.widget.iconwidget(c),
--             buttons = buttons,
--             layout  = wibox.layout.fixed.horizontal
--         },
--         { -- Middle
--             { -- Title
--                 align  = "center",
--                 widget = awful.titlebar.widget.titlewidget(c)
--             },
--             buttons = buttons,
--             layout  = wibox.layout.flex.horizontal
--         },
--         { -- Right
--             awful.titlebar.widget.floatingbutton (c),
--             awful.titlebar.widget.maximizedbutton(c),
--             awful.titlebar.widget.stickybutton   (c),
--             awful.titlebar.widget.ontopbutton    (c),
--             awful.titlebar.widget.closebutton    (c),
--             layout = wibox.layout.fixed.horizontal()
--         },
--         layout = wibox.layout.align.horizontal
--     }
-- end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    --c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

-- No border for maximized clients
function border_adjust(c)
    if c.maximized then -- no borders if only 1 client visible
        c.border_width = 0
    elseif #awful.screen.focused().clients > 1 then
        c.border_width = beautiful.border_width
        c.border_color = beautiful.border_focus
    end
end

client.connect_signal("property::maximized", border_adjust)
client.connect_signal("focus", border_adjust)
client.connect_signal("manage", border_adjust)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- client.connect_signal("unfocus", function(c) c.border_width = 0 end)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
        properties = { border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen,
            size_hints_honor = false
        }
    },

    -- Floating clients
    { rule_any = {
            instance = {
                "DTA",  -- Firefox addon DownThemAll.
            },
            class = {
            },

            name = {
                "Event Tester",  -- xev
            },
            role = {
                "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
            }
    }, properties = { floating = true, ontop = false }},

    -- Set Firefox to always map on the first tag on screen 1.
    --{ rule = { class = "Firefox" },
    --  properties = { tag = awful.util.tagnames[2] } },

    -- Titlebars
    { rule_any = { type = { "dialog", "normal" } },
    properties = { titlebars_enabled = true } },

    -- Centered clients
    { rule_any = {
            type = {
                "dialog",
            },
            class = {
                "feh",
            },
            name = {
                "Save As",
            },
            role = {
                "GtkFileChooserDialog",
            }
        }, properties = {},
        callback = function (c)
            awful.placement.centered(c,{honor_workarea=true})
        end
    },

    -- Hidden regardless of the theme setting
    { rule_any = {
        class = {
          "qutebrowser",
          "feh",
          "Gimp",
          "Sublime_text",
          "Google-chrome",
          --"discord",
          --"TelegramDesktop",
          "Firefox",
          "Chromium-browser",
          "Rofi",
          },
      }, properties = {},
      callback = function (c)
        if not beautiful.titlebars_imitate_borders then
            awful.titlebar.hide(c, beautiful.titlebar_position)
        end
      end
    },

}
-- }}}

-- {{{ Addon@ Tyrannical: Dynamic Tags
--tyrannical.tags = {
--    { 
--        name        = " ",                 -- Call the tag "Term"
--        init        = true,                   -- Load the tag on startup
--        exclusive   = true,                   -- Refuse any other type of clients (by classes)
--        -- screen      = {1,2},                  -- Create this tag on screen 1 and screen 2
--        screen      = 1,                  -- Create this tag on screen 1 and screen 2
--        layout      = awful.layout.suit.floating, -- Use the tile layout
--        instance    = {"dev", "ops"},         -- Accept the following instances. This takes precedence over 'class'
--        class       = { --Accept the following classes, refuse everything else (because of "exclusive=true")
--            "xterm" ,
--            "urxvt" ,
--            "aterm",
--            "URxvt",
--            "XTerm",
--            "konsole",
--            "terminator",
--            "gnome-terminal"
--        }
--    } ,
--    {
--        name        = " ",
--        init        = true,
--        exclusive   = true,
--        --icon        = "~net.png",                 -- Use this icon for the tag (uncomment with a real path)
--        screen      = { 1, 2 },
--        layout      = awful.layout.suit.tile,      -- Use the max layout
--        class = {
--            "Opera",
--            "Firefox",
--            "Rekonq",
--            "Dillo",
--            "Arora",
--            "Chromium",
--            "nightly",
--            "minefield",
--            "Google-chrome",
--    }
--    } ,
--
--    {
--        name        = " ",
--        init        = true,
--        exclusive   = false,
--        screen      = 1,
--        layout      = awful.layout.suit.max                          ,
--        class ={
--        "Kate", "KDevelop", "Codeblocks", "Code::Blocks" , "DDD", "kate4"}
--    } ,
--    {
--        name        = "Doc",
--        init        = false, -- This tag wont be created at startup, but will be when one of the
--        -- client in the "class" section will start. It will be created on
--        -- the client startup screen
--        exclusive   = true,
--        layout      = awful.layout.suit.tile,
--        class       = {
--            "Assistant"     , "Okular"         , "Evince"    , "EPDFviewer"   , "xpdf",
--        "Xpdf"          ,                                        }
--    } ,
--    {
--        name        = " ",
--        init        = true,
--        exclusive   = false,
--        screen      = 1,
--        layout      = awful.layout.suit.tile,
--        exec_once   = {"dolphin"}, --When the tag is accessed for the first time, execute this command
--        class  = {
--            "Thunar", "Konqueror", "Dolphin", "ark", "Nautilus","emelfm"
--        }
--    } ,
--
--}
--
---- Ignore the tag "exclusive" property for the following clients (matched by classes)
--tyrannical.properties.intrusive = {
--    "ksnapshot"     , "pinentry"       , "gtksu"     , "kcalc"        , "xcalc"               ,
--    "feh"           , "Gradient editor", "About KDE" , "Paste Special", "Background color"    ,
--    "kcolorchooser" , "plasmoidviewer" , "Xephyr"    , "kruler"       , "plasmaengineexplorer",
--    "QuakeDD"       ,
--}
--
---- Ignore the tiled layout for the matching clients
--tyrannical.properties.floating = {
--    "MPlayer"      , "pinentry"        , "ksnapshot"  , "pinentry"     , "gtksu"          ,
--    "xine"         , "feh"             , "kmix"       , "kcalc"        , "xcalc"          ,
--    "yakuake"      , "Select Color$"   , "kruler"     , "kcolorchooser", "Paste Special"  ,
--    "New Form"     , "Insert Picture"  , "kcharselect", "mythfrontend" , "plasmoidviewer"
--}
--
---- Make the matching clients (by classes) on top of the default layout
--tyrannical.properties.ontop = {
--    "Xephyr"       , "ksnapshot"       , "kruler"
--}
--
---- Force the matching clients (by classes) to be centered on the screen on init
--tyrannical.properties.placement = {
--    kcalc = awful.placement.centered
--}
--
--tyrannical.settings.block_children_focus_stealing = true --Block popups ()
--tyrannical.settings.group_children = true --Force popups/dialogs to have the same tags as the parent client

-- }}}

--  vim:foldmethod=marker:foldlevel=0:filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
