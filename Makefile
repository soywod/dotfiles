# Audio {{{

audio:
	sudo pacman -S --needed --noconfirm \
		mpv \
		playerctl \
		pulseaudio \
		pulseaudio-alsa \
		pulseaudio-bluetooth \

# }}}

# Bash (shell) {{{

bash-pkgs:
	sudo pacman -S --needed --noconfirm \
		bash-completion \

bash-pkgs-aur: yay
	yay -S --needed --noconfirm \
		bash-git-prompt \

bash-cfg:
	ln -vsf "${PWD}/bash/aliases.sh" "${HOME}/.bash_aliases"
	ln -vsf "${PWD}/bash/completion.sh" "${HOME}/.bash_completion"
	ln -vsf "${PWD}/bash/config.sh" "${HOME}/.bashrc"
	ln -vsf "${PWD}/bash/profile.sh" "${HOME}/.profile"

bash: bash-pkgs bash-pkgs-aur bash-cfg

# }}}

# Bluez (bluetooth) {{{

bluez-pkgs:
	sudo pacman -S --needed --noconfirm \
		bluez \
		bluez-utils \

bluez-cfg:
	sudo ln -vsf "${PWD}/bluez/toggle.sh" /usr/local/bin/dotfiles--bluetooth-toggle

bluez: bluez-pkgs bluez-cfg

# }}}

# Brightnessctl {{{

brightnessctl:
	sudo pacman -S --needed --noconfirm \
		brightnessctl \

# }}}

# Capture {{{

capture-pkgs:
	sudo pacman -S --needed --noconfirm \
		grim \
		slurp \
		wf-recorder \
		wl-clipboard \

capture-cfg:
	sudo ln -sf "${PWD}/capture/screen-capture.sh" /usr/local/bin/dotfiles--screen-capture
	sudo ln -sf "${PWD}/capture/selection-capture.sh" /usr/local/bin/dotfiles--selection-capture
	sudo ln -sf "${PWD}/capture/selection-record.sh" /usr/local/bin/dotfiles--selection-record

capture: capture-pkgs capture-cfg

# }}}

# Cronie (cron daemon) {{{

cronie-pkgs:
	sudo pacman -S --needed --noconfirm \
		cronie \

cronie-cfg:
	sudo cp -vf "${PWD}/cronie/config.crontab" "/var/spool/cron/${USER}"
	sudo chown "${USER}:${USER}" "/var/spool/cron/${USER}"
	sudo systemctl restart cronie.service

cronie: cronie-pkgs cronie-cfg

# }}}

# Docker {{{

docker:
	sudo pacman -S --needed --noconfirm \
		docker \
		docker-compose \

# }}}

# Dropbox {{{

dropbox-pkgs:
	curl -Lo - https://www.dropbox.com/download?plat=lnx.x86_64 | tar xzf - -C ~

dropbox-srv:
	mkdir -vp "${HOME}/.config/systemd/user"
	cp -v "${PWD}/dropbox/service.ini" "${HOME}/.config/systemd/user/dropbox.service"
	systemctl --user daemon-reload
	systemctl --user enable dropbox.service
	systemctl --user start dropbox.service

dropbox: dropbox-pkgs dropbox-srv

# }}}

# Dunst (notification manager) {{{

dunst-pkgs:
	sudo pacman -S --needed --noconfirm \
		mpv \
		libnotify \
		dunst \

dunst-cfg:
	mkdir -vp "${HOME}/.config/dunst"
	ln -vsf "${PWD}/dunst/config.cfg" "${HOME}/.config/dunst/dunstrc"
	sudo ln -vsf "${PWD}/dunst/notification.sh" /usr/local/bin/dotfiles--notification-play-sound

dunst-srv:
	mkdir -vp "${HOME}/.config/systemd/user"
	cp -v "${PWD}/dunst/service.ini" "${HOME}/.config/systemd/user/dunst.service"
	systemctl --user daemon-reload
	systemctl --user enable dunst.service
	systemctl --user start dunst.service

dunst: dunst-pkgs dunst-cfg dunst-srv

# }}}

# Fonts {{{

fonts:
	sudo pacman -S --needed --noconfirm \
		ttf-jetbrains-mono
	mkdir -vp "${HOME}/.config/fontconfig"
	# ln -vsf "${PWD}/fonts/config.xml" "${HOME}/.config/fontconfig/fonts.conf"
	cp -v ${PWD}/fonts/*.ttf "${HOME}/.local/share/fonts/"
	fc-cache -vf

# }}}

# Gammastep (blue light reducer) {{{

gammastep-pkgs:
	sudo pacman -S --needed --noconfirm \
		gammastep \

gammastep-cfg:
	mkdir -vp "${HOME}/.config/gammastep"
	ln -vsf "${PWD}/gammastep/config.ini" "${HOME}/.config/gammastep/config.ini"

gammastep-srv:
	mkdir -vp "${HOME}/.config/systemd/user"
	cp -v "${PWD}/gammastep/service.ini" "${HOME}/.config/systemd/user/gammastep.service"
	systemctl --user daemon-reload
	systemctl --user enable gammastep.service
	systemctl --user start gammastep.service

gammastep: gammastep-pkgs gammastep-cfg gammastep-srv

# }}}

# GnuPG {{{

gnupg-pkgs:
	sudo pacman -S --needed --noconfirm \
		gnupg \

gnupg-cfg:
	mkdir -vp "${HOME}/.gnupg"
	ln -vsf "${PWD}/gnupg/config.cfg" "${HOME}/.gnupg/gpg-agent.conf"
	sudo ln -vsf "${PWD}/gnupg/password-to-clipboard.sh" /usr/local/bin/dotfiles--password-to-clipboard

gnupg: gnupg-pkgs gnupg-cfg

# }}}

# GUIs {{{

guis-pkgs:
	sudo pacman -S --needed --noconfirm \
		chromium \
		filezilla \
		libreoffice-fresh \
		thunderbird \

guis-pkgs-aur: yay
	yay -S --needed --noconfirm \
		postman-bin \
		slack-desktop \
		telegram-desktop \

guis: guis-pkgs guis-pkgs-aur

# }}}

# Hledger (plain text accounting) {{{

hledger: bash dropbox kitty
	sudo pacman -S --needed --noconfirm \
		hledger \

# }}}

# Kanshi (screen manager) {{{

kanshi-pkgs:
	sudo pacman -S --needed --noconfirm \
		kanshi \

kanshi-cfg:
	mkdir -vp "${HOME}/.config/kanshi"
	ln -vsf "${PWD}/kanshi/config.cfg" "${HOME}/.config/kanshi/config"

kanshi-srv:
	mkdir -vp "${HOME}/.config/systemd/user"
	cp -v "${PWD}/kanshi/service.ini" "${HOME}/.config/systemd/user/kanshi.service"
	systemctl --user daemon-reload
	systemctl --user enable kanshi.service
	systemctl --user start kanshi.service

kanshi: kanshi-pkgs kanshi-cfg kanshi-srv

# }}}

# Kitty (terminal) {{{

kitty-pkgs:
	sudo pacman -S --needed --noconfirm \
		kitty \

kitty-cfg:
	mkdir -vp "${HOME}/.config/kitty"
	ln -vsf "${PWD}/kitty/config.cfg" "${HOME}/.config/kitty/kitty.conf"

kitty: kitty-pkgs kitty-cfg

# }}}

# Neovim (text editor/IDE) {{{

neovim-pkgs:
	sudo pacman -S --needed --noconfirm \
		neovim \

neovim-cfg:
	mkdir -vp "${HOME}/.local/share/nvim/site/pack/plugins/start"
	ln -vsfn "${PWD}/neovim/config" "${HOME}/.config/nvim"
	ln -vsfn "${PWD}/neovim/plugins" "${HOME}/.local/share/nvim/site/pack/plugins/opt"
	ln -vsfn "${PWD}/neovim/snippets" "${HOME}/.config/nvim/UltiSnips"
	sudo ln -vsf "${PWD}/neovim/editor.sh" "/etc/profile.d/"

neovim: neovim-pkgs neovim-cfg

# }}}

# NetworkManager (network manager) {{{

network-manager-pkgs:
	sudo pacman -S --needed --noconfirm \
		networkmanager \

network-manager-srv:
	sudo systemctl enable NetworkManager
	sudo systemctl start NetworkManager

network-manager: network-manager-pkgs network-manager-srv

# }}}

# Pipewire (multimedia framework) {{{

pipewire-pkgs:
	sudo pacman -S --needed --noconfirm \
		pipewire \
		pipewire-media-session \
		xdg-desktop-portal \
		xdg-desktop-portal-wlr \

pipewire-srv:
	systemctl --user enable pipewire.service
	systemctl --user start pipewire.service

pipewire: pipewire-pkgs pipewire-srv

# }}}

# Sway (tile window manager) {{{

sway-pkgs:
	sudo pacman -S --needed --noconfirm \
		wayland \
		xorg-xwayland \
		sway \

sway-cfg:
	mkdir -vp "${HOME}/.config/sway"
	ln -vsf "${PWD}/sway/config.cfg" "${HOME}/.config/sway/config"

sway-srv:
	mkdir -vp "${HOME}/.config/systemd/user"
	cp -v "${PWD}/sway/target.ini" "${HOME}/.config/systemd/user/sway-session.target"
	cp -v "${PWD}/sway/service.ini" "${HOME}/.config/systemd/user/sway.service"
	systemctl --user daemon-reload

sway: rofi sway-pkgs sway-cfg sway-srv

# }}}

# TLP (battery optimizer) {{{

tlp-pkgs:
	sudo pacman -S --needed --noconfirm \
		tlp \

tlp-srv:
	sudo systemctl enable --now tlp

tlp: tlp-pkgs tlp-srv

# }}}

# Waybar (status bar manager) {{{

waybar-pkgs:
	sudo pacman -S --needed --noconfirm \
		waybar \
		fmt \

waybar-cfg:
	mkdir -vp "${HOME}/.config/waybar"
	ln -vsf "${PWD}/waybar/config.json" "${HOME}/.config/waybar/config"
	ln -vsf "${PWD}/waybar/style.css" "${HOME}/.config/waybar/style.css"

waybar: waybar-pkgs waybar-cfg

# }}}

# Yay (AUR helper) {{{

yay:
	mkdir -p /tmp/yay
	curl -Lo /tmp/yay/yay.tar.gz \
	`curl -s https://api.github.com/repos/jguer/yay/releases/latest \
		| grep "browser_download_url.*x86_64" \
		| cut -d : -f 2,3 \
		| tr -d \"\ `
	tar xvzf /tmp/yay/yay.tar.gz -C /tmp/yay/
	find /tmp/yay -name yay -type f -exec mv -v {} "${HOME}/.local/bin/" \;
	yay --version

# }}}


# PHONY {{{

.PHONY: \
	bash \
	bluez \
	capture \
	cronie \
	dropbox \
	dunst \
	fonts \
	gammastep \
	gnupg \
	install \
	kitty \
	neovim \
	rofi \

# }}}

# Install {{{

install: \
	audio \
	bash \
	bluez \
	brightnessctl \
	capture \
	cronie \
	docker \
	dropbox \
	dunst \
	gammastep \
	gnupg \
	guis \
	hledger \
	kanshi \
	kitty \
	neovim \
	network-manager \
	pipewire \
	rofi \
	sway \
	waybar \
	yay \

# }}}

# vim:foldmethod=marker
