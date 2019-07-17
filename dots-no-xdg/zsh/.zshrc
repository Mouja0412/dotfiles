#: #############################################################################
#: @ionlights/.zshrc
#: Thanks for taking a look at my dotfiles! :blush:
#: However, it's definitely necessary to cite my sources, which made building
#:   this so much easier. :sweat_smile:
#:   - https://carlosbecker.com/posts/speeding-up-zsh/
#:   - https://blog.callstack.io/supercharge-your-terminal-with-zsh-8b369d689770
#: #############################################################################

export BASE_PATH="${PATH}"
export PATH="/opt/conda/bin:${BASE_PATH}"
export PATH="${DOTS}/bin:${PATH}"

#: font to be used: "Fira Code", https://github.com/tonsky/FiraCode/releases
export ANTIBODY_PLUGS="${ZSH}/antibody_plugins"

#: #############################################################################
#: autocomplete-cfg
#: #############################################################################
autoload -Uz compinit
case $OS_ in
    "macos")
        if [ $(date +'%j') != $(stat -f '%Sm' -t '%j' ~/.zcompdump) ]; then
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
. ${DOTS}/bin/_setopts

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

#: #############################################################################
#: spaceship-prompt
#: #############################################################################
. ${DOTS}/bin/_spaceship

#: #############################################################################
#: aliases
#: #############################################################################
. ${DOTS}/bin/_aliases

#: #############################################################################
#: setup additional hooks and whatnot
#: #############################################################################
# eval "$(direnv hook zsh)"                   #: direnv
# eval "$(register-python-argcomplete conda)" #: conda autocomplete
source "${ANTIBODY_PLUGS}_${OS_}.sh"        #: antibody
# conda activate base

fpath=(${DOTS}/completions $fpath)

#: #############################################################################
#: keybindings
#: #############################################################################
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[[3~' delete-char
bindkey '^[3;5~' delete-char
#: delete-key ~ https://blog.pilif.me/2004/10/21/delete-key-in-zsh/

#: autojump
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/usr/local/Caskroom/miniconda/4.6.14/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/usr/local/Caskroom/miniconda/4.6.14/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/usr/local/Caskroom/miniconda/4.6.14/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/usr/local/Caskroom/miniconda/4.6.14/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

