#!/usr/bin/bash

outFile=`echo $1 | cut -f 1 -d .`.md
echo "[Back to index](index.html)" > $outFile
cat $1 | sed -z s/\{-// | sed s/-\}/\`\`\`haskell/ | sed s/\{-/\`\`\`/ >> $outFile
echo \`\`\` >> $outFile
echo "[Back to index](index.html)" >> $outFile
