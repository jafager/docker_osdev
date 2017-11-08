umask 077

PSHOSTNAME='osdev'
PSPREPROMPT='\[\e[1;92m\]${PSHOSTNAME}\[\e[0m\]:\[\e[1;37m\]$(/usr/local/bin/abbreviate_cwd)\[\e[0m\] \[\e[1;90m\]'
PSPOSTPROMPT='\[\e[0m\]'
export PS1="${PSPREPROMPT}\\\$${PSPOSTPROMPT} "
export PS2="${PSPREPROMPT}>${PSPOSTPROMPT} "

export PATH="/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"

export EDITOR="vim"
export VISUAL="${EDITOR}"
