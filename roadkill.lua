-- --- --- --- --- --- ---
-- [[ Configuration ]]
-- --- --- --- --- --- ---

local configuration = {}

-- --- --- --- --- --- --- --- --- --- --- ---
-- [[ Standalone functions (definitions) ]]
-- It seems that a "package.preload" problem occurs when functions are split across files and when "require" is called
-- So, all functions will be defined just below and tested at the bottom of this file
-- --- --- --- --- --- --- --- --- --- --- ---

--    __  ______________   _____
--   / / / /_  __/  _/ /  / ___/
--  / / / / / /  / // /   \__ \
-- / /_/ / / / _/ // /______/ /
-- \____/ /_/ /___/_____/____/

-- Little function to change a table{...} into table{table{...}} (to always use "for" to traverse what is returned)
local toList = function(tbl)
    if tbl[1] == nil then
        tbl = { tbl }
    end

    return tbl
end

--     ____  ___    _   ______  ____  __  ___
--    / __ \/   |  / | / / __ \/ __ \/  |/  /
--   / /_/ / /| | /  |/ / / / / / / / /|_/ /
--  / _, _/ ___ |/ /|  / /_/ / /_/ / /  / /
-- /_/ |_/_/  |_/_/ |_/_____/\____/_/  /_/

-- Incremental seed, to be sure that the randomization will always be different (in addition to the os.time())
local seed = 0

-- Shuffle a table
-- @see https://gist.github.com/Uradamus/10323382
local function shuffle(tbl)
    seed = seed + 1
    math.randomseed(os.time() + seed)
    for index = #tbl, 2, -1 do
        local random = math.random(index)
        tbl[index], tbl[random] = tbl[random], tbl[index]
    end

    return tbl
end

--  _    ____    ______   ____  ____  ______________  _   _______
-- | |  / / /   / ____/  / __ \/ __ \/_  __/  _/ __ \/ | / / ___/
-- | | / / /   / /      / / / / /_/ / / /  / // / / /  |/ /\__ \
-- | |/ / /___/ /___   / /_/ / ____/ / / _/ // /_/ / /|  /___/ /
-- |___/_____/\____/   \____/_/     /_/ /___/\____/_/ |_//____/

local vlcMethodByOptions = {
    -- VLC option to stop the stream at a certain number of seconds
    {
        option = 'duration',
        method = function(duration)
            return string.format('stop-time=%d', duration)
        end
    },
    -- VLC option to start the stream at a certain number of seconds
    {
        option = 'start',
        method = function(startAt)
            return string.format('start-time=%d', startAt)
        end
    }
}

local vlcGetMethodOption = function(option)
    for _, properties in ipairs(vlcMethodByOptions) do
        if properties['option'] == option then
            return properties['method']
        end
    end
end

--  _    ____    ______
-- | |  / / /   / ____/
-- | | / / /   / /
-- | |/ / /___/ /___
-- |___/_____/\____/

-- VLC wrappers (mocked in tests)

local readdir = function(path)
    return vlc.io.readdir(path)
end

local vlcGo = function(playlistItems)
    -- Stop & Clear the playlist
    vlc.playlist.stop()
    vlc.playlist.clear()
    -- /!\ Important note : the method "vlc.playlist.add" have to be called only once
    -- Multiple call will generate the error "Playlist should be a table"
    vlc.playlist.add(playlistItems)
    -- Do not autoplay the playlist yet (we are at the end of the playlist at this moment)
    vlc.playlist.stop()
    -- Go to first item of the playlist (next() from the end of the playlist brings to the beginning)
    vlc.playlist.next()
    -- Now play it
    vlc.playlist.play()
end

--     ____  __    _____  ____    _______________   __________________  ___
--    / __ \/ /   /   \ \/ / /   /  _/ ___/_  __/  /  _/_  __/ ____/  |/  /
--   / /_/ / /   / /| |\  / /    / / \__ \ / /     / /  / / / __/ / /|_/ /
--  / ____/ /___/ ___ |/ / /____/ / ___/ // /    _/ /  / / / /___/ /  / /
-- /_/   /_____/_/  |_/_/_____/___//____//_/    /___/ /_/ /_____/_/  /_/

