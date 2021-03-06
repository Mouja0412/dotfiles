#: #############################################################################
#: @ionlights/.zshrc
#: Thanks for taking a look at my dotfiles! :blush:
#: However, it's definitely necessary to cite my sources, which made building
#:   this so much easier. :sweat_smile:
#:   - https://carlosbecker.com/posts/speeding-up-zsh/
#:   - https://blog.callstack.io/supercharge-your-terminal-with-zsh-8b369d689770
#: #############################################################################

export DATA_DIR="${HOME}/Data"
export LOGS_DIR="${HOME}/Logs"

export BASE_PATH="${PATH}"

# [ -d $HOME/.linuxbrew ] && export PATH="$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH"

export PATH="/opt/conda/bin:${PATH}"
export PATH="${DOTS}/bin:${PATH}"


#: font to be used: "Fira Code", https://github.com/tonsky/FiraCode/releases
export ANTIBODY_PLUGS="${DOTS}/zsh/antibody_plugins"

#: #############################################################################
#: autocomplete-cfg
#: #############################################################################
autoload -Uz compinit
case $OS in
    "macos")
        if [ $(date +'%j') != $(stat -f '%Sm' -t '%j' "${ZSH}/.zcompdump") ]; then
            compinit -i
        else
            compinit -Ci
        fi
        ;;
    # TODO: only works on MacOS - get setup on Linux
    "linux") compinit -C ;;
esac
zmodload -i zsh/complist

#: #############################################################################
#: zsh-hist-cfg
#: #############################################################################
HISTFILE="${ZSH}/history"
HISTSIZE=100000
SAVEHIST="${HISTSIZE}"

#: #############################################################################
#: setopts - mostly for non-zsh systems
#: #############################################################################
source ${DOTS}/bin/_setopts

ZSH_AUTOSUGGEST_STRATEGY="history"

#: #############################################################################
#: autocompletion-cfg
#: #############################################################################
#: enable approx matches for complextion
zstyle ":completion:*" completer _expand _complete _ignored _approximate
#: select completions w/ arrow keys
zstyle ':completion:*' menu select
#: group results by category
zstyle ':completion:*' group-name ''
#: enable approx matches for completion
zstyle ':completion:*' completer _expand _complete _ignored _approximate

zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true
zstyle ':completion:*:man:*'      menu yes select

#: #############################################################################
#: spaceship-prompt
source ${DOTS}/bin/_spaceship
#: aliases
source ${DOTS}/bin/_aliases
#: custom functions
source ${DOTS}/bin/_functions

#: #############################################################################
#: setup additional hooks and whatnot
#: #############################################################################
eval "$(direnv hook zsh)"                   #: direnv
# eval "$(register-python-argcomplete conda)" #: conda autocomplete
source "${ANTIBODY_PLUGS}_${OS}.sh"        #: antibody
# conda activate base

fpath=(${DOTS}/completions $fpath)

#: #############################################################################
#: keybindings
#: #############################################################################
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[[3~' delete-char
bindkey '^[3;5~' delete-char
#: delete-key ~ https://blogsourcepilif.me/2004/10/21/delete-key-in-zsh/

source "${DOTS}/@${OS}/specifics"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
