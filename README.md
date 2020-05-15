# Roadkill

## Introduction

Roadkill is a VLC Extension to setup work / break sequences.

This project just represents the will to know how to create a VLC Extension.

### About the name

`Roadkill` is the name of the rat which follows `Sketch Turner` in the `Comix Zone` adventure.

## Setup

In the `assets` folder, you have to put :

- files into the `work` folder (requirement)
- file(s) into the `break` folder (requirement)
- file beginning with `work.` (optional)
- file beginning with `break.` (optional)

## Process

### Enable the extension

First, you have to symlink the `roadkill.lua` file into the VLC's extensions folder.

    # Example for Mac
    
    cd /Applications/VLC.app/Contents/MacOS/share/lua/extensions
    ln -s /path/to/roadkill/roadkill.lua roadkill.lua

Then (_steps for VLC 3.0.10 in a French Installation_) :

1. (Re)Launch VLC
2. Menu > VLC > Extensions > Roadkill

### Configuration

After launching the extension, a dialog box will ask for two pieces of information :

- Path where the assets folder is (cf [Setup](#setup))
- The number of exercices you want

After clicking on `Go !`, the playlist will be filled with (for each exercice) :

- The `work.extension` file (if present)
- One random file from the `work` folder
- The `break.extension` file (if present)
- The file from the `break` folder at the same selected index (from step 2) than the `work/` file (else the first file)

### In practice

Here is a example of usage :

- `work.extension` : sound of someone saying "3, 2, 1, Go !"
- `break.extension` : sound of someone saying "3, 2, 1, Break !"
- `work` folder : images of cardio exercices
- `break` folder : images with questions about a language you want to learn

This example allows to sweat during a period of time and to learn a language when you getting back your breath.

You could also setup the extension like the [Pomodoro Technique](https://en.wikipedia.org/wiki/Pomodoro_Technique).

## Documentation

The two pages that helped me to create it were :

- [🔗](https://www.videolan.org/developers/vlc/share/lua/README.txt) The listing of the available lua modules for VLC
- [🔗](https://github.com/exebetche/vlsub/blob/master/vlsub.lua) The existing VLSub Extension

## Licence

MIT

## Known issue

It's possible to put a specific duration when an element is added to the playlist.
But when an image is added, the duration will not be taken because the timer (for an image) is a global VLC configuration
(in an English Installation, it may be here : Menu > Settings > Codecs > (show all options) Demux > Image > Duration).

## Changelog

* 1.0.0 : Initial deploy