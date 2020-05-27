-- "Real" VLC calls wrapped into functions (could be mocked in tests)
local readdir = function(path)
    return vlc.io.readdir(path)
end

local launch = function(playlistItems)
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

return {
    readdir = readdir,
    launch = launch,
}