-- Transform item with a `folder` key into a list of items with a `file` key
-- Taking care of custom options (randomization, ...)
-- Keep already set VLC options (duration, ...)
local flattenFolderItem = function(workItem, workItems)
    -- If a folder is present ...
    if workItem['folder'] ~= nil then
        -- ... list the valid files ...
        local workFiles = {}
        for _, workFile in ipairs(readdir(workItem['folder'])) do
            if workFile ~= '.' and workFile ~= '..' then
                table.insert(workFiles, workItem['folder'] .. '/' .. workFile)
            end
        end

        -- ... randomize them, if wanted ...
        if workItem['random'] ~= nil and workItem['random'] then
            workFiles = shuffle(workFiles)
        end

        -- ... keep a certain number, if wanted ...
        if workItem['nbElements'] ~= nil then
            local selectedWorkFiles = {}
            for _, workFile in ipairs(workFiles) do
                if workItem['nbElements'] > #selectedWorkFiles then
                    table.insert(selectedWorkFiles, workFile)
                end
            end
            workFiles = selectedWorkFiles
        end

        -- ... repeat items, if wanted ...
        if workItem['loop'] ~= nil then
            local repeatedWorkFiles = {}
            for _, workFile in ipairs(workFiles) do
                for _ = 1, workItem['loop'] do
                    table.insert(repeatedWorkFiles, workFile)
                end
            end
            workFiles = repeatedWorkFiles
        end

        -- ... create new items for each file (and keeping the initial vlc options)
        for _, workFile in ipairs(workFiles) do
            local newWorkItem = {
                ['file'] = workFile
            }
            -- Bring back the options defined for the folder to the new work item
            for _, methodByOption in ipairs(vlcMethodByOptions) do
                if workItem[methodByOption['option']] ~= nil then
                    newWorkItem[methodByOption['option']] = workItem[methodByOption['option']]
                end
            end

            table.insert(workItems, newWorkItem)
        end
    else
        -- ... else, just keep the item as it is
        table.insert(workItems, workItem)
    end
end

-- Add item into the playlist if the item is properly setup
local function addItemToPlaylist(name, properties, playlistItems)
    if properties ~= nil then
        -- if we have a folder :
        -- 1. get items from the folder
        -- 2. add them individually to the playlist
        if properties['folder'] ~= nil then
            local items = {}
            flattenFolderItem(properties, items)
            for _, item in ipairs(items) do
                addItemToPlaylist(name, item, playlistItems)
            end
        else
            -- else, we have an item

            -- check that the protocol (and path) is set ...
            local path
            if properties['url'] ~= nil then
                path = properties['url']
            elseif properties['file'] ~= nil then
                path = 'file://' .. properties['file']
            end

            if path ~= nil then
                -- ... prepare a VLC playlist item ...
                local item = {
                    ['path'] = path,
                    ['name'] = name,
                    ['options'] = {},
                }
                -- ... add vlc options, if wanted
                for _, vlcMethodByOption in ipairs(vlcMethodByOptions) do
                    if properties[vlcMethodByOption['option']] ~= nil then
                        table.insert(
                            item['options'],
                            vlcGetMethodOption(vlcMethodByOption['option'])(properties[vlcMethodByOption['option']])
                        )
                    end
                end

                table.insert(playlistItems, item)
            end
        end
    end
end

-- Iterate overs items to add them into the playlist
local function addItemsToPlaylist(name, items, playlistItems)
    if items ~= nil then
        for index, item in ipairs(toList(items)) do
            addItemToPlaylist(
                string.format(name, index),
                item,
                playlistItems
            )
        end
    end
end

--     ____  ____  ____  ______________________
--    / __ \/ __ \/ __ \/ ____/ ____/ ___/ ___/
--   / /_/ / /_/ / / / / /   / __/  \__ \\__ \
--  / ____/ _, _/ /_/ / /___/ /___ ___/ /__/ /
-- /_/   /_/ |_|\____/\____/_____//____/____/

