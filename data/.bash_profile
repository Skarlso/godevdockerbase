#!/bin/bash

# If id command returns zero, you’ve root access.
if [ $(id -u) -eq 0 ];
then # you are root, set red colour prompt
  PS1="\\[$(tput setaf 1)\\]\\u@\\h:\\w #\\[$(tput sgr0)\\]"
else # normal
  PS1="[\t \\u@\\h:\\w] $ "
fi

alias ll='ls -l'
