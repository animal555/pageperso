#!/usr/bin/bash

somethingUpdated=false

if ! [[ "$1" =~ ^\. ]] && [[ "$1" != "" ]]; then
  if ! (ls $1.index.md &> /dev/null); then
    echo -e "[go back](../index.html)\n" > $1/index.md
  fi

  for i in `ls $1`; do
    if ! [[ "$i" == "index.html" ]] && ! [[ "$i" == "index.md" ]] && ! ((cat $1/index.md | grep "\[$i\]") &> /dev/null); then
       echo -e "[$i]($i)\n" >> $1/index.md
       somethingUpdated=true
    fi
  done
  if [[ "$somethingUpdated" == "true" ]]; then 
    pandoc -s --css ../static/style.css --template=htmltemplate.html -f markdown $1/index.md > $1/index.html
  fi
fi
