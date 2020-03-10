#: Keybindings
set sudope_sequence "\e\e"

#: Editors
# set editors emacsclient emacs nvim vim vi nano
set editors nvim vim vi nano
for e in $editors
    if not command -sq $e; continue; end

    switch $e
    case "emacsclient"
        #if (ps aux | grep -i "emacs" | grep "daemon" -c)
        #    emacs --daemon
        #end
        set -xg EDITOR "$e -nc"
    case "*"
        set -xg EDITOR $e
    end
    break
end

switch (uname -r)
case "Darwin"
    set -gx OS "macos"
case "Linux"
    set -gx OS "linux"
end

#: aliases.fish
source ~/.config/fish/aliases.fish

#: Starship
starship init fish | source

#: Fisher, setup for adding "functions"
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

#; Anaconda, modified to play nicely on my own systems
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
switch (hostname)
case "spock*"
    eval /usr/local/Caskroom/miniconda/base/bin/conda "shell.fish" "hook" $argv | source
case "discovery*"
    eval /opt/conda/condabin/conda "shell.fish" "hook" $argv | source
end
# <<< conda initialize <<<

#: env.fish
if status --is-login
    source ~/.config/fish/env.fish
end