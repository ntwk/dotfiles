#
# ~/.profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Perl local::lib environment variables
export PERL_LOCAL_LIB_ROOT="$PERL_LOCAL_LIB_ROOT:$HOME/perl5";
export PERL_MB_OPT="--install_base $HOME/perl5";
export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5";
export PERL5LIB="$HOME/perl5/lib/perl5:$PERL5LIB";
export PATH="$HOME/perl5/bin:$PATH";

# Add local scripts to path
export PATH="$HOME/bin:$PATH"

# Setup for /usr/bin/ls and /usr/bin/grep to support color
if [[ -f "/etc/dircolors" ]]; then
    eval $(dircolors -b /etc/dircolors)
fi

if [[ -f "$HOME/.dircolors" ]]; then
    eval $(dircolors -b $HOME/.dircolors)
fi