local function isValid(config, messages)
    if messages == nil then
        messages = {}
    end
    local errorMessage = 'Key "%s" must be a %s in %s'
    local fieldTypes = {
        file = 'string',
        duration = 'number',
        start = 'number',
        folder = 'string',
        random = 'boolean',
        loop = 'number',
        nbElements = 'number',
        url = 'string',
    }

    for _, rootKey in ipairs({'work-before-all', 'work-start', 'work-items', 'work-end', 'work-after-all'}) do
        if config[rootKey] ~= nil then
            for _, item in ipairs(toList(config[rootKey])) do
                for key, fieldType in pairs(fieldTypes) do
                    if item[key] ~= nil then
                        if type(item[key]) ~= fieldType then
                            table.insert(messages, string.format(errorMessage, key, fieldType, rootKey))
                        end
                    end
                end
            end
        end
    end

    return 0 == #messages
end

local function process(config, playlistItems)
    if playlistItems == nil then
        playlistItems = {}
    end
    -- Transform work-items folder into work-items files
    local workItems = {}
    if config['work-items'] ~= nil then
        for _, workItem in ipairs(toList(config['work-items'])) do
            flattenFolderItem(workItem, workItems)
        end
    end
    config['work-items'] = workItems

    -- Prepare all the items to be added to the playlist ...
    -- ... 1. items into the "work-before-all" root key ...
    addItemsToPlaylist('Before Starting !', config['work-before-all'], playlistItems)
    -- ... Then for each "work-items" root key items ...
    for _, workItem in ipairs(config['work-items']) do
        -- ... 2. items into the "work-start" root key
        addItemsToPlaylist('Let\'s Go !', config['work-start'], playlistItems)
        -- ... 3. the current work item
        addItemToPlaylist('Work !', workItem, playlistItems)
        -- ... 4. items into the "work-end" root key
        addItemsToPlaylist('Take a break !', config['work-end'], playlistItems)
    end
    -- ... 5. finally, items into the "work-after-all" root key ...
    addItemsToPlaylist('Finish !', config['work-after-all'], playlistItems)

    -- Give the playlist to VLC
    vlcGo(playlistItems)
end

-- --- --- --- --- --- --- --- ---
-- [[ Roadkill VLC Extension ]]
-- @see "How to create a VLC Extension" in the README.md to understand what is the purpose of each functions
-- --- --- --- --- --- --- --- ---

function descriptor()
    return {
        title = 'Roadkill',
        version = '2.4.1',
        author = 'fullmoonissue',
        url = 'http://www.fullmoonissue.net/',
        shortdesc = 'Roadkill, VLC Extension';
        description = 'Roadkill is a VLC Extension to setup work / break sequences.'
    }
end

function activate()
    if isValid(configuration) then
        process(configuration)
    end
end

function deactivate()
    vlc.msg.dbg('Thanks for using the Roadkill Extension !')
end

-- --- --- --- --- --- --- --- --- ---
-- [[ Standalone functions (tests) ]]
-- The keyword "arg" exists when a command line is called (like when tests are launched)
-- So this is the trick to "hide" this part to vlc when it starts
-- --- --- --- --- --- --- --- --- ---

--   ____________________________
--  /_  __/ ____/ ___/_  __/ ___/
--   / / / __/  \__ \ / /  \__ \
--  / / / /___ ___/ // /  ___/ /
-- /_/ /_____//____//_/  /____/

