# Roadkill Composition File

Roadkill helps to create a playlist. Here are the steps :

1. Thanks to the ui, a [file](#composition-file) will be created
2. After selecting the file to load, a playlist will be created
3. The playlist will be given to vlc and launched jsut after

## Composition file

A composition is a lua table, containing some [root keys](#root-keys) with [items](#items) (lua tables) inside, written into a file.

## Root keys

* `work-before-all` : if you want a medium to be launched only once at the beginning of the playlist
* `work-start` : if you want a medium to be launched before every items
* `work-items` : items
* `work-end` : if you want a medium to be launched after every items
* `work-after-all` : if you want a medium to be launched only once at the end of the playlist

## Items

Here are the list of accepted medium with their associated keys.

### File

* Required
  * `file`, location of the medium to add to the playlist.
* Optional
  * `startAt`, time (in seconds) when the medium starts.
  * `stopAt`, time (in seconds) when the medium stops.

### Folder

* Required
  * `folder`, location of the folder to scan (then add the files to the playlist).
* Optional
  * `random`, select media randomly.
  * `loop`, number of repetition of an item.
  * `nbElements`, number of media to keep.
  * any of the optional keys from [File](#file)

### Url

* Required
  * `url`, url of the medium.

## Examples of composition file

### Tabata Training

[Description](https://en.wikipedia.org/wiki/High-intensity_interval_training#Tabata_regimen)

```
return {
    ['work-before-all'] = {
        ['file'] = '/path/to/musics/warm-up.mp3',
        ['stopAt'] = 5 * 60, -- 5 minutes
    },
    ['work-end'] = {
        ['file'] = '/path/to/musics/take-a-break.mp3',
        ['stopAt'] = 10,
    },
    ['work-items'] = {
        {
            ['folder'] = '/path/to/videos/tabata',
            ['random'] = true,
            ['loop'] = 8,
            ['nbElements'] = 6,
            ['stopAt'] = 20,
        },
    },
}
```

### Pomodoro Timing

[Description](https://en.wikipedia.org/wiki/Pomodoro_Technique)

```
return {
    ['work-start'] = {
        ['file'] = '/path/to/musics/get-ready.mp3',
        ['stopAt'] = 5,
    },
    ['work-items'] = {
        {
            ['file'] = '/path/to/todos/todo-1.png',
            ['stopAt'] = 25 * 60, -- 25 minutes
        },
        {
            ['file'] = '/path/to/musics/chill.mp3',
            ['stopAt'] = 5 * 60, -- 5 minutes
        },
        {
            ['file'] = '/path/to/todos/todo-2.png',
            ['stopAt'] = 25 * 60, -- 25 minutes
        },
        {
            ['file'] = '/path/to/musics/chill.mp3',
            ['stopAt'] = 5 * 60, -- 5 minutes
        },
        {
            ['file'] = '/path/to/todos/todo-3.png',
            ['stopAt'] = 25 * 60, -- 25 minutes
        },
        {
            ['file'] = '/path/to/musics/chill.mp3',
            ['stopAt'] = 5 * 60, -- 5 minutes
        },
        {
            ['file'] = '/path/to/todos/todo-4.png',
            ['stopAt'] = 25 * 60, -- 25 minutes
        },
        {
            ['file'] = '/path/to/musics/long-chill.mp3',
            ['stopAt'] = 25 * 60, -- 25 minutes
        },
    },
    ['work-end'] = {
        ['file'] = '/path/to/musics/take-a-break.mp3',
        ['stopAt'] = 5,
    },
}
```