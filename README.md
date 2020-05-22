# Roadkill

## Introduction

Roadkill is a VLC Extension to setup a playlist with work / break sequences.

At first, this project was made just to know how to create a VLC Extension.

### About the name

`Roadkill` is the name of the rat which follows `Sketch Turner` in the `Comix Zone` adventure.

### How to create a VLC Extension

If you want to create a VLC extension, here are the functions to declare :

* descriptor() : This function allows to discover your VLC extension into the VLC menu about extensions (must return a lua table)
* activate() : This function is called when you select the extension into the VLC menu about extensions
* close() : This function is called when you close a dialog box (if at least one is created for the extension)
* deactivate() : This function is called when you re-select (unselect) the extension into the VLC menu about extensions

## Setup

First, `git clone` or [download](https://github.com/fullmoonissue/roadkill/archive/master.zip) (then unzip) the project.

In the `roadkill.lua` file, you have to fill the `configuration` variable.

**Root keys**

* `work-before-all` : if you want a medium to be launched only once at the beginning of the playlist
* `work-start` : if you want a medium to be launched before every exercices
* `work-items` : exercices (as a list of medium)
* `work-end` : if you want a medium to be launched after every exercices
* `work-after-all` : if you want a medium to be launched only once at the end of the playlist

**Type of medium and associated keys**

_File (image, sound, video)_

* Required
  * `file`, location of the medium to add to the playlist.
* Optional
  * `duration`, duration (in seconds) of the medium (have to be bigger than `start` (if set)).
  * `start`, time (in seconds) when the medium start.

_Folder_

* Required
  * `folder`, location of the folder to scan (then add the files to the playlist).
* Optional
  * `random`, select media randomly.
  * `loop`, number of repetition of an item.
  * `nbElements`, number of media to keep.
  * any of the optional keys from `File`

_Url_

* Required
  * `url`, url of the medium.

⚠️ No option can be defined.

ℹ️ Neither VLC options nor embedded url with query parameters (like with youtube) works.

### Examples

_Tabata Training_

```
local configuration = {
    ['work-before-all'] = {
        ['file'] = '/path/to/musics/warm-up.mp3',
        ['duration'] = 5 * 60, -- 5 minutes
    },
    ['work-end'] = {
        ['file'] = '/path/to/musics/take-a-break.mp3',
        ['duration'] = 10,
    },
    ['work-items'] = {
        {
            ['folder'] = '/path/to/videos/tabata',
            ['random'] = true,
            ['loop'] = 8,
            ['nbElements'] = 6,
            ['duration'] = 20,
        },
    },
}
```

_Pomodoro Timing_

```
local configuration = {
    ['work-start'] = {
        ['file'] = '/path/to/musics/get-ready.mp3',
        ['duration'] = 5,
    },
    ['work-items'] = {
        {
            ['file'] = '/path/to/todos/todo-1.png',
            ['duration'] = 25 * 60, -- 25 minutes
        },
        {
            ['file'] = '/path/to/musics/chill.mp3',
            ['duration'] = 5 * 60, -- 5 minutes
        },
        {
            ['file'] = '/path/to/todos/todo-2.png',
            ['duration'] = 25 * 60, -- 25 minutes
        },
        {
            ['file'] = '/path/to/musics/chill.mp3',
            ['duration'] = 5 * 60, -- 5 minutes
        },
        {
            ['file'] = '/path/to/todos/todo-3.png',
            ['duration'] = 25 * 60, -- 25 minutes
        },
        {
            ['file'] = '/path/to/musics/chill.mp3',
            ['duration'] = 5 * 60, -- 5 minutes
        },
        {
            ['file'] = '/path/to/todos/todo-4.png',
            ['duration'] = 25 * 60, -- 25 minutes
        },
        {
            ['file'] = '/path/to/musics/long-chill.mp3',
            ['duration'] = 25 * 60, -- 25 minutes
        },
    },
    ['work-end'] = {
        ['file'] = '/path/to/musics/take-a-break.mp3',
        ['duration'] = 5,
    },
}
```

## Process

ℹ️ Take note that the paths and menus displayed are for the version 3.0.10 of VLC on Mac.

### Enable the extension

When the [setup](#setup) is done, you have to symlink the `roadkill.lua` file into the VLC's extensions folder.

    cd /Applications/VLC.app/Contents/MacOS/share/lua/extensions
    ln -s /path/to/roadkill/roadkill.lua roadkill.lua

Then :

1. (Re)Launch VLC
2. Menu > VLC > Extensions > Roadkill

## Documentation

The pages that helped me to create it were :

- [🔗](https://www.videolan.org/developers/vlc/share/lua/README.txt) The listing of the available lua modules for VLC
- [🔗](https://github.com/exebetche/vlsub/blob/master/vlsub.lua) The existing VLSub Extension
- [🔗](https://wiki.videolan.org/VLC_command-line_help) The options for command line (which are the same for items added into the playlist)

## License

MIT

## Troubleshooting

**Wanted to show an image during x seconds, it's only displayed during y seconds**

To display during a long time an image on VLC, you have to setup a duration located in : `Settings` > `Codecs` (`All`) > `Demux` > `Image`.

Either the value will be bigger than the desired number of seconds or the value will be -1 (display indefinitely).

## Development

### VLC

**Messages (debug, ...)**

VLC brings a way to add messages (`vlc.msg.dgb('...')`, ...) that you will be able to see after opening the associated window (`Window` > `Messages...`).

All types of messages are explained in the [documentation](https://www.videolan.org/developers/vlc/share/lua/README.txt), section `Messages`.

### Code Style

    # First, install luacheck (sudo may be required)
    make install
    # Then, launch the check
    make cs-check

### Tests

    # First, install luanit (sudo may be required)
    make install
    # Then, launch the tests
    make test

## Changelog

* 2.5.0
  * (Feature) Customize file name displayed in vlc
* 2.4.1
  * (Clean) Add validations on configuration
  * (Clean) Setup and add tests
    * Luanit installed
    * Makefile task added (install & test)
  * (Clean) Code Style Checker
    * Luacheck installed
    * Makefile task added (install & cs-check)
* 2.4.0
  * (Feature) Add `loop` for `folder` to repeat many times an item
* 2.3.1
  * (Fix) `folder` key not correctly treated in root keys other than `work-items`
  * (Fix) `duration` have to be absolute, not relative to `start`
  * (Fix) Randomization not correctly handled if `shuffle()` is called multiple times on the same second
  * (Clean) Code quite rewritten
* 2.3.0
  * (Feature) All root keys can handle single or multiple item(s)
* 2.2.0
  * (Feature) Add `work-before-all` and `work-after-all` root keys
  * (Fix) `duration` not correct if `start` is set
* 2.1.0
  * (Feature) Add `start` option
* 2.0.0
  * (BC Break) Configuration is now done into a lua table and the dialog box was removed
* 1.0.0
  * (Feature) Initial deploy (configuration made by specific files and folders)