#!/usr/bin/zsh

editors=("emacs" "nvim" "vim" "vi")
for editor in ${editors[@]}; do
    which $editor > /dev/null
    if [[ $? == 0 ]]; then
        export EDITOR=$editor
        break
    fi
done

export DOTS="${HOME}/dotfiles/"
export ZSH="${DOTS}/homedir/zsh"

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
