# Changelog

* 3.4.6
  * (UI) Fix (auto-)save, error on boolean values
* 3.4.5
  * (UI) Allow to save an empty composition (put in 3.3.1, reverted)
  * (UI) Remove the feedback about the save of a composition (useless now)
* 3.4.4
  * (UI) Add a label which indicates the current displayed list
  * (UI) Display a message if the imported composition is not valid
  * (UI) Auto-save
* 3.4.3
  * (Troubleshooting) Add an element about multiple actions on list
  * (Test) Add an audit about the catalog of translations
* 3.4.2
  * (i18n) Add references (to reuse translations)
  * (i18n) Clean keys
  * (UI) Add the forgotten last position to shift / duplicate
* 3.4.1
  * (i18n) Add translations for features from 3.4.0
  * (i18n) Replace `duration` by `stop at` (to avoid confusion)
  * (i18n) Replace `start` by `start at` (to keep the semantic with `stop at`)
  * (i18n) Replace `exercice` by `item` (to generalize)
  * (i18n) Replace `configuration` by `composition` (more precise)
* 3.4.0
  * (Feature) Move elsewhere an item
  * (Feature) Duplicate an item
  * (UI) Merge buttons (move, update, ...) into two lists
* 3.3.1
  * (UI) Save not allowed if no items set
  * (UI) Block the creation of a configuration file which already exists
  * (Clean) Replace all `..` by `string.format()`
* 3.3
  * (Feature) Allow to update a line in the listing of items
  * (Feature) Internationalization (en & fr)
* 3.2
  * (Feature) Items position can be moved up / down
  * (Feature) UI validation
  * (UI) Dashboard updated
  * (UI) Items listing split by root keys (and line format changed)
  * (Clean) WIP fields moved
  * (Clean) Roadkill file (in /ui) renamed
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
  * (Doc) Add `Troubleshooting` section in the README
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