#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='\[\e[0;31m\][\[\e[0;33m\]\u\[\e[0;31m\]@\h \W]\$\[\e[0m\] '

alias ls='ls --color=auto'
alias lpr='lpr -o fit-to-page'

# Make bash aliases work with sudo
# http://askubuntu.com/questions/22037/aliases-not-available-when-using-sudo
alias sudo='sudo '

# Emacs in a tty
alias em='emacs -nw'
alias erx='TERM=rxvt-unicode-256color emacs -nw'
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

# Use ls through pager with color and columns
alias lsl='ls -C --color=yes | less -FR'
alias lsll='ls -Cl --color=yes | less -FR'

# file renaming 
alias tolower='perl-rename '\''s/(.*)/\L$1/'\' 
alias toupper='perl-rename '\''s/(.*)/\U$1/'\' 

# always set man width to 80 columns
export MANWIDTH=80

# colorize man pages
    #LESS_TERMCAP_so=$'\E[38;5;246m' \
# man() {
#     env LESS_TERMCAP_mb=$'\E[01;31m' \
#     LESS_TERMCAP_md=$'\E[01;38;5;74m' \
#     LESS_TERMCAP_me=$'\E[0m' \
#     LESS_TERMCAP_se=$'\E[0m' \
#     LESS_TERMCAP_ue=$'\E[0m' \
#     LESS_TERMCAP_us=$'\E[04;38;5;146m' \
#     man "$@"
# }

# Ignore duplicate entries in bash history and commands with leading
# space.  Omit commands listed in HISTIGNORE from the bash history.
HISTCONTROL=ignoreboth
#HISTIGNORE="ls:ls -l:cd:cd *:pwd:"

# Make your shell change the window title every time it changes
# directory, or every time it displays a prompt.  For those who like
# to keep window titles short, you can drop the full path and only
# keep the basename. Just replace $HOME/*) HPWD="~${HPWD#$HOME}";;
# with *) HPWD=`basename "$HPWD"`;;
# if [ "$TERM" = "screen" ]; then
#   screen_set_window_title () {
#     local HPWD="$PWD"
#     case $HPWD in
#       $HOME) HPWD="~";;
#       $HOME/*) HPWD="~${HPWD#$HOME}";;
#     esac
#     printf '\ek%s\e\\' "$HPWD"
#   }
#   PROMPT_COMMAND="screen_set_window_title; $PROMPT_COMMAND"
# fi

function face {
    if [[ -n ${TMUX+x} ]]; then
        printf '\ePtmux;\e\e]713;%s\007\e\e]712;%s\007\e\e]711;%s\007\e\e]50;%s\007\e\\' "xft:$1" "xft:$1" "xft:$1" "xft:$1"
    else
        printf '\33]713;%s\007\33]712;%s\007\33]711;%s\007\33]50;%s\007' "xft:$1" "xft:$1" "xft:$1" "xft:$1"
    fi
}

# Emacs: read-only edition

function emr() {
    emacs "$1" -nw --eval '(setq buffer-read-only t)'
}

alias man=myman

# local config
[[ -s "$HOME/.bashrc_local" ]] && source "$HOME/.bashrc_local"
