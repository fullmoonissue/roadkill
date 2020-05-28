# Roadkill

## Introduction

Roadkill is a VLC Extension to setup a playlist with work / break sequences.

### About the name

`Roadkill` is the name of the rat which follows `Sketch Turner` in the `Comix Zone` adventure.

### How to create a VLC Extension

If you want to create a VLC extension, here are the functions to declare :

* descriptor() : This function allows to discover your VLC extension into the VLC menu about extensions (must return a lua table)
* activate() : This function is called when you select the extension into the VLC menu about extensions
* close() : This function is called when you close a dialog box (if at least one is created for the extension)
* deactivate() : This function is called when you re-select (unselect) the extension into the VLC menu about extensions

### Glossary

**Configuration**

The meaning of the ui is to create (and launch) a configuration file (which prepare a playlist for VLC).

A configuration is a lua table, containing some root keys with items (lua tables) inside, written into a file.

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

### Examples of configuration file

_Tabata Training_

```
return {
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
return {
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

## Enable the extension

ℹ️  Tested with :
- VLC version : 3.0.10
- OS : Mac

**First**

    git clone https://github.com/fullmoonissue/roadkill.git
    or
    Download the project https://github.com/fullmoonissue/roadkill/archive/master.zip then unzip it

**Then**

    cd /Applications/VLC.app/Contents/MacOS/share/lua/extensions
    ln -s /path/to/project/roadkill roadkill
    ln -s roadkill/entrypoint.lua roadkill.lua

**Finally**

1. (Re)Launch VLC
2. Menu > VLC > Extensions > Roadkill

## Documentation

The pages that helped me to create it were :

- [🔗](https://www.videolan.org/developers/vlc/share/lua/README.txt)  The listing of the available lua modules for VLC
- [🔗](https://github.com/exebetche/vlsub/blob/master/vlsub.lua)  The VLSub Extension
- [🔗](https://wiki.videolan.org/VLC_command-line_help)  The options for command line (which are the same for items added into the playlist)

## License

MIT

## Troubleshooting

**Want to show an image during x seconds but it's only displayed during y seconds**

To display during a long time an image on VLC, you have to setup a duration located in : `Settings` > `Codecs` (`All`) > `Demux` > `Image`.

Either the value will be bigger than the desired number of seconds or the value will be -1 (display indefinitely).

**I have set a duration for an url but the video isn't stopping at the desired time**

No way has been found to handle that. None of the file / folder options works for an url.
Neither with VLC options nor with embedded url containing query parameters (ex. with youtube : `https://www.youtube.com/embed/...?end=...`).

## Development

### VLC

**Messages (debug, ...)**

VLC brings a way to add messages (`vlc.msg.dgb('...')`, ...) that you will be able to see after opening the associated window (`Window` > `Messages...`).

All existing types of messages are in the [documentation](https://www.videolan.org/developers/vlc/share/lua/README.txt), section `Messages`.

### Code Style

    # First, install luacheck (launching command with sudo may be required)
    make install-luacheck

    # Then, launch the checks
    make cs-check

### Tests

    # First, install luanit (launching command with sudo may be required)
    make install-luaunit

    # Then, launch the tests
    make test

### Changelog

Over [here](./CHANGELOG.md)

### Roadmap

Over [there](./ROADMAP.md)