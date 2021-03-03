#!/bin/bash

set -e

function log() {
    echo -e "\033[1;33m$1\033[0m"
}

log "Updating system"
sudo apt update -y
sudo apt upgrade -y

sudo apt install -y \
    bat \
    curl \
    exa \
    fd-find \
    fish \
    jq \
    neovim \
    python3 \
    python3-pip \
    python3-pynvim \
    ripgrep

sudo apt install -y yadm
yadm clone https://github.com/piotrek-szczygiel/dotfiles-wsl

log "Updating the yadm repo origin URL"
yadm remote set-url origin "git@github.com:piotrek-szczygiel/dotfiles-wsl.git"

log "Installing fish plugins"
fish -c fisher update

log "Installing git-delta"
wget -q -O /tmp/delta.deb $(curl -s https://api.github.com/repos/dandavison/delta/releases/latest \
    | jq --raw-output '.assets[] | select(.name | endswith("amd64.deb")).browser_download_url' | tail -n 1)
sudo dpkg -i /tmp/delta.deb

log "Installing neovim plugins"
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim '+PlugUpdate' '+PlugClean!' '+PlugUpdate' '+qall'

log "Issue 'chsh -s /usr/bin/fish' to change your shell to fish"
