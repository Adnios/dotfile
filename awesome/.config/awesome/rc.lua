-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

local lain = require("lain")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- require("awesome-remember-geometry")

-- https://github.com/guotsuan/eminent.git
-- require("eminent")
-- https://github.com/guotsuan/awesome-revelation
-- local revelation=require("awesome-revelation")

-- screen
local xrandr = require("xrandr")
local foggy = require('foggy')

---{{{ auto start
Autorun = true
AutorunApps =
{
  "nm-applet --sm-disable &",
  "blueman-applet &",
  "bash $HOME/.config/i3/bin/keyboard-change",
  "/mnt/d/temp/GitHub/software/electron-ssr-0.2.6.AppImage",
  "picom &";
  -- "redshift";
  "bash $HOME/.config/awesome/suspend"
  -- "xautolock -time 30 -locker lock &"
}

if Autorun then
  for app = 1, #AutorunApps do
    awful.util.spawn_with_shell(AutorunApps[app])
  end
end
---}}}

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
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
-- my
-- beautiful.init(gears.filesystem.get_themes_dir() .. "zenburn/theme.lua")
-- beautiful.init(gears.filesystem.get_themes_dir() .. "xresources/theme.lua")
beautiful.init("~/.config/awesome/theme/zenburn/theme.lua")
-- revelation.init()

-- This is used later as the default terminal and editor to run.
terminal = "wezterm"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    -- awful.layout.suit.floating,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   {"screen", function () foggy.menu(s) end},
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
   {"poweroff",terminal .. " -e  poweroff"},
   {"reboot",terminal .. " -e  reboot"}
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
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
                    awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(-1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)
    awful.tag({ "1 😍 ", "2 😄 ", "3 😫 ", "4 🎉 ", "5 ❤️ ", "6  😮 ", "7 😃 ", "8 😎 ", "9 ⛽ "}, s,awful.layout.layouts[1])
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- 创建一个cpu监控小部件
    local cpu = lain.widget.cpu {
      settings = function()
        widget:set_markup("⛺️CPU:" .. cpu_now.usage .. "% ")
      end
    }
    local mem = lain.widget.mem({
        settings = function()
            widget:set_markup(("📝MEM:".. mem_now.used .. "MB "))
        end
    })
    -- 声音
    local volume = lain.widget.alsa({
        settings = function()
            vlevel  = volume_now.level
            if volume_now.status == "off" then
                -- vlevel = "% 🔇 "
                vlevel = "%  "
            else
                vlevel = "% "
                -- vlevel = vlevel .. "% "
            end
            widget:set_markup(" " .. vlevel )
            -- widget:set_markup("🔊Vol:" .. vlevel )
        end
    })

    local time = lain.widget.bat({
        settings = function()
          widget:set_markup(" ⏰")
        end
    })
    --  创建电池小部件
    local mybattery = lain.widget.bat {
      timeout = 5,
      settings = function()
        widget:set_markup(" 🔋" .. bat_now.perc)
        batstat = bat_now
      end
    }

    local mybattery_t = awful.tooltip {
      objects = { mybattery.widget },
      timer_function = function()
        local msg = ""
        for i = 1, #batstat.n_status do
          msg = msg .. lain.util.markup.font("monospace 10",
            string.format("┌[Battery %d]\n├Status:\t%s\n└Percentage:\t%s\n\n",
            i-1, batstat.n_status[i], batstat.n_perc[i]))
        end
        return msg .. lain.util.markup.font("monospace 10", "Time left:\t" .. batstat.time)
      end
    }

    -- local net = require("awesome-wm-widgets.net-speed-widget.net-speed")
    -- local batteryarc_widget = require("awesome-wm-widgets.batteryarc-widget.batteryarc")
    local brightness_widget = require("awesome-wm-widgets.brightness-widget.brightness")
    local volume_widget = require('awesome-wm-widgets.volume-widget.volume')
    local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")
    local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")
    mytextclock = wibox.widget.textclock()
    local cw = calendar_widget({
        theme = 'outrun',
        placement = 'top_right',
        radius = 8
    })
    mytextclock:connect_signal("button::press",
        function(_, _, _, button)
            if button == 1 then cw.toggle() end
        end)

    -- Create a custom bar textbox widget
    s.mybarbox = wibox.widget.textbox()

    -- Spawn bar info
    local bar_path = "/home/wmoore/Projects/bar/target/release/bar -a -w"
    awful.spawn.with_line_callback(bar_path, {
        stdout = function(line)
            s.mybarbox.markup = line
        end,
        stderr = function(line)
            naughty.notify { text = "ERR: "..line }
        end
    })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            -- mykeyboardlayout,
            mybattery,
            time,
            mytextclock,
            cpu,
            cpu_widget({
              width = 20,
              step_width = 2,
              step_spacing = 0,
              color = '#ffffff'
            }),
            mem,
            volume_widget{
              type = 'arc'
            },
            volume,
            brightness_widget{
              type = 'icon_and_text',
              -- program = 'xbacklight',
              program = 'light',
              step = 5
            },
            -- mytemp,
            -- bat,
            -- batteryarc_widget({
            --   show_current_level = true,
            --   arc_thickness = 2
            -- }),
            -- net(),
            s.mybarbox,
            wibox.widget.systray(),
            s.mylayoutbox,
        },
    }
