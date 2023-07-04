# SPDX-License-Identifier: GPL-3.0-or-later
#
# Dockerfile -- dev environment for anywhere
# Copyright (C) 2023  Jacob Koziej <jacobkoziej@gmail.com>

FROM archlinux/archlinux:latest

ARG USER=dev
ARG UID=1000
ARG GID=1000
ARG SHELL=/bin/zsh
ARG COUNTRY=US

COPY dev-container       /dev-container
COPY etc/pacman.conf     /etc/pacman.conf
COPY etc/sudoers.d/wheel /etc/sudoers.d/wheel

RUN pacman -Syyu --noconfirm \
	pacman-contrib       \
	parallel             \
	;
RUN curl -s "https://archlinux.org/mirrorlist/?country=$COUNTRY&protocol=https&use_mirror_status=on" \
	| sed -e 's/^#Server/Server/' -e '/^#/d'                                                     \
	| rankmirrors --parallel --verbose -n 0 -                                                    \
	| tee /etc/pacman.d/mirrorlist                                                               \
	;

RUN pacman -S --noconfirm \
	bash              \
	bashtop           \
	bat               \
	binutils          \
	clang             \
	direnv            \
	exa               \
	fd                \
	fzf               \
	gcc               \
	gdb               \
	git               \
	git-lfs           \
	github-cli        \
	gnupg             \
	htop              \
	inetutils         \
	linux-headers     \
	man-db            \
	man-pages         \
	mosh              \
	neovim            \
	openssh           \
	python            \
	python-pip        \
	python-pipx       \
	ripgrep           \
	rsync             \
	rust              \
	shellcheck        \
	shfmt             \
	sudo              \
	tmux              \
	valgrind          \
	zsh               \
	;

RUN groupadd       \
	--gid $GID \
	$USER      \
	;
RUN useradd             \
	--gid    $GID   \
	--groups wheel  \
	--shell  $SHELL \
	--uid    $UID   \
	$USER           \
	;
RUN mkdir /home/$USER

USER    $USER
WORKDIR /home/$USER
CMD     ["/dev-container"]
