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

switch (uname)
case "Darwin"
    set -gx OS "macos"
    if not fisher ls plugin-brew
        fisher add oh-my-fish/plugin-brew
    end
case "Linux"
    set -gx OS "linux"
    if not fisher ls plugin-linuxbrew
        fisher add oh-my-fish/plugin-linuxbrew
    end
case "*"
    echo "Not sure what to do here..."
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
#;   use `conda init` to get an idea for args
switch (hostname)
case "spock*"
    #; base on `conda init`
    eval /usr/local/Caskroom/miniconda/base/bin/conda "shell.fish" "hook" $argv | source
case "discovery*"
    #; base on `conda init`
    eval /opt/miniconda3/bin/conda "shell.fish" "hook" $argv | source
end



#: env.fish
if status --is-login
    source ~/.config/fish/env.fish
end