end)
-- }}}


-- {{{ Mouse bindings
-- when the mouse in edge, switch tags
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 5, awful.tag.viewnext),
    awful.button({ }, 4, awful.tag.viewprev)
))
-- }}}

local brightness_widget = require("awesome-wm-widgets.brightness-widget.brightness")
-- {{{ Key bindings
globalkeys = gears.table.join(
    -- my keybinding
    -- revelation
    -- awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    -- awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    -- awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
    -- awful.key({ modkey,           }, "e",      revelation),
    -- awful.key({ modkey,           }, "j",
    -- function ()
    --     awful.client.focus.byidx( 1)
    --     if client.focus then client.focus:raise() end
    -- end),
    -- 降低屏幕亮度
    awful.key({""}, "XF86MonBrightnessUp", function () brightness_widget:inc() end, {description = "increase brightness", group = "custom"}),
    awful.key({""}, "XF86MonBrightnessDown", function () brightness_widget:dec() end, {description = "decrease brightness", group = "custom"}),
    awful.key({""}, "XF86AudioMicMute",
    function ()
      awful.util.spawn("amixer set Capture toggle")
    end
    ),
    awful.key({""},"XF86AudioMute",
    function()
      awful.util.spawn("pamixer --toggle-mute")
    end),
    awful.key({""},"XF86AudioRaiseVolume",
    function()
      awful.util.spawn("pamixer --increase 5")
    end),
    awful.key({""},"XF86AudioLowerVolume",
    function()
      awful.util.spawn("pamixer --decrease 5")
    end),
    -- 截屏
    awful.key({modkey, "Control"},"a",
      function()
        awful.util.spawn("flameshot gui")
      end),
    -- rofi
    awful.key({modkey}, ";",
    function (  )
      -- io.popen("rofi -show drun")
      io.popen("rofi -combi-modi drun,run,ssh -mesg -show combi -modi combi")
    end),
    awful.key({modkey}, "'",
    function (  )
      -- io.popen("rofi -show drun")
      io.popen("rofi -show filebrowser")
    end),
    awful.key({modkey}, "/",
    function (  )
      -- io.popen("rofi -show drun")
      io.popen("rofi-bluetooth")
    end),
    -- use rofi to run scrcpy and sndcpy
    -- awful.key({modkey}, "]",
    --   function ()
    --     awful.util.spawn("scrcpy")
    --   end
    -- ),
    -- awful.key({modkey, "Shift"}, "]",
    --   function ()
    --     awful.util.spawn("kitty --dump-commands sndcpy")
    --   end
    -- ),

    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "p",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "n",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "b", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    -- refactor
    -- awful.key({ modkey, "Shift"   }, "j",
    --     function ()
    --       awful.client.swap.byidx(1)
    --       awful.client.focus.byidx(-1)
    --     end,
    --     {description = "swap with next client by index", group = "client"}),
    -- awful.key({ modkey, "Shift"   }, "k",
    --     function ()
    --       awful.client.swap.byidx(-1)
    --       awful.client.focus.byidx(1)
    --     end,
    --     {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
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
    -- screen
    awful.key({modkey, "Shift"}, "p", function() xrandr.xrandr() end),
    awful.key({modkey, "Control"}, "p", foggy.menu),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

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
    -- Menubar using rofi
    -- awful.key({ modkey }, "p", function() menubar.show() end,
    --           {description = "show the menubar", group = "launcher"})

)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey,           }, "q",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    -- awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
    --           {description = "move to master", group = "client"}),
    -- personal config
    -- awful.key({ modkey, "Shift" }, "Return", function (c) awful.client.setslave(c) end,
    --           {description = "move to slave", group = "client"}),
    awful.key({ modkey, "Control" }, "Return",
        function (c)
            if c ~= awful.client.getmaster() then
                c:swap(awful.client.getmaster())
            else
                awful.client.setslave(c)
            end
        end,
        {description = "switch slave and master", group = "client"}),

    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey, "Shift" }, "n",
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
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
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
                  {description = "move focused client to tag #"..i, group = "tag"}),
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
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
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
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    -- awful.titlebar(c) : setup {
    -- change height
    awful.titlebar(c, {size=15}) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            -- buttons = buttons,
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            layout  = wibox.layout.fixed.horizontal()
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}


-- 窗口圆角
-- client.connect_signal("manage", function (c)
--  c.shape = function(cr,w,h)
--    gears.shape.rounded_rect(cr,w,h,10)
--  end
-- end)

-- 窗口规则
---- 内边框
beautiful.useless_gap = 2
beautiful.gap_single_client = true
-- No borders if only one tiled client
screen.connect_signal("arrange", function (s)
    -- bug 在tag上右击，tag为空时，selected_tag报错
    local max = s.selected_tag.layout.name == "max"
    local only_one = #s.tiled_clients == 1 -- use tiled_clients so that other floating windows don't affect the count
    -- but iterate over clients instead of tiled_clients as tiled_clients doesn't include maximized windows
    for _, c in pairs(s.clients) do
        if (max or only_one) and not c.floating or c.maximized or c.class == 'Wine' then
        -- c.class == 'Wine' or c.instance == 'tim.exe'
        -- if (only_one) and not c.floating or c.maximized or c.class == 'Wine' then
            c.border_width = 0
        else
            c.border_width = beautiful.border_width
        end
    end
end)

-- {{{ Rules
-- move Rules section to below to make it work well
-- https://github.com/lilydjwg/myawesomerc/blob/master/rc.lua
local old_filter = awful.client.focus.filter
function myfocus_filter(c)
  if old_filter(c) then
    -- TM.exe completion pop-up windows
    if (c.instance == 'tim.exe' or c.instance == 'TIM.exe')
        and c.above and c.skip_taskbar
        and (c.type == 'normal' or c.type == 'dialog') -- dialog type is for tooltip windows
        and (c.class == 'qq.exe' or c.class == 'QQ.exe' or c.class == 'TIM.exe') then
        return nil
    -- This works with tooltips and some popup-menus
    elseif c.class == 'Wine' and c.above == true then
        return nil
    elseif c.class == 'WeChat.exe' and (
        c.name == 'CMenuWnd' or not c.name
        or c.name == 'SessionChatRoomDetailWnd'
        ) then -- 微信菜单
        c.border_width = 0
        do return nil end
    elseif (c.class == 'Wine' or c.class == 'QQ.exe' or c.class == 'qq.exe')
      and c.type == 'dialog'
      and c.skip_taskbar == true
      and c.size_hints.max_width and c.size_hints.max_width < 160
      then
      -- for popup item menus of Photoshop CS5
      return nil
    elseif c.class == 'TelegramDesktop' and c.above == true and c.name == 'Media viewer' then
      -- Telegram media preview (https://t.me/archlinuxcn_group/1823691)
      c.fullscreen = true
      return c
    elseif c.class == 'TelegramDesktop' and c.above == true then
      -- Telegram picture-in-picture
      c.border_width = 0
      return c
    elseif c.skip_taskbar and c.instance == 'Popup' and c.class == 'Firefox' then
      -- popups for Settings page in Firefox
      return nil
    elseif c.class == 'Key-mon' then
      return nil
    else
      return c
    end
  end
end
awful.client.focus.filter = myfocus_filter


-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     -- focus = awful.client.focus.filter,
                     focus = myfocus_filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          -- add
          "scrcpy",
          -- "wechat.exe",
          -- "tim.exe",
          -- "Wine",
          -- end
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    { rule = { class = "scrcpy" },
      properties = { screen = 1, tag = "7 😃 " } },
    { rule = { class = "netease-cloud-music" },
      properties = {
        screen = 1, tag = "7 😃 ",
        titlebars_enabled = false
      }
    },

    { rule_any = {
      instance = {
          'qq.exe', 'QQ.exe', 'TIM.exe', 'tim.exe',
          "Nautilus",
          "telegram",
          'QQExternal.exe', -- QQ 截图
          'deepin-music-player',
          'wechat.exe', 'wechatupdate.exe',
          "megasync", "kruler",
        },
      },
      properties = {
        -- This, together with myfocus_filter, make the popup menus flicker taskbars less
        -- Non-focusable menus may cause TM2013preview1 to not highlight menu
        -- items on hover and crash.
        -- Also for deepin-music, removing borders and floating pop-ups
        focusable = true,
        floating = true,
        titlebars_enabled = false,
        border_width = 0,
      }
    },
    { rule = {
      class = "Wine",
      skip_taskbar = true,
      type = "dialog",
    },
    callback = function (c)
      if c.size_hints.max_width and c.size_hints.max_width < 160 then
        -- for popup item menus of Photoshop CS5
        c.border_width = 0
      end
    end,
    },

    -- jetbrains
    -- { rule = {
    --     class = "jetbrains-.*",
    --     instance = "sun-awt-X11-XWindowPeer",
    --     name = "win.*"
    --   },
    --   properties = {
    --       floating = true,
    --       focus = true,
    --       focusable = false,
    --       ontop = true,
    --       placement = awful.placement.restore,
    --       buttons = {}
    --   }},
}
-- }}}
