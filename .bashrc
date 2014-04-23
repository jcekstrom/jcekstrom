# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# some git stuff
parse_git_branch() {
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[01;32m\]"
BLUE="\[\033[01;34m\]"
GREY="\[\033[01;30m\]"
CLEAR="\[\033[00m\]"

PS1="$YELLOW\u@\h$CLEAR:$GREY\w$CLEAR$YELLOW\$(parse_git_branch)$CLEAR\$ "
#PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;30m\]\w\[\033[00m\]\$ '

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# This is used in conjuntion with python virtualenv package
# create a new env in ~/.pyenv then just "activate name" and it will use that python env
activate() {
    if (( $# )); then
        source ~/.pyenv/$1/bin/activate
    else
        if [ -f pyenv/bin/activate ]; then
            source pyenv/bin/activate
        else
            if [ -f .pyenv/bin/activate ]; then
                source .pyenv/bin/activate
            fi
        fi
    fi
}

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

if [ -f $(brew --prefix)/share/bash-completion/bash_completion ]; then
    . $(brew --prefix)/share/bash-completion/bash_completion
fi

#export CLICOLOR_FORCE=1
export CLICOLOR=1
export LESS="-R"

export EDITOR=vim

if [[ $TERM == 'screen' ]]; then
    export SSH_AUTH_SOCK=$HOME/.screen_ssh_auth_sock
else
    # If this is an SSH session, link to this SSH_AUTH_SOCK
    rm -f $HOME/.screen_ssh_auth_sock
    ln -sf $SSH_AUTH_SOCK $HOME/.screen_ssh_auth_sock
fi
# If this is a shell inside of screen... Always point to SSH_AUTH_SOCK symlink
alias pyclean="find . -iname '*.pyc' | xargs rm -f"
alias gff="git flow feature"

alias qss='curl -H "X-User-Id: 2" -H "X-Device-Id: e878f9b1-b793-5eba-9422-642b2b738ab0"'
