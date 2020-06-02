-- --- --- --
-- Header  --
-- --- --- --

-- Fields
local options = { -- VLC commands' options handled
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

-- Methods
local
launch, -- call vlc with the configured playlist
optionMethod, -- get the method associated to an option
readdir -- "Real" VLC calls wrapped into functions (will be mocked in tests)

-- --- --- --
--  Code   --
-- --- --- --

launch = function(playlistItems)
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

optionMethod = function(option)
    for _, properties in ipairs(options) do
        if properties['option'] == option then
            return properties['method']
        end
    end
end

readdir = function(path)
    return vlc.io.readdir(path)
end

-- --- --- --
-- Exports --
-- --- --- --

return {
    launch = launch,
    optionMethod = optionMethod,
    options = options,
    readdir = readdir,
}