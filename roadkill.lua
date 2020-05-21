-- [[ Configuration ]]

local configuration = {}

-- [[ Roadkill VLC Extension ]]
-- @see "How to create a VLC Extension" in the README.md to understand what is the purpose of each functions

function descriptor()
    return {
        title = 'Roadkill',
        version = '2.4.0',
        author = 'fullmoonissue',
        url = 'http://www.fullmoonissue.net/',
        shortdesc = 'Roadkill, VLC Extension';
        description = 'Roadkill is a VLC Extension to setup work / break sequences.'
    }
end

function activate()
    -- Little function to change a table{['...'] = ...} into table{table{['...'] = ...}} (if not already)
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

    --    ____  ____  ______________  _   _______
    --   / __ \/ __ \/_  __/  _/ __ \/ | / / ___/
    --  / / / / /_/ / / /  / // / / /  |/ /\__ \
    -- / /_/ / ____/ / / _/ // /_/ / /|  /___/ /
    -- \____/_/     /_/ /___/\____/_/ |_//____/

    -- VLC option to stop the stream at a certain number of seconds
    local vlcOptionDuration = function(duration)
        return string.format('stop-time=%d', duration)
    end

    -- VLC option to start the stream at a certain number of seconds
    local vlcOptionStart = function(startAt)
        return string.format('start-time=%d', startAt)
    end

    -- VLC options handled
    local vlcMethodByOptions = {
        {
            option = 'duration',
            method = vlcOptionDuration
        },
        {
            option = 'start',
            method = vlcOptionStart
        }
    }

    local vlcGetMethodOption = function(option)
        for _, properties in ipairs(vlcMethodByOptions) do
            if properties['option'] == option then
                return properties['method']
            end
        end
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
            for _, workFile in ipairs(vlc.io.readdir(workItem['folder'])) do
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

    -- Transform work-items folder into work-items files
    local workItems = {}
    if configuration['work-items'] ~= nil then
        for _, workItem in ipairs(toList(configuration['work-items'])) do
            flattenFolderItem(workItem, workItems)
        end
    end
    configuration['work-items'] = workItems

    -- Prepare all the items to be added to the playlist ...
    local playlistItems = {}
    -- ... 1. items into the "work-before-all" root key ...
    addItemsToPlaylist('Before Starting !', configuration['work-before-all'], playlistItems)
    -- ... Then for each "work-items" item ...
    for _, workItem in ipairs(configuration['work-items']) do
        -- ... 2. items into the "work-start" root key
        addItemsToPlaylist('Let\'s Go !', configuration['work-start'], playlistItems)
        -- ... 3. the current item
        addItemToPlaylist('Work !', workItem, playlistItems)
        -- ... 4. items into the "work-end" root key
        addItemsToPlaylist('Take a break !', configuration['work-end'], playlistItems)
    end
    -- ... 5. items into the "work-after-all" root key ...
    addItemsToPlaylist('Finish !', configuration['work-after-all'], playlistItems)

    --  _    ____    ______
    -- | |  / / /   / ____/
    -- | | / / /   / /
    -- | |/ / /___/ /___
    -- |___/_____/\____/

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

function deactivate()
    vlc.msg.dbg('Thanks for using the Roadkill Extension !')
end