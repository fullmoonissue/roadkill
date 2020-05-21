-- [[ Configuration ]]

local configuration = {}

-- [[ Roadkill VLC Extension ]]
-- @see "How to create a VLC Extension" in the README.md to understand what is the purpose of each functions

function descriptor()
    return {
        title = 'Roadkill',
        version = '2.1.0',
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

    -- @see https://gist.github.com/Uradamus/10323382
    local function shuffle(tbl)
        math.randomseed(os.time())
        for index = #tbl, 2, -1 do
            local random = math.random(index)
            tbl[index], tbl[random] = tbl[random], tbl[index]
        end

        return tbl
    end

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
            }
            if properties['duration'] ~= nil then
                item['options'] = {
                    string.format('stop-time=%d', properties['duration']),
                }
            end
            if properties['start'] ~= nil then
                item['options'] = {
                    string.format('start-time=%d', properties['start']),
                }
            end

            table.insert(playlistItems, item)
        end
    end

    local playlistItems = {}
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
                    handleItemPlaylist('Let\'s Go !', configuration['work-start'], playlistItems)
                end
                handleItemPlaylist('Work !', fpWorkItem, playlistItems)
                if configuration['work-end'] ~= nil then
                    handleItemPlaylist('Take a break !', configuration['work-end'], playlistItems)
                end
            end
        else
            if configuration['work-start'] ~= nil then
                handleItemPlaylist('Let\'s Go !', configuration['work-start'], playlistItems)
            end
            handleItemPlaylist('Work !', workItem, playlistItems)
            if configuration['work-end'] ~= nil then
                handleItemPlaylist('Take a break !', configuration['work-end'], playlistItems)
            end
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