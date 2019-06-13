; vim:ft=dosini

; -------------------------------------------------------------------- # Theme #

[colors]
black   = #D8DEE9
blue    = #81A1C1
green   = #A3BE8C
greya   = #a0a1a7
grey    = #434C5E
red     = #BF616A
white   = #2E3440
yellow  = #EBCB8B

; ------------------------------------------------------------- # Bar (common) #

[section/bar]
font-0 = SpaceMonoNL:pixelsize=12;3
font-1 = FontAwesome5FreeSolid:pixelsize=12;3
font-2 = DEATH_DEFY:pixelsize=20;5
background = ${colors.white}
foreground = ${colors.black}
cursor-click = pointer
height = 32
module-margin-left  = 1
module-margin-right = 1
padding-left  = 1
padding-right = 1
radius = 0
monitor = eDP-1

; ---------------------------------------------------------------- # Bar (top) #

[bar/top]
inherit = section/bar
modules-left    = mpd
modules-center  = date
modules-right   = github transmission

; ------------------------------------------------------------- # Bar (bottom) #

[bar/bottom]
inherit = section/bar
bottom = true
modules-left = battery cpu memory temperature filesystem volume xkeyboard
modules-center = title
modules-right = eth-down eth-up eth wlan-down wlan-up wlan-signal wlan

; ---------------------------------------------------------------------- # MPD #

[module/mpd]
type = internal/mpd
host = /run/user/$UID/mpd.sock
interval = 1
label-song = / %artist% / %title:0:50%
format-online = <icon-prev> <toggle> <icon-stop> <icon-next>  <icon-random> <icon-single> <icon-repeat> <label-song> 
icon-prev      = 
icon-stop      = 
icon-play      = 
icon-pause     = 
icon-next      = 
icon-random    = 
icon-single = 
icon-repeat    = 
icon-prev-foreground  = ${colors.grey}
icon-stop-foreground  = ${colors.grey}
icon-play-foreground  = ${colors.grey}
icon-pause-foreground = ${colors.blue}
icon-next-foreground  = ${colors.grey}
label-song-foreground = ${colors.white}
toggle-off-foreground = ${colors.grey}
toggle-on-foreground  = ${colors.black}

; ----------------------------------------------------------------- # Datetime #

[module/date]
type = internal/date
interval = 5
date =
time = %H:%M
date-alt = %A %B %e
time-alt =
label = %date%%time%
label-font = 3
label-foreground = ${colors.black}
format-prefix = "- "
format-prefix-font = 3
format-prefix-foreground = ${colors.grey}
format-suffix = " -"
format-suffix-font = 3
format-suffix-foreground = ${colors.grey}

; ------------------------------------------------------------------- # GitHub #

[module/github]
type = internal/github
token = ${file:~/.github.token}
empty-notifications = false
interval = 5
label  = %notifications:2% 
format = <label>
format-foreground = ${colors.blue}

; ------------------------------------------------------------- # Transmission #

[module/transmission]
type = custom/script
exec = sed -e 's/\ */\n/g' /tmp/transmission | sed -ne 's/^Progress: \([0-9]*\)\.[0-9]*\%.*$/\1%/gw /dev/stdout' | tail -n 1
exec-if = [ -f /tmp/transmission ]
tail = true
label  = %output:3% 
format = <label>
format-foreground = ${colors.blue}

; ------------------------------------------------------------------ # Battery #

[module/battery]
type = internal/battery
adapter = AC
battery = BAT0
full-at = 99
poll-interval = 1
label-full =
label-charging  = %percentage:3%% 
format-charging-foreground = ${colors.yellow}
label-discharging  = %percentage:3%%
format-discharging = <label-discharging> <ramp-capacity>
format-discharging-foreground = ${colors.black}
ramp-capacity-0 = 
ramp-capacity-1 = 
ramp-capacity-2 = 
ramp-capacity-3 = 
ramp-capacity-4 = 
ramp-capacity-foreground = ${colors.black}

; ---------------------------------------------------------------------- # RAM #

[module/memory]
type = internal/memory
interval = 5
label = %percentage_used:2%% 
label-foreground = ${colors.black}

; ---------------------------------------------------------------------- # CPU #

[module/cpu]
type = internal/cpu
interval = 5
label = %percentage:2%% 
label-foreground = ${colors.black}

; -------------------------------------------------------------- # Temperature #

[module/temperature]
type = internal/temperature
interval = 1
thermal-zone = 10
warn-temperature = 80
label = %temperature-c:5%
format = <label> <ramp>
format-foreground = ${colors.black}
label-warn = %temperature-c:5%
format-warn = <label-warn> <ramp>
format-warn-foreground = ${colors.red}
ramp-0 = 
ramp-1 = 
ramp-2 = 
ramp-3 = 
ramp-4 = 
ramp-foreground = ${colors.black}

; ------------------------------------------------------------------ # Storage #

[module/filesystem]
type = internal/fs
interval = 60
mount-0 = /
label-mounted = %free:0:7% 
label-mounted-foreground = ${colors.black}

; -------------------------------------------------------------------- # Audio #

[module/volume]
type = internal/alsa
label-volume  = %percentage:0:3%% 
label-volume-foreground = ${colors.greya}
label-muted   = " --- "
label-muted-foreground = ${colors.greya}

; ---------------------------------------------------------- # Keyboard layout #

[module/xkeyboard]
type = internal/xkeyboard
blacklist-0  = caps lock
label-layout = %layout:2% 
label-layout-foreground = ${colors.greya}

; ------------------------------------------------------------- # Window title #

[module/title]
type = internal/xwindow
label-maxlen = 50
label-foreground = ${colors.black}

; ------------------------------------------------------------------ # Network #

[section/network]
type = internal/network
interval = 5
unknown-as-up = true
accumulate-stats = true
format-disconnected =
label-connected-foreground = ${colors.black}

[module/eth]
inherit = section/network
interface = eth0
label-connected = %local_ip% 

[module/eth-down]
inherit = section/network
interface = eth0
interval = 1
label-connected = %downspeed% 
label-connected-foreground = ${colors.blue}

[module/eth-up]
inherit = section/network
interface = eth0
interval = 1
label-connected = %upspeed% 
label-connected-foreground = ${colors.greya}

[module/wlan]
inherit = section/network
interface = wlp2s0
label-connected = %local_ip% 

[module/wlan-down]
inherit = section/network
interface = wlp2s0
interval = 1
label-connected = %downspeed% 
label-connected-foreground = ${colors.blue}

[module/wlan-up]
inherit = section/network
interface = wlp2s0
interval = 1
label-connected = %upspeed% 
label-connected-foreground = ${colors.greya}

[module/wlan-signal]
inherit = section/network
interface = wlp2s0
label-connected = (%essid%) %signal:2%% 
