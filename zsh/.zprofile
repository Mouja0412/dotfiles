#!/usr/bin/zsh

export EDITOR="nvim"
export ZSH="${HOME}/dotfiles/zsh"
export DOTS="${HOME}/dotfiles"

OS=`uname -s`

case $OS in
    "Darwin")
        export CLICOLOR=1
        export OS_="macos"
        ;;
    "Linux")
        export OS_="linux"
        ;;
esac

#: #############################################################################
#: custom sourcing
#: #############################################################################
. /opt/conda/etc/profile.d/conda.sh

#: #############################################################################
#: custom functions
#: #############################################################################

function zp {
    $EDITOR ${DOTS}/_bin/_${1} && . ~/.zshrc
}

function sshcfg {
    $EDITOR ${DOTS}/.ssh/config
}