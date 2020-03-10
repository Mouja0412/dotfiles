# Editors
balias e $EDITOR
if command -sq nvim
    balias v nvim
end

#: SSH
balias discovery "ssh x.ionlights.com -p 26592"
balias enterprise "ssh x.ionlights.com -p 28172"
balias sshcfg "v $HOME/.ssh/config"

# Emacs
balias doom "$HOME/Applications/doom-emacs/bin/doom"

# Anaconda
balias ca "conda activate"
balias ce "conda env create -f"
balias cl "conda list"

# region tmux
balias tmux "TERM='xterm-256color' command tmux -u"

balias trc "v $HOME/.tmux.conf.local"
balias tls "tmux ls"

function tn --argument session -d "Create a `tmux` session."
    z $argv[1]  # attach to hop to the directory most associated with session name
    tmux new -s $session
    if test $status -eq 1
        ta $session
    end
end
function ta --argument session -d "Attach to an existing `tmux` session"
    tmux attach -t $session
    if test $status -eq 1
        tn $session
     end
end
# endregion

# region ls
set ls_base_args "-hFv --color --group-directories-first"
switch $OS
case "macos"
    balias ls "gls $ls_base_args"
case "linux"
    balias ls "ls $ls_base_args"
end

balias l "ls"
balias la "l -A"
balias lr "l -r"
balias ld "l -d */"
# endregion

balias rm "rmtrash"
balias rmdir "rmdirtrash"

# Functions
function fp --argument file -d "edit files that `config.fish` sources"
    test (count $argv) -eq 1
    $EDITOR ~/.config/fish/$file.fish
    source ~/.config/fish/config.fish
end

balias frc "fp config"

function mktouch --argument file -d "Make a folder and touch the file"
    mkdir -p (dirname $file) && touch $file
end