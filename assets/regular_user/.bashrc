#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

prepend_path(){
	if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    	PATH="$1${PATH:+":$PATH"}"
	fi
}
prepend_path $HOME/.local/bin
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\n\$ '
