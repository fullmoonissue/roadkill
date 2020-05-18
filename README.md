# Roadkill

## Introduction

Roadkill is a VLC Extension to setup work / break sequences.

This project was made just to know how to create a VLC Extension.

### About the name

`Roadkill` is the name of the rat which follows `Sketch Turner` in the `Comix Zone` adventure.

### How to create a VLC Extension

If you want to create a VLC extension, here are the functions to declare :

* descriptor() : This function allows to discover your VLC extension into the VLC menu about extensions
* activate() : This function is called when you select the extension into the VLC menu about extensions
* close() : This function is called when you close a dialog box (if at least one is created for the extension)
* deactivate() : This function is called when you re-select (unselect) the extension into the VLC menu about extensions

## Setup

First, `git clone` or download the project.

In the `roadkill.lua` file, you have to fill the `configuration` variable.

The root keys that will be treated are :

* work-start : if you want a medium to be launched before every exercices
* work-end : if you want a medium to be launched after every exercices
* work-items : exercices (as a list of medium)

Media and their associated keys :

1] File

* The key `file` is awaited with a path as value.
* The key `duration` can be set with a duration in seconds as value.

⚠️ Be aware that if the medium is an image, look at the menu `Codecs` > `Demux` > `Image` properties and assign to the duration a bigger value than yours (or -1 to show the image indefinitely).

2] Folder

* The key `folder` is awaited with a path as value.
* The key `random` can be set with a boolean as value.
* The key `nbElements` can be set with an integer as value (to keep only a fragment of all elements in the folder).
* The key `duration` can be set with a duration in seconds as value.

⚠️ Same warning as `1] File`

3] Url

* The key `url` is awaited with an url as value.

⚠️ The duration can't be defined (neither the VLC `stop-time` option nor the url of youtube (for example) with an `end` flag in the url isn't working).

### Examples

1] Tabata Training

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

2] Pomodoro Timing

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

3] New language training exercices

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

ℹ️ Take note that the paths and menus displayed are for the french version 3.0.10 of VLC on Mac.

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
- [🔗](https://wiki.videolan.org/VLC_command-line_help) The options for command line (and items into the playlist)

## Licence

MIT

## Changelog

* 2.0.0 : Configuration is now done into a lua table (and the dialog box was removed)
* 1.0.0 : Initial deploy (configuration by specific files and folders)