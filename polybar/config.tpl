; -------------------------------------------------------------------- # Theme #

[colors]
black  = #494B53
blue   = #4078f2
green  = #50a14f
greya  = #a0a1a7
greyd  = #d0d0d0
greyf  = #f0f0f0
red    = #e45649
white  = #fafafa
yellow = #c18401

; ------------------------------------------------------------- # Bar (common) #

[section/bar]
font-0 = SpaceMonoNL:pixelsize=12;3
font-1 = FontAwesome5FreeSolid:pixelsize=12;3
font-2 = SpaceMonoNL:pixelsize=17;4

background = ${colors.white}
foreground = ${colors.black}

cursor-click = pointer

height = 32
module-margin-left  = 1
module-margin-right = 1
padding-left  = 1
padding-right = 1
radius = 0

; ---------------------------------------------------------------- # Bar (top) #

[bar/top]
inherit = section/bar

border-bottom-color = ${colors.greyf}
border-bottom-size  = 1

modules-left    = mpd
modules-center  = date
modules-right   = github transmission

; ------------------------------------------------------------- # Bar (bottom) #

[bar/bottom]
inherit = section/bar
bottom = true
border-top-size = 1
border-top-color = ${colors.greyf}
modules-left = battery memory cpu temperature filesystem volume xkeyboard
modules-center = title
modules-right = eth-down-speed eth-up-speed wired-network

; ---------------------------------------------------------------------- # MPD #

[module/mpd]
type = internal/mpd
host = /run/user/$UID/mpd.sock
interval = 1

label-song = / %artist% / %title:0:50%
format-online = <icon-prev> <toggle> <icon-stop> <icon-next>  <icon-random> <icon-repeatone> <icon-repeat> <label-song> 

icon-prev      = 
icon-stop      = 
icon-play      = 
icon-pause     = 
icon-next      = 
icon-random    = 
icon-repeatone = 
icon-repeat    = 

icon-prev-foreground  = ${colors.greyd}
icon-stop-foreground  = ${colors.greyd}
icon-play-foreground  = ${colors.greyd}
icon-pause-foreground = ${colors.blue}
icon-next-foreground  = ${colors.greyd}
label-song-foreground = ${colors.greya}
toggle-off-foreground = ${colors.greyd}
toggle-on-foreground  = ${colors.greya}

; ----------------------------------------------------------------- # Datetime #

[module/date]
type = internal/date
interval = 5

date =
time = %H:%M

date-alt = %A %B %e
time-alt =

label = - %date%%time% -
label-font = 3
label-foreground = ${colors.greya}

; ------------------------------------------------------------------- # GitHub #

[module/github]
type = internal/github
token = ${file:~/.github.token}
empty-notifications = false
interval = 10

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

label-full  = Full
format-full = <label-full>
format-full-foreground = ${colors.greya}
format-full-suffix = " "
format-full-suffix-foreground = ${colors.black}

label-charging  = %percentage:3%%
format-charging = <label-charging> 
format-charging-foreground = ${colors.yellow}
format-charging-suffix = " "
format-charging-suffix-foreground = ${colors.black}

label-discharging  = %percentage:3%%
format-discharging = <label-discharging> <ramp-capacity>
format-discharging-foreground = ${colors.greya}

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

label = %percentage_used:2%%
label-foreground = ${colors.greya}
format-suffix = " "
format-suffix-foreground = ${colors.black}

; ---------------------------------------------------------------------- # CPU #

[module/cpu]
type = internal/cpu
interval = 5
label = %percentage:2%%
label-foreground = ${colors.greya}
format-suffix = " "
format-suffix-foreground = ${colors.black}

; -------------------------------------------------------------- # Temperature #

[module/temperature]
type = internal/temperature
interval = 5
thermal-zone = 10
warn-temperature = 60

label = %temperature-c:5%
format = <label> <ramp>
format-foreground = ${colors.greya}

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

label-mounted = %free:0:7%
label-mounted-foreground = ${colors.greya}
format-mounted-suffix = " "
format-mounted-suffix-foreground = ${colors.black}

; -------------------------------------------------------------------- # Audio #

[module/volume]
type = internal/volume

label-volume  = %percentage:0:3%%
label-volume-foreground = ${colors.greya}
format-volume-suffix = " "
format-volume-suffix-foreground = ${colors.black}

label-muted   = Full "
label-muted-foreground = ${colors.greya}
format-muted-suffix = " "
format-muted-suffix-foreground = ${colors.black}

; ---------------------------------------------------------- # Keyboard layout #

[module/xkeyboard]
type = internal/xkeyboard
blacklist-0  = caps lock

label-layout = %layout:2%
label-layout-foreground = ${colors.greya}
format-suffix = " "
format-suffix-foreground = ${colors.black}

; ------------------------------------------------------------- # Window title #

[module/title]
type = internal/xwindow
label-maxlen = 50
label-foreground = ${colors.black}

; ----------------------------------------------------------- # Download speed #

[module/eth-down-speed]
type = internal/network
interface = eth0
accumulate-stats = true
interval = 1

label-connected = %downspeed%
label-connected-foreground = ${colors.green}
format-connected-suffix = " "
format-connected-suffix-foreground = ${colors.black}

format-disconnected =

; ------------------------------------------------------------- # Upload speed #

[module/eth-up-speed]
type = internal/network
interface = eth0
interval = 1

label-connected = %upspeed%
label-connected-foreground = ${colors.red}
format-connected-suffix = " "
format-connected-suffix-foreground = ${colors.black}
format-disconnected =

; ----------------------------------------------------------------- # Ethernet #

[module/wired-network]
type = internal/network
interface = eth0
interval = 5

label-connected = %local_ip%
label-connected-foreground = ${colors.greya}
format-connected-suffix = " "
format-connected-suffix-foreground = ${colors.black}
format-disconnected =

; vim:ft=dosini

