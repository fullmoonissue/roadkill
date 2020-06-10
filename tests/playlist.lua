local lu = require('luaunit')
local playlist = require('src/playlist')

-- Replace the texts in tests
require('src/ui/i18n').getTranslations().playlistTexts = {
    ['work-before-all'] = 'text-work-before-all',
    ['work-start'] = 'text-work-start',
    ['work-items'] = 'text-work-items',
    ['work-end'] = 'text-work-end',
    ['work-after-all'] = 'text-work-after-all',
}

-- Replace the initial readdir to avoid calling "real" VLC calls in tests
local _vlc_ = require('src/vlc')
_vlc_.readdir = function()
    return {
        'work-item-1.lua',
        'work-item-2.lua',
    }
end

function testAddItem()
    local playlists = {}
    playlist.addItem(
        'item-name',
        {
            ['url'] = 'http://item-url',
            ['duration'] = 15,
        },
        playlists
    )
    lu.assertEquals(
        {
            {
                ['name'] = 'item-name',
                ['path'] = 'http://item-url',
                ['options'] = {
                    'stop-time=15'
                },
            }
        },
        playlists
    )

    playlists = {}
    playlist.addItem(
        'item-name',
        {
            ['file'] = 'item-file',
            ['start'] = 20,
        },
        playlists
    )
    lu.assertEquals(
        {
            {
                ['name'] = 'item-name',
                ['path'] = 'file://item-file',
                ['options'] = {
                    'start-time=20'
                },
            }
        },
        playlists
    )

    playlists = {}
    playlist.addItem(
        'item-name',
        {
            ['folder'] = 'item-folder',
        },
        playlists
    )
    lu.assertEquals(
        {
            {
                ['name'] = 'item-name',
                ['path'] = 'file://item-folder/work-item-1.lua',
                ['options'] = {},
            },
            {
                ['name'] = 'item-name',
                ['path'] = 'file://item-folder/work-item-2.lua',
                ['options'] = {},
            },
        },
        playlists
    )
end

function testAddItems()
    local playlists = {}
    playlist.addItems(
        'item-name',
        {
            {
                ['file'] = 'item-file',
            }
        },
        playlists
    )
    lu.assertEquals(
        {
            {
                ['name'] = 'item-name',
                ['path'] = 'file://item-file',
                ['options'] = {},
            }
        },
        playlists
    )
end

function testCompile()
    local playlists = {}
    playlist.compile(
        {
            ['work-before-all'] = {
                ['file'] = 'item-file-work-before-all'
            },
            ['work-start'] = {
                ['file'] = 'item-file-work-start'
            },
            ['work-items'] = {
                {
                    ['file'] = 'item-file-work-item-1'
                },
                {
                    ['file'] = 'item-file-work-item-2'
                },
            },
            ['work-end'] = {
                ['file'] = 'item-file-work-end'
            },
            ['work-after-all'] = {
                ['file'] = 'item-file-work-after-all'
            },
        },
        playlists
    )
    lu.assertEquals(
        {
            {
                ['name'] = 'text-work-before-all',
                ['path'] = 'file://item-file-work-before-all',
                ['options'] = {},
            },
            {
                ['name'] = 'text-work-start',
                ['path'] = 'file://item-file-work-start',
                ['options'] = {},
            },
            {
                ['name'] = 'text-work-items',
                ['path'] = 'file://item-file-work-item-1',
                ['options'] = {},
            },
            {
                ['name'] = 'text-work-end',
                ['path'] = 'file://item-file-work-end',
                ['options'] = {},
            },
            {
                ['name'] = 'text-work-start',
                ['path'] = 'file://item-file-work-start',
                ['options'] = {},
            },
            {
                ['name'] = 'text-work-items',
                ['path'] = 'file://item-file-work-item-2',
                ['options'] = {},
            },
            {
                ['name'] = 'text-work-end',
                ['path'] = 'file://item-file-work-end',
                ['options'] = {},
            },
            {
                ['name'] = 'text-work-after-all',
                ['path'] = 'file://item-file-work-after-all',
                ['options'] = {},
            },
        },
        playlists
    )
end

function testCompileItem()
    local workItems = {}
    local workItem = {
        ['file'] = 'file',
        ['duration'] = 15,
        ['start'] = 5,
    }
    playlist.compileItem(workItem, workItems)
    lu.assertEquals(
        { workItem },
        workItems
    )

    workItems = {}
    workItem = {
        ['folder'] = 'tests',
        ['nbElements'] = 1,
        ['duration'] = 15,
        ['start'] = 5,
    }
    playlist.compileItem(workItem, workItems)
    lu.assertEquals(
        {
            {
                ['file'] = 'tests/work-item-1.lua',
                ['duration'] = 15,
                ['start'] = 5,
            }
        },
        workItems
    )

    workItems = {}
    workItem = {
        ['folder'] = 'tests',
        ['loop'] = 2,
    }
    playlist.compileItem(workItem, workItems)
    lu.assertEquals(
        {
            {
                ['file'] = 'tests/work-item-1.lua',
            },
            {
                ['file'] = 'tests/work-item-1.lua',
            },
            {
                ['file'] = 'tests/work-item-2.lua',
            },
            {
                ['file'] = 'tests/work-item-2.lua',
            },
        },
        workItems
    )
end

os.exit(lu.LuaUnit.run())