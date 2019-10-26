#!/usr/bin/zsh

export EDITOR="nvim"
export DOTS="${HOME}/.setup"
export ZSH="${DOTS}/dots-no-xdg/zsh"

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
# . /opt/conda/etc/profile.d/conda.sh

#: #############################################################################
#: custom functions
#: #############################################################################

function zp {
    $EDITOR ${DOTS}/bin/_${1} && . ~/.zshrc
}
