#!/usr/bin/zsh
setopt nonomatch

default=(xfce4-terminal)

terminal_options=(gnome-terminal xfce4-terminal konsole qterminal sakura cool-retro-term terminology vte-2.91 lxterminal mate-terminal pantheon-terminal urxvt terminator)
typeset -a workdir_opt=()
typeset -A setworkdir=()

typeset -a disable_terms=()
for i in $terminal_options
do
  if ! whence $i
  then
    disable_terms+=($i)
  fi
done

for i in $disable_terms
do
  typeset -i disable_term=${terminal_options[(i)$i]}
  terminal_options[$disable_term]=()
done

print -l $terminal_options
print -l ${#terminal_options}


setworkdir[konsole]="--workdir <DIR>"
setworkdir[qterminal]="-w <DIR>"
setworkdir[sakura]="-d <DIR>"
setworkdir[cool-retro-term]="--workdir <DIR>"
setworkdir[terminology]="-d <DIR>"
setworkdir[gnome-terminal]="--working-directory=<DIR>"
setworkdir[xfce4-terminal]="--default-working-directory <DIR>"
setworkdir[vte-2.91]="-w <DIR>"
setworkdir[lxterminal]="--working-directory=<DIR>"
setworkdir[mate-terminal]="--working-directory=<DIR>"
setworkdir[pantheon-terminal]="--working-directory=<DIR>"
setworkdir[urxvt]="-cd <DIR>"
setworkdir[terminator]="--working-directory=<DIR>"



term="$(zenity --width=280 --height=400 --list --title="Select your terminal" --column Terminal "${terminal_options[@]}")"

if [[ -n $1 ]]
then
  typeset -a termcmd=(${=term:-$default})
  if [[ -n "${setworkdir[$termcmd[1]]}" ]]
  then
    typeset -a termopt=("${=setworkdir[$termcmd[1]]}")
    typeset -i dirpos=${termopt[(i)*<DIR>*]}
    if $dirpos > ${#termopt}
    then
      exit 2
    else
      termopt[$dirpos]="${termopt[$dirpos]/<DIR>/$1}"
    fi
    termcmd+=("${termopt[@]}")
  else
    termcmd+=("$1")
  fi
  #print -l $termcmd
  exec $termcmd

else
  if [[ -n $term ]]
  then
    print $term
    exec ${=term}
  else
    exec $default
  fi
fi
