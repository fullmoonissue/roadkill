# Roadkill

## Introduction

Roadkill is a VLC Extension to setup work / break sequences.

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

The root keys that will be treated are :

* `work-start` : if you want a medium to be launched before every exercices
* `work-end` : if you want a medium to be launched after every exercices
* `work-items` : exercices (as a list of medium)

**Type of medium and associated keys**

_File (image, sound, video)_

* Required
  * `file`, location of the medium to add to the playlist.
* Optional
  * `duration`, duration (in seconds) of the medium.
  * `start`, time (in seconds) when the medium start.

_Folder_

* Required
  * `folder`, location of the folder to scan (then add the files to the playlist).
* Optional
  * `random`, select randomly media.
  * `nbElements`, number of selected media.
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
    ['work-end'] = {
        ['file'] = '/path/to/musics/take-a-break.mp3',
        ['duration'] = 10,
    },
    ['work-items'] = {
        {
            ['file'] = '/path/to/videos/burpees.mp4',
            ['duration'] = 20,
        },
        {
            ['file'] = '/path/to/videos/burpees.mp4',
            ['duration'] = 20,
        },
        {
            ['file'] = '/path/to/videos/sprint.mp4',
            ['duration'] = 20,
        },
        {
            ['file'] = '/path/to/videos/sprint.mp4',
            ['duration'] = 20,
        },
        -- ...
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
    ['work-end'] = {
        ['file'] = '/path/to/musics/take-a-break.mp3',
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
}
```

_New language training exercices_

```
local configuration = {
    ['work-items'] = {
        {
            ['folder'] = '/path/to/language-exercices-folder',
            ['random'] = true,
            ['nbElements'] = 20,
            ['duration'] = 10,
        },
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

The two pages that helped me to create it were :

- [🔗](https://www.videolan.org/developers/vlc/share/lua/README.txt) The listing of the available lua modules for VLC
- [🔗](https://github.com/exebetche/vlsub/blob/master/vlsub.lua) The existing VLSub Extension
- [🔗](https://wiki.videolan.org/VLC_command-line_help) The options for command line (which are the same for items added into the playlist)

## Licence

MIT

## Troubleshooting

**Wanted to show an image during x seconds, it's only displayed during y seconds**

To display during a long time an image on VLC, you have to setup a duration located in : `Settings` > `Codecs` (`All`) > `Demux` > `Image`.

Either the value will be bigger than the desired number of seconds or the value will be -1 (display indefinitely).

## Development

**Messages (debug, ...)**

VLC brings a way to add messages (`vlc.msg.dgb('...')`, ...) that you will be able to see after opening the associated window (`Window` > `Messages...`).

All types of messages are written in the [documentation](https://www.videolan.org/developers/vlc/share/lua/README.txt), section `Messages`.

## Changelog

* 2.1.0 : Add `start` option
* 2.0.0 : Configuration is now done into a lua table (and the dialog box was removed)
* 1.0.0 : Initial deploy (configuration made by specific files and folders)