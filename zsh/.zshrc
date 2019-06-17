#: #############################################################################
#: @ionlights/.zshrc
#: Thanks for taking a look at my dotfiles! :blush:
#: However, it's definitely necessary to cite my sources, which made building
#:   this so much easier. :sweat_smile:
#:   - https://carlosbecker.com/posts/speeding-up-zsh/
#:   - https://blog.callstack.io/supercharge-your-terminal-with-zsh-8b369d689770
#: #############################################################################

export BASE_PATH="$PATH"
export PATH="/opt/conda/bin:$BASE_PATH"
export PATH="$DOTS/_bin:$PATH"

#: font to be used: "Fira Code", https://github.com/tonsky/FiraCode/releases
export ANTIBODY_PLUGS=$ZSH/antibody_plugins

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
HISTFILE=$ZSH/history
HISTSIZE=100000
SAVEHIST="${HISTSIZE}"

#: #############################################################################
#: setopts - mostly for non-zsh systems
#: #############################################################################
setopt auto_cd              #: cd by typing dir name, if it\'s not a cmd
setopt auto_list            #: auto-list choices on ambiguous completion
setopt auto_menu            #: auto use menu completion
setopt always_to_end        #: move cursor to end if word as one match
setopt hist_ignore_all_dups #: remove older duplicate entries from hist
setopt hist_reduce_blanks   #: remove blanks from hist
setopt inc_append_history   #: save hist entries as soon as they\'re entered
setopt share_history        #: share hist between diff instances
setopt correct_all          #: autocorrect cmds
setopt interactive_comments #: allow commends in interactive shells

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
#zstyle ':completion:*' completer _expand _complete _ignored _approximate

#: #############################################################################
#: spaceship-prompt
#: https://denysdovhan.com/spaceship-prompt/
#: #############################################################################
#: https://denysdovhan.com/spaceship-prompt/docs/Options.html
SPACESHIP_PROMPT_ORDER=(
    user      # username
    dir       # cwd
    host      # hostname
    git       # git (git_branch + git_status)
    exec_time # execution time
    battery   # battery
    line_sep  # line break
    vi_mode   # vi-mode indicator
    jobs      # bg jobs indicator
    exit_code # exit code section
    char      # prompt character
)

SPACESHIP_RPROMPT_ORDER=(
    battery   # battery
    conda     # conda
    golang    # golang
    ruby      # ruby
    julia     # julia
    node      # node.js
    dotnet    # .NET
)

SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SYMBOL="-> "
SPACESHIP_CHAR_SUFFIX=" "

#: simplify for hyper.is prompt
if [[ "${TERM_PROGRAM}" == "Hyper" ]]; then
    SPACESHIP_PROMPT_SEPARATE_LINE=false
    SPACESHIP_DIR_SHOW=false
    SPACESHIP_GIT_BRANCH_SHOW=false
fi

#: #############################################################################
#: keybindings
#: #############################################################################
# bindkey '^[[A' history-substring-search-up
# bindkey '^[[B' history-substring-search-down
bindkey '^[[3~' delete-char
bindkey '^[3;5~' delete-char
#: delete-key ~ https://blog.pilif.me/2004/10/21/delete-key-in-zsh/

#: #############################################################################
#: aliases
#: #############################################################################
alias srv="ssh srv"
alias nas="ssh nas"
alias mbp="ssh mbp"
alias osx="ssh osx"

alias zrc="$EDITOR ~/.zshrc && . ~/.zshrc"
alias plugins="$EDITOR ${ANTIBODY_PLUGS}.txt && antibody bundle < ${ANTIBODY_PLUGS}.txt > ${ANTIBODY_PLUGS}_${OS_}.sh"

case $OS_ in
    "linux")
        alias ls="ls --color=always"
    ;;
esac
alias ll="ls -lh"
alias lr="ls -r"
alias ld="ls -d */"

ignoreRegex=".*\(Permission denied\)"
ignoreRegex="${ignoreRegex}\|\(Operation not permitted\)"
alias size="du -ch -d 1 2> >(grep -v \"${ignoreRegex}\") | sort -h"

#: #############################################################################
#: setup additional hooks and whatnot
#: #############################################################################
eval "$(direnv hook zsh)"                   #: direnv
eval "$(register-python-argcomplete conda)" #: conda autocomplete
source "${ANTIBODY_PLUGS}_${OS_}.sh"        #: antibody
# conda activate base

fpath=(~/dotfiles/completion $fpath)

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/ionlights/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/ionlights/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/ionlights/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/ionlights/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
