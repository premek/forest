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


### .love 

cd src
zip -9 -r - . > "../target/${P}.love"
cd ..

### .exe

tmp=`mktemp -d 2>/dev/null || mktemp -d -t 'mytmpdir'`
mkdir "$tmp/$P"
cat "$LD/love.exe" "target/${P}.love" > "$tmp/${P}/${P}.exe"
cp "$LD"/*dll "$LD"/license* "$tmp/$P"
cd "$tmp"
zip -9 -r - "$P" > "${P}-win.zip"
cd -
cp "$tmp/${P}-win.zip" "target/"
rm -r "$tmp"


### web

cd target
git clone https://github.com/TannerRogalsky/love.js.git
cd love.js
git checkout 6fa910c2a28936c3ec4eaafb014405a765382e08
git submodule update --init --recursive

cd debug
python ../emscripten/tools/file_packager.py game.data --preload ../../src/@/ --js-output=game.js
cd ../..
mv love.js/release-compatibility "$P-web"
zip -9 -r - "$P-web" > "${P}-web.zip"
# target/Forest-web/ goes to webserver
