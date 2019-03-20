#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Host-specific overriding of the prompt should go in .bashrc_local
PS1='\[\e[0;31m\][\[\e[0;33m\]\u\[\e[0;31m\]@\h \W\[\e[0;32m\]$(__git_ps1 " %s")\[\e[0;31m\]]\$\[\e[0m\] '

alias lpr='lpr -o fit-to-page'

# More verbose move, copy and delete
alias mv='mv -vi'
alias cp='cp -vi'
alias rm='rm -v'

# Stack-based directory navigation
alias d='dirs'
alias p='pushd'
alias o='popd'

# Make bash aliases work with sudo
# http://askubuntu.com/questions/22037/aliases-not-available-when-using-sudo
alias sudo='sudo '

# Emacs in a tty
alias em='emacs -nw'
alias ec='emacsclient -t'

# GNU screen
alias sr='screen -raAd'
alias sc='screen'

# remote-viewer
alias rv='GTK_THEME=Adwaita:dark remote-viewer --hotkeys=toggle-fullscreen=shift+f11'

# TigerVNC vncviewer
alias vv='vncviewer'

# tmux
alias tml='tmux list-sessions'
alias tma='tmux attach-session'
alias tmc='clear && tmux clear'
alias tmk='tmux kill-session'
alias tm='tmux new-session'

# grep in color
alias grep='grep --color=auto'

# ls shortcuts, paging, etc.
alias ls='ls --color=auto'
alias ll='ls -l'
alias lsl='ls -Cw $COLUMNS --color | less -FRX'
alias lsll='ls -l --color | less -FRX'

# File renaming
alias tolower='perl-rename '\''s/(.*)/\L$1/'\'
alias toupper='perl-rename '\''s/(.*)/\U$1/'\'

# Open file manager in current directory
alias ta='exo-open --launch FileManager 2>/dev/null'

# Open a new tmux window in the present working directory in session 0
# See ~/.local/share/xfce4/helpers/custom-TerminalEmulator.desktop and
# ~/.config/xfce4/helpers.rc for the related configuration.
alias tw='tmux-neww-here'

# Colorize man pages. See ~/bin/colorman for details
alias man=colorman

# Set line length of man pages to 80 characters
export MANWIDTH=80

# Ignore duplicate entries in bash history and commands with leading
# space.  Omit commands listed in HISTIGNORE from the bash history.
HISTCONTROL=ignoreboth

# Arch Linux User Repository (AUR) AUR4 package cloning
aurclone() {
    git clone https://aur.archlinux.org/$1.git $2
}

# colordiff piped through a pager
cdiff() {
    colordiff $@ | less -RS
}

# Change directory to root of current Git repository
cg() {
    declare cdup; # cdup must be declared before it is initliazed in
                  # order to capture the exit status of git rev-parse.
    cdup="$(git rev-parse --show-cdup)"
    declare status=$?
    if [[ -n $cdup ]]; then
        cd "$cdup"
    else
        return $status
    fi
}

# Emacs: read-only edition
emr() {
    emacs "$1" -nw --eval '(setq buffer-read-only t)'
}

# Command to change the font in rxvt-unicode
face() {
    if [[ -n ${TMUX+x} ]]; then
        printf '\ePtmux;\e\e]713;%s\007\e\e]712;%s\007\e\e]711;%s\007\e\e]50;%s\007\e\\' "xft:$1" "xft:$1" "xft:$1" "xft:$1"
    else
        printf '\33]713;%s\007\33]712;%s\007\33]711;%s\007\33]50;%s\007' "xft:$1" "xft:$1" "xft:$1" "xft:$1"
    fi
}

# Print a PS1 prompt assignment using random colors.  To set the
# current prompt, execute 'eval $(genprompt)'.
genprompt() {
    declare foreground=$(($RANDOM % 256))
    declare background=$(($RANDOM % 256))
    echo PS1=\'"\[\e[38;5;${background}m\][\[\e[38;5;${foreground}m\]\u\[\e[38;5;${background}m\]@\h \W\[\e[38;5;32m\]\$(__git_ps1 \" %s\")\[\e[38;5;${background}m\]]\\$\[\e[0m\] "\'
}

# Git prompt
source ~/.git-prompt.sh

# Local configuration
[[ -s "$HOME/.bashrc_local" ]] && source "$HOME/.bashrc_local"
