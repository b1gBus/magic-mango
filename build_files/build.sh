#!/bin/bash

set -ouex pipefail

echo "::group::Add Terra repository for mangowm"
curl -fsSL https://github.com/terrapkg/subatomic-repos/raw/main/terra.repo

dnf5 install terra-release
echo"::endgroup::"

echo "::group::Install host packages"
PACKAGES=(
	# WM / session
	mangowm
	waybar
	rofi
	foot
	gtkgreet
	gtklock
	polkit
	mako
	wl-clipboard

	# File management
	thunar
	thunar-archive-plugin
	thunar-volman
	file-roller

	# CLI essentials
	tmux
	zsh
	starship
	neovim
	yazi
	git
	curl
	wget
	ripgrep
	fd-find
	bat
	fzf
	eza

	# Useful desktop helpers
	pavucontrol
	playerctl

	# Printing
	cups
)
dnf5 install -y "${PACKAGES[@]}"
echo "::endgroup::"

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y tmux 

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

echo "::group::Configure Flathub"
flatpak remote-delete --system fedora || true
flatpak remote-add --if-not-exists --system flathub https://dl.flathub.org/repo/flathub.flatpakrepo
echo "::endgroup::"

echo "::group::Disable temporary repos"
dnf5 config-manager setopt terra.enabled=0 || true
dnf5 config-manager setopt terra-extras.enabled= 0 || true
echo "::endgroup::"

echo "::group::Cleanup"
dnf5 clean all
rm -rf /var/cache/dnf /var/lib/dnf /tmp/*
echo "::endgroup::"

#### Example for enabling a System Unit File

systemctl enable podman.socket