if arg ~= nil then
    local lu = require('luaunit')
    -- Replace the initial readdir & vlcGo to avoid calling vlc in tests
    readdir = function()
        return {
            'work-item-1.lua',
            'work-item-2.lua',
        }
    end
    vlcGo = function()
        -- do nothing
    end

    -- --- --- --- ---
    -- Test : ToList
    -- --- --- --- ---

    local tbl = { ['file'] = 'file' }
    function testToList()
        lu.assertEquals(
            { tbl },
            toList(tbl)
        )
        lu.assertEquals(
            { tbl },
            toList({ tbl })
        )
    end

    -- --- --- --- --- --- --- ---
    -- Test : VlcGetMethodOption
    -- --- --- --- --- --- --- ---

    local time = 60
    function testVlcGetMethodOption()
        lu.assertEquals(
            'start-time=60',
            vlcGetMethodOption('start')(time)
        )
        lu.assertEquals(
            'stop-time=60',
            vlcGetMethodOption('duration')(time)
        )
    end

    -- --- --- --- --- --- --- ---
    -- Test : FlattenFolderItem
    -- --- --- --- --- --- --- ---

    function testFlattenFolderItem()
        local workItems = {}
        local workItem = {
            ['file'] = 'file',
            ['duration'] = 15,
            ['start'] = 5,
        }
        flattenFolderItem(workItem, workItems)
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
        flattenFolderItem(workItem, workItems)
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
        flattenFolderItem(workItem, workItems)
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

    -- --- --- --- --- --- --- ---
    -- Test : AddItemToPlaylist
    -- --- --- --- --- --- --- ---

    function testAddItemToPlaylist()
        local playlistItems = {}
        addItemToPlaylist(
            'item-name',
            {
                ['url'] = 'http://item-url',
                ['duration'] = 15,
            },
            playlistItems
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
            playlistItems
        )

        playlistItems = {}
        addItemToPlaylist(
            'item-name',
            {
                ['file'] = 'item-file',
                ['start'] = 20,
            },
            playlistItems
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
            playlistItems
        )

        playlistItems = {}
        addItemToPlaylist(
            'item-name',
            {
                ['folder'] = 'item-folder',
            },
            playlistItems
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
            playlistItems
        )
    end

    -- --- --- --- --- --- --- ---
    -- Test : AddItemsToPlaylist
    -- --- --- --- --- --- --- ---

    function testAddItemsToPlaylist()
        local playlistItems = {}
        addItemsToPlaylist(
            'item-name',
            {
                {
                    ['file'] = 'item-file',
                }
            },
            playlistItems
        )
        lu.assertEquals(
            {
                {
                    ['name'] = 'item-name',
                    ['path'] = 'file://item-file',
                    ['options'] = {},
                }
            },
            playlistItems
        )
    end

    -- --- --- --- ---
    -- Test : IsValid
    -- --- --- --- ---

    function testIsValid()
        local messages = {}
        isValid(
            {
                ['work-before-all'] = {
                    ['file'] = 42
                },
                ['work-start'] = {
                    ['duration'] = 'duration',
                },
                ['work-items'] = {
                    ['folder'] = 42,
                    ['random'] = 42,
                    ['loop'] = 'loop',
                    ['nbElements'] = 'nbElements',
                },
                ['work-end'] = {
                    ['url'] = 42
                },
                ['work-after-all'] = {
                    ['start'] = 'start'
                },
            },
            messages
        )
        table.sort(messages)
        lu.assertEquals(
            {
                'Key "duration" must be a number in work-start',
                'Key "file" must be a string in work-before-all',
                'Key "folder" must be a string in work-items',
                'Key "loop" must be a number in work-items',
                'Key "nbElements" must be a number in work-items',
                'Key "random" must be a boolean in work-items',
                'Key "start" must be a number in work-after-all',
                'Key "url" must be a string in work-end'
            },
            messages
        )
    end

    -- --- --- --- ---
    -- Test : Process
    -- --- --- --- ---

    function testProcess()
        local playlistItems = {}
        process(
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
            playlistItems
        )
        lu.assertEquals(
            {
                {
                    ['name'] = 'Before Starting !',
                    ['path'] = 'file://item-file-work-before-all',
                    ['options'] = {},
                },
                {
                    ['name'] = 'Let\'s Go !',
                    ['path'] = 'file://item-file-work-start',
                    ['options'] = {},
                },
                {
                    ['name'] = 'Work !',
                    ['path'] = 'file://item-file-work-item-1',
                    ['options'] = {},
                },
                {
                    ['name'] = 'Take a break !',
                    ['path'] = 'file://item-file-work-end',
                    ['options'] = {},
                },
                {
                    ['name'] = 'Let\'s Go !',
                    ['path'] = 'file://item-file-work-start',
                    ['options'] = {},
                },
                {
                    ['name'] = 'Work !',
                    ['path'] = 'file://item-file-work-item-2',
                    ['options'] = {},
                },
                {
                    ['name'] = 'Take a break !',
                    ['path'] = 'file://item-file-work-end',
                    ['options'] = {},
                },
                {
                    ['name'] = 'Finish !',
                    ['path'] = 'file://item-file-work-after-all',
                    ['options'] = {},
                },
            },
            playlistItems
        )
    end

    os.exit(lu.LuaUnit.run())
end