#!/usr/bin/env bash

function _neovim() {
  mkdir -p $HOME/Downloads
  cd $HOME/Downloads
  wget https://github.com/reaper8055/neovim-builds/releases/download/nvim-v0.10.0-stable-linux-amd64/nvim-v0.10.0-stable-linux-amd64.deb
  apt install -y ./nvim-v0.10.0-stable-linux-amd64.deb
}

function _fzf() {
  [ -f "$(which fzf)" ] && return 0
  git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
  yes | $HOME/.fzf/install
}

function _stylua() {
  if [ -f "$(which stylua)" ]; then
    return 0
  else
    cd $HOME/Downloads/
    curl -LO https://github.com/JohnnyMorganz/StyLua/releases/download/v0.20.0/stylua-linux-x86_64.zip
    sudo unzip stylua-linux-x86_64.zip -d /usr/local/bin/
    [[ $? -eq 0 ]] && rm $HOME/Downloads/stylua-linux-x86_64.zip
  fi
}

function _eza() {
  [ -f "$(which eza)" ] && return 0
  if [[ "$OSTYPE" == "linux-gnu" ]]; then
    distribution_id="$(lsb_release -is)"
    if [[ "${distribution_id}" == "Ubuntu" ]] || [[  "${distribution_id}" == "Pop" ]]; then
      sudo mkdir -p /etc/apt/keyrings
      wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
      echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
      sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
      sudo apt update
      sudo apt install -y eza
    fi
  fi
}

function _starship() {
  [ -f "$(which starship)" ] && return 0
  curl -sSL https://starship.rs/install.sh | sudo sh -s -- -y
}

function _direnv() {
  if [ -f "$(which direnv)" ]; then
    return 0
  else
    export bin_path="/usr/local/bin"
    curl -sfL https://direnv.net/install.sh | sudo bash
  fi
}

function _zap() {
  zsh <(curl -sL https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) \
    --branch release-v1
}

function _wl-clipboard() {
  [ -f "$(which wl-copy)" ] && return 0
  sudo apt install -y wl-clipboard
}

function _dependencies() {
  apt update
  apt full-upgrade -y
  DEBIAN_FRONTEND=noninteractive apt install -y \
    rclone \
    git \
    curl \
    wget \
    zsh \
    fd-find \
    ripgrep \
    stow \
    sudo \
    unzip \
    build-essential \
    apt-transport-https \
    ca-certificates \
    lsb-release
}

function _golang() {
  if [ -f "$(which go)" ]; then
    return 0
  else 
    apt install -y golang-go
  fi
}

function _lua() {
  apt install -y lua5.1 liblua5.1-0-dev
}

function _dotfiles() {
  git clone https://github.com/reaper8055/dotfiles $HOME/dotfiles
  for FILE in $HOME/.zshrc*; do
    rm "$FILE"
  done
  cd $HOME/dotfiles && stow .
}

_dependencies
_zap
_fzf
_stylua
_eza
_starship
_direnv
_golang
_lua
_neovim
_dotfiles

