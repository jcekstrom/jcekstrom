# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# setup bash completion
if [ -f /usr/local/etc/bash_completion ]; then
    . /usr/local/etc/bash_completion
fi

# set PATH so it includes user's private bin if it exists
if [ -d "/usr/local/bin" ] ; then
    PATH="/usr/local/bin:/usr/local/sbin:"`echo $PATH | sed 's|:/usr/local/bin||' | sed 's|:/usr/local/sbin||'`
fi

if [ -d "/usr/local/share/python" ] ; then
    PATH="/usr/local/share/python":$PATH
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin/tools" ] ; then
    PATH="$HOME/bin/tools:$PATH"
fi
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local" ] ; then
    PATH="$HOME/.local/bin:$HOME/.local/sbin:$PATH"
fi

#if [ -d "$HOME/.gem" ]; then
#    PATH=$PATH:$HOME/.gem/bin
# fi

PATH=./venv/bin:./pyenv/bin:$PATH
export PATH

