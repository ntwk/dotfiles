#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Host-specific overriding of the prompt should go in .bashrc_local
PS1='\[\e[0;31m\][\[\e[0;33m\]\u\[\e[0;31m\]@\h \W]\$\[\e[0m\] '

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

# tmux
alias tml='tmux list-sessions'
alias tma='tmux attach-session'
alias tmc='clear && tmux clear'
alias tmk='tmux kill-session'
alias tm='tmux new-session'

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

# Colorize man pages. See ~/bin/colorman for details
alias man=colorman

# Man page column is 80 columns by default
export MANWIDTH=80

# Ignore duplicate entries in bash history and commands with leading
# space.  Omit commands listed in HISTIGNORE from the bash history.
HISTCONTROL=ignoreboth

# Command to change the font in urxvt
function face {
    if [[ -n ${TMUX+x} ]]; then
        printf '\ePtmux;\e\e]713;%s\007\e\e]712;%s\007\e\e]711;%s\007\e\e]50;%s\007\e\\' "xft:$1" "xft:$1" "xft:$1" "xft:$1"
    else
        printf '\33]713;%s\007\33]712;%s\007\33]711;%s\007\33]50;%s\007' "xft:$1" "xft:$1" "xft:$1" "xft:$1"
    fi
}

# colordiff piped through a pager
function cdiff() {
    colordiff $@ | less -RS
}

# emacs: read-only edition
function emr() {
    emacs "$1" -nw --eval '(setq buffer-read-only t)'
}

# Local config
[[ -s "$HOME/.bashrc_local" ]] && source "$HOME/.bashrc_local"
