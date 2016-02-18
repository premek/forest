#!/usr/bin/env bash

set -x

P="Forest"
LD="love-0.10.1-win32"


if [ "$1" == "clean" ]; then 
 rm -r "target"
 exit;
fi


find . -iname "*.lua" | xargs luac -p || { echo 'luac parse test failed' ; exit 1; }

mkdir "target"

cd src
zip -9 -r - . > "../target/${P}.love"
cd ..

tmp=`mktemp -d 2>/dev/null || mktemp -d -t 'mytmpdir'`
mkdir "$tmp/$P"
cat "$LD/love.exe" "target/${P}.love" > "$tmp/${P}/${P}.exe"
cp "$LD"/*dll "$LD"/license* "$tmp/$P"
cd "$tmp"
zip -9 -r - "$P" > "${P}.zip"
cd -
cp "$tmp/${P}.zip" "target/"
rm -r "$tmp"
