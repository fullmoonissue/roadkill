-- [[ Configuration ]]

local configuration = {}

-- [[ Roadkill VLC Extension ]]
-- @see "How to create a VLC Extension" in the README.md to understand what is the purpose of each functions

function descriptor()
    return {
        title = 'Roadkill',
        version = '2.3.0',
        author = 'fullmoonissue',
        url = 'http://www.fullmoonissue.net/',
        shortdesc = 'Roadkill, VLC Extension';
        description = 'Roadkill is a VLC Extension to setup work / break sequences.'
    }
end

function activate()
    -- Clear the playlist
    vlc.playlist.stop()
    vlc.playlist.clear()

    -- Shuffle a table
    -- @see https://gist.github.com/Uradamus/10323382
    local function shuffle(tbl)
        math.randomseed(os.time())
        for index = #tbl, 2, -1 do
            local random = math.random(index)
            tbl[index], tbl[random] = tbl[random], tbl[index]
        end

        return tbl
    end

    -- Add item into the playlist if the item is properly setup
    local function handleItemPlaylist(name, properties, playlistItems)
        local path
        if properties['url'] ~= nil then
            path = properties['url']
        elseif properties['file'] ~= nil then
            path = 'file://' .. properties['file']
        end

        if path ~= nil then
            local item = {
                ['path'] = path,
                ['name'] = name,
                ['options'] = {},
            }
            local start = 0
            if properties['start'] ~= nil then
                start = properties['start']
                table.insert(
                    item['options'],
                    string.format('start-time=%d', properties['start'])
                )
            end
            if properties['duration'] ~= nil then
                table.insert(
                    item['options'],
                    string.format('stop-time=%d', start + properties['duration'])
                )
            end

            table.insert(playlistItems, item)
        end
    end

    -- Iterate overs items to add them into the playlist
    local function handleItemsPlaylist(name, items, playlistItems)
        for index, item in ipairs(items) do
            handleItemPlaylist(
                string.format(name, index),
                item,
                playlistItems
            )
        end
    end

    local playlistItems = {}
    if configuration['work-before-all'] ~= nil then
        if configuration['work-before-all'][1] ~= nil then
            handleItemsPlaylist('[%d] Before Starting !', configuration['work-before-all'], playlistItems)
        else
            handleItemPlaylist('Before Starting !', configuration['work-before-all'], playlistItems)
        end
    end
    if configuration['work-items'] ~= nil then
        if configuration['work-items'][1] == nil then
            configuration['work-items'] = {configuration['work-items']}
        end
        for _, workItem in ipairs(configuration['work-items']) do
            if workItem['folder'] ~= nil then
                local nbElements
                if workItem['nbElements'] ~= nil then
                    nbElements = workItem['nbElements']
                end

                local workFiles = {}
                for _, workFile in ipairs(vlc.io.readdir(workItem['folder'])) do
                    if workFile ~= '.' and workFile ~= '..' then
                        if nbElements == nil or nbElements > #workFiles then
                            table.insert(workFiles, workItem['folder'] .. '/' .. workFile)
                        end
                    end
                end

                if workItem['random'] ~= nil and workItem['random'] then
                    workFiles = shuffle(workFiles)
                end

                for _, workFile in ipairs(workFiles) do
                    local fpWorkItem = { ['file'] = workFile }
                    if workItem['duration'] ~= nil then
                        fpWorkItem['duration'] = workItem['duration']
                    end
                    if workItem['start'] ~= nil then
                        fpWorkItem['start'] = workItem['start']
                    end

                    if configuration['work-start'] ~= nil then
                        if configuration['work-start'][1] ~= nil then
                            handleItemsPlaylist('[%d] Let\'s Go !', configuration['work-start'], playlistItems)
                        else
                            handleItemPlaylist('Let\'s Go !', configuration['work-start'], playlistItems)
                        end
                    end
                    handleItemPlaylist('Work !', fpWorkItem, playlistItems)
                    if configuration['work-end'] ~= nil then
                        if configuration['work-end'][1] ~= nil then
                            handleItemsPlaylist('[%d] Take a break !', configuration['work-end'], playlistItems)
                        else
                            handleItemPlaylist('Take a break !', configuration['work-end'], playlistItems)
                        end
                    end
                end
            else
                if configuration['work-start'] ~= nil then
                    if configuration['work-start'][1] ~= nil then
                        handleItemsPlaylist('[%d] Let\'s Go !', configuration['work-start'], playlistItems)
                    else
                        handleItemPlaylist('Let\'s Go !', configuration['work-start'], playlistItems)
                    end
                end
                handleItemPlaylist('Work !', workItem, playlistItems)
                if configuration['work-end'] ~= nil then
                    if configuration['work-end'][1] ~= nil then
                        handleItemsPlaylist('[%d] Take a break !', configuration['work-end'], playlistItems)
                    else
                        handleItemPlaylist('Take a break !', configuration['work-end'], playlistItems)
                    end
                end
            end
        end
    end
    if configuration['work-after-all'] ~= nil then
        if configuration['work-after-all'][1] ~= nil then
            handleItemsPlaylist('[%d] Finish !', configuration['work-after-all'], playlistItems)
        else
            handleItemPlaylist('Finish !', configuration['work-after-all'], playlistItems)
        end
    end

    -- /!\ Important note : the method "vlc.playlist.add" have to be called only once
    -- Multiple call will generate the error "Playlist should be a table"
    vlc.playlist.add(playlistItems)
    -- Do not autoplay the playlist yet (we are at the end of the playlist at this moment)
    vlc.playlist.stop()
    -- Go to first item of the playlist (next at the end of the playlist brings to the beginning)
    vlc.playlist.next()
    -- Now play it
    vlc.playlist.play()
end

function deactivate()
    vlc.msg.dbg('Thanks for using the Roadkill Extension !')
end