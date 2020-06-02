# Changelog

* 3.1
  * (Feature) Possibility to delete an existing configuration
  * (Feature) Possibility to update an existing configuration
  * (Clean) Add a feedback when a file is saved
  * (Clean) Vlc files merged & ui/form files renamed
  * (Documentation) Move some documentation into a `doc` folder
* 3.0.1
  * (Documentation) New file : Changelog
  * (Documentation) New file : Roadmap
* 3.0.0
  * (Feature) UI
    * Configuration are built thanks to an ui
    * Configuration are saved into files
  * (BC Break) The commands to setup the extension have changed
  * (Clean) Split code across multiple files (require() problem fixed)
  * (Clean) Split tests across multiple files (require() problem fixed)
* 2.5.0
  * (Feature) Customize item's text displayed in vlc
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
  * (MVP) First version (configuration made by specific files and folders)