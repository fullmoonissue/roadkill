# Roadkill

## Introduction

Roadkill is a VLC Extension to setup a playlist with work / break sequences.

### About the name

`Roadkill` is the name of the rat which follows `Sketch Turner` in the `Comix Zone` adventure.

## Enable the extension

ℹ️ Tested with :
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

- [Changelog](./CHANGELOG.md)
- [Composition](./doc/composition.md)
- [VLC Extension](./doc/vlc_extension.md)

## License

MIT

## Troubleshooting

**Want to show an image during x seconds but it's only displayed during y seconds**

To display during a long time an image on VLC, you have to setup a duration located in : `Settings` > `Codecs` (`All`) > `Demux` > `Image`.

Either the value will be bigger than the desired number of seconds or the value will be -1 (display indefinitely).

**I have set a duration for an url but the video isn't stopping at the desired time**

No way has been found to handle that. None of the file / folder options works for an url.
Neither with VLC options nor with embedded url containing query parameters (ex. with youtube : `https://www.youtube.com/embed/...?end=...`).

**I try to make many list actions (ex: move up then update) in a row but only the first action works**

When a row is selected in the list and an action is perform (ex: move up), the list is cleared then refilled (to update entries), the item selected is lost at this moment.
You have to select an other time the item you want to make an action on.

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