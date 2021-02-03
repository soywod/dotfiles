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

# Bash (shell) {{{

bash-pkgs:
	sudo pacman -S --needed --noconfirm \
		bash-completion \

bash-pkgs-aur:
	yay -S --needed --noconfirm \
		bash-git-prompt \

bash-cfg:
	ln -vsf "${PWD}/bash/aliases.sh" "${HOME}/.bash_aliases"
	ln -vsf "${PWD}/bash/completion.sh" "${HOME}/.bash_completion"
	ln -vsf "${PWD}/bash/config.sh" "${HOME}/.bashrc"
	ln -vsf "${PWD}/bash/profile.sh" "${HOME}/.profile"

bash: bash-pkgs bash-pkgs-aur bash-cfg

# }}}

# Bluetooth {{{

bluetooth-pkgs:
	sudo pacman -S --needed --noconfirm \
		bluez \
		bluez-utils \

bluetooth-cfg:
	sudo ln -vsf "${PWD}/bluetooth/toggle.sh" /usr/local/bin/dotfiles--bluetooth-toggle

bluetooth: bluetooth-pkgs bluetooth-cfg

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

# Fonts {{{

fonts:
	cp -v ${PWD}/fonts/* "${HOME}/.local/share/fonts/"
	fc-cache -v

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

gnupg-pkgs-aur:
	yay -S --needed --noconfirm \
		pam-gnupg \
		libevdevplus \
		libuinputplus \
		ydotool \

gnupg-cfg:
	mkdir -vp "${HOME}/.gnupg"
	ln -vsf "${PWD}/gnupg/config.cfg" "${HOME}/.gnupg/gpg-agent.conf"
	sudo ln -vsf "${PWD}/gnupg/password-type.sh" /usr/local/bin/dotfiles--password-type
	sudo ln -vsf "${PWD}/gnupg/uinput.rules" "/etc/udev/rules.d/80-uinput.rules"
	sudo ln -vsf "${PWD}/gnupg/pam.cfg" "/etc/pam.d/system-local-login"
	sudo groupadd -f uinput
	sudo usermod -aG uinput ${USER}

gnupg-srv:
	mkdir -vp "${HOME}/.config/systemd/user"
	cp -v "${PWD}/gnupg/service.ini" "${HOME}/.config/systemd/user/ydotool.service"
	systemctl --user daemon-reload
	systemctl --user enable ydotool.service
	systemctl --user start ydotool.service

gnupg: gnupg-pkgs gnupg-pkgs-aur gnupg-cfg gnupg-srv

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

# Neovim (text editor/IDE) {{{

neovim-pkgs:
	sudo pacman -S --needed --noconfirm \
		fzf \
		neovim \
		python \
		python-neovim \
		ripgrep \

neovim-cfg:
	curl -fLo "${HOME}/.local/share/nvim/site/autoload/plug.vim" \
		--create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	mkdir -vp "${HOME}/.config/nvim/backup" "${HOME}/.config/nvim/swap" "${HOME}/.config/nvim/undo"
	ln -vsf "${PWD}/neovim/config.vim" "${HOME}/.config/nvim/init.vim"
	ln -vsfn "${PWD}/neovim/snippets" "${HOME}/.config/nvim/UltiSnips"
	sudo ln -vsf "${PWD}/neovim/editor.sh" "/etc/profile.d/"

neovim-plugins:
	nvim +PlugInstall +qa

neovim: neovim-pkgs neovim-cfg neovim-plugins

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

# Audio {{{

audio:
	sudo pacman -S --needed --noconfirm \
		mpv \
		playerctl \
		pulseaudio \
		pulseaudio-alsa \
		pulseaudio-bluetooth \

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

sway: sway-pkgs sway-cfg

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

# Docker {{{

docker:
	sudo pacman -S --needed --noconfirm \
		docker \
		docker-compose \

# }}}

# Brightness controller {{{

brightnessctl:
	sudo pacman -S --needed --noconfirm \
		brightnessctl \

# }}}

# GUIs {{{

guis-pkgs:
	sudo pacman -S --needed --noconfirm \
		chromium \
		filezilla \
		libreoffice-fresh \
		thunderbird \

guis-pkgs-aur:
	yay -S --needed --noconfirm \
		postman-bin \
		slack-desktop \
		telegram-desktop \

guis: guis-pkgs guis-pkgs-aur

# }}}

.PHONY: \
	bash \
	bluetooth \
	capture \
	dunst \
	fonts \
	gammastep \
	gnupg \
	install \
	kitty \
	neovim \

install: \
	yay \
	audio \
	bash \
	bluetooth \
	brightnessctl \
	capture \
	docker \
	dunst \
	fonts \
	gammastep \
	gnupg \
	guis \
	kitty \
	neovim \
	network-manager \
	sway \
	waybar \

# vim:foldmethod=marker
