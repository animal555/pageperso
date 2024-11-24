#!/usr/bin/bash

somethingUpdated=false

if ! [[ "$1" =~ ^\. ]] && [[ "$1" != "" ]]; then
  if ! (ls $1.index.md &> /dev/null); then
    echo -e "[go back](../index.html)\n" > $1/index.md
  fi
  cd $1
  for i in *; do
    if ! [[ "$i" == "index.html" ]] && ! [[ "$i" == "index.md" ]] && ! ((cat index.md | grep "\[$i\]") &> /dev/null); then
       echo -e "[$i]($i)\n" >> index.md
       somethingUpdated=true
    fi
  done
  cd ..
  if [[ "$somethingUpdated" == "true" ]]; then 
    pandoc -s --css ../static/style.css --template=htmltemplate.html --metadata=title:"here be files" -f markdown $1/index.md > $1/index.html
  fi
fi
