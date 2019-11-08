#!/usr/bin/env zsh
export XDG_CONFIG_HOME="${HOME}/.config"

export DOTS="${HOME}/dotfiles"
export CONF="${DOTS}/configs"

export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
export ZSH="${ZDOTDIR}"

export SSH_CONFIG="-F ${XDG_CONFIG_HOME}/ssh/config"
export SSH_ID="-i ${XDG_CONFIG_HOME}/ssh/j@ionlights.com.pem"

alias ssh="command ssh ${SSH_CONFIG}"
alias ssh-copy-id="command ssh-copy-id ${SSH_ID}"

export PATH="/usr/local/sbin:$PATH"

if [[ command -v conda ]]; then

fi
