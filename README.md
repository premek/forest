
[![Build Status](https://travis-ci.org/premek/forest.svg?branch=master)](https://travis-ci.org/premek/forest)

## Playing online
Demo web build available here: http://premek.github.io/forest/

## Downloading and running
For the latest relased version, download it from the [releases](https://github.com/premek/forest/releases) page.

### Windows executable
- Download **Forest-win.zip** version
- unpack
- run the **.exe** file

### Linux, Mac OS
- Download **.love** file
- Install LÖVE from your repository or from the [LÖVE website](https://love2d.org/)
- Doubleclick on the .love file or run `love *.love` where *.love is the file you downloaded

### Source code
For testing the **latest version from git**:
- clone the repository with `git clone https://github.com/premek/forest.git`
- OR download the [latest ZIPped sources](https://github.com/premek/forest/archive/master.zip)

#### Linux
- you can run `build.sh` to produce **.love** file and ZIP with **Windows executable**
- or with [LÖVE](https://love2d.org/) installed, you can also run it with `love path/to/src` (path to the directory containing main.lua file)

#### Windows
- install [LÖVE](https://love2d.org/)
- drag and drop downloaded 'src' folder onto love.exe
- OR run it with `love path/to/src` (path to the directory containing main.lua file) from command line

## Playing
Controls for the demo:
- arrows - move (different for each character)
- tab - switch characters
- space - drop the held item
- Esc - quit
- d - debug view
- r - restart level
- . - next level


## Reporting Bugs
Please fill in a [new issue](https://github.com/premek/forest/issues/new) on GitHub

## Thanks
- Powered by [LÖVE](https://love2d.org/)
- Written in Lua
- Maps made with [Tiled](http://www.mapeditor.org/)
- Web build possible thanks to https://github.com/TannerRogalsky/love.js
- Autobuilds of Windows binaries, .love, web builds and deployment to GitHub Releases and GitHub Pages by [Travis CI](https://travis-ci.org/)
- Game idea by @Khanecz
