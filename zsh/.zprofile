#!/usr/bin/zsh

export EDITOR="nvim"
export ZSH=$HOME/dotfiles/zsh

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

#: lsblk #######################################################################
function lsblk() {
    command lsblk
}

#: du ##########################################################################
# function du () {
#     local nDeep="1"
#     if [[ ! -z $1 ]]; then
#         nDeep=$1
#     fi
#     local ARGS="-ch"
#     local ignoreRegex=".*\(Permission denied\)"
#     ignoreRegex="$ignoreRegex\|\(Operation not permitted\)"
#
#     command du -ch -d ${nDeep} -I ${ignoreRegex} $@ | sort -h
# }

#: df ##########################################################################
function df () {
    local ARGS="-h"
    case $OS_ in
        "macos") ARGS="$ARGS -gP" ;;
        "linux") ARGS="$ARGS " ;;
    esac

    command df ${ARGS} -h
}

#: docker ######################################################################
CMD_DOCKER=`which docker`
function docker () {
    if [[ $2 == "--help" || $2 == "-h" ]]; then
        command docker $1 $2
        return
    fi

    local ARGS=""
    local usr="${UID}"
    local grp=""
    [[ -z ${DOCKER_GROUP} ]] && grp="${GID}" || grp="${DOCKER_GROUP}"

    case $1 in
        "run") ARGS="--user $usr:$grp $ARGS" ;;
        *) ARGS="$ARGS" ;;
    esac

    $CMD_DOCKER $1 $ARGS ${@:2}
}

# docker #######################################################################
