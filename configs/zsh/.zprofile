#!/usr/bin/env zsh

editors=("emacsclient" "emacs" "nvim" "vim" "vi" "nano")
for editor in ${editors[@]}; do
    if [ "$(command -v ${editor})" != "" ]; then
        case ${editor} in
            "emacsclient")
                [[ $(ps aux | grep -i "emacs" | grep "daemon" -c) ]] || emacs --daemon
                export EDITOR="${editor} -nc"
                ;;
            *)
                export EDITOR="${editor}"
                ;;
        esac
        break
    fi
done

case "$(uname -s)" in
    "Darwin")
        export CLICOLOR=1
        export OS="macos"
        ;;
    "Linux")
        export OS="linux"
        ;;
esac

#: #############################################################################
#: custom sourcing
#: #############################################################################
if [ "$(command -v conda)" != "" ]; then
    conda_dir=$(conda info | grep "base environment" | cut -d : -f 2 | cut -d " " -f 2)
    source ${conda_dir}/etc/profile.d/conda.sh
fi

#: #############################################################################
#: custom functions
#: #############################################################################
function can_sudo {
    sudo -v 1> /dev/null
    echo $?
}

function zp {
    ${EDITOR} ${DOTS}/bin/_${1}
    source ${ZSH}/.zshrc
}

function add-host {
    if [[ $(can_sudo) -ne 0 ]]; then
        return
    fi

    me=$(whoami)

    # ${EDITOR} ${DOTS}/homedir/.hosts
    # gpg -c ${DOTS}/homedir/.hosts
    case $OS in
        "linux") sys_hosts_path="/etc/hosts" ;;
        "macos") sys_hosts_path="/private/etc/hosts" ;;
    esac
    my_hosts_copy="${DOTS}/@${OS}/preferences/hosts"

    sudo ${EDITOR} ${hosts_path}
    sudo cp ${sys_hosts_path} ${my_hosts_copy}
    sudo chmod ${me}:${me} ${my_hosts_copy}
    gpg -c ${my_hosts_copy}
}
