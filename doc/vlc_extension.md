# VLC Extension

## How to

If you want to create an extension for VLC, here are the functions to declare :

* descriptor() : This function allows to discover your VLC extension into the VLC menu about extensions (must return a lua table)
* activate() : This function is called when you select the extension into the VLC menu about extensions
* close() : This function is called when you close a dialog box (if one is created for the extension)
* deactivate() : This function is called when you re-select (unselect) the extension into the VLC menu about extensions

## External links

These pages helped me to create the extension :

- [🔗](https://www.videolan.org/developers/vlc/share/lua/README.txt) The listing of the available lua modules for VLC
- [🔗](https://github.com/exebetche/vlsub/blob/master/vlsub.lua) The VLSub Extension
- [🔗](https://wiki.videolan.org/VLC_command-line_help) The options for command line (used too for items' playlist)