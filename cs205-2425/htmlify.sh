#!/usr/bin/bash

./mdify.sh $1
outFile=`echo $1 | cut -f 1 -d .`
pandoc -s --css style.css --template=htmltemplate.html --syntax-highlighting=breezedark -f markdown $outFile.md > $outFile.html
