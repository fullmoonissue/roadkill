function descriptor()
    return {
        title = 'Roadkill',
        version = '1.0.0',
        author = 'fullmoonissue',
        url = 'http://www.fullmoonissue.net/',
        shortdesc = 'Roadkill, VLC Extension';
        description = 'Roadkill is a VLC Extension to setup work / break sequences.'
    }
end

-- Dialog box (have to be declared outside to be known by multiple vlc's awaited functions)
local dialog

function activate()
    -- Configuration
    local MAX_NB_ELEMENTS = 25
    local DEFAULT_VALUE_FOLDER = ''
    local DEFAULT_VALUE_NB_ELEMENTS = ''

    -- Text inputs and associated label (if error)
    local inputFolder, inputNbElements, labelError

    -- Function called when the "Clear !" button is clicked
    local callbackClear = function()
        vlc.playlist.stop()
        vlc.playlist.clear()
    end

    -- Function called when the "Go !" button is clicked
    local callbackGo = function()
        -- Retrieve the destination folder and the number of working elements
        local folder = inputFolder:get_text()
        local textNbElements = inputNbElements:get_text()
        if folder == '' or textNbElements == '' then
            labelError:set_text('The inputs can\'t be empty')
        else
            labelError:set_text('')
            callbackClear()

            -- Destination is now in the assets folder
            folder = folder .. '/assets'

            -- Fix the number of working elements
            local nbElements = tonumber(textNbElements)
            if nil == nbElements or 0 >= nbElements then
                nbElements = 1
            end
            if MAX_NB_ELEMENTS < nbElements then
                nbElements = MAX_NB_ELEMENTS
            end

            -- Assign the work / break files / folders
            local breakMusic, breakFolder, breakElements, workMusic, workFolder, workElements
            for _, fileOrFolder in pairs(vlc.io.readdir(folder)) do
                -- Break folder
                if fileOrFolder == 'break' then
                    breakElements = vlc.io.readdir(folder .. '/' .. fileOrFolder)
                    if 1 <= #breakElements then
                        breakFolder = folder .. '/' .. fileOrFolder
                    end
                end
                -- Work folder
                if fileOrFolder == 'work' then
                    workElements = vlc.io.readdir(folder .. '/' .. fileOrFolder)
                    if 1 <= #workElements then
                        workFolder = folder .. '/' .. fileOrFolder
                    end
                end
                -- Break file
                if string.match( fileOrFolder, '^break\.' ) then
                    breakMusic = folder .. '/' .. fileOrFolder
                end
                -- Work file
                if string.match( fileOrFolder, '^work\.' ) then
                    workMusic = folder .. '/' .. fileOrFolder
                end
            end

            -- @see https://gist.github.com/Uradamus/10323382
            local function shuffle(tbl)
                math.randomseed(os.time())
                for index = #tbl, 2, -1 do
                    local random = math.random(index)
                    tbl[index], tbl[random] = tbl[random], tbl[index]
                end

                return tbl
            end

            -- If at least one element is in work and break folders, then the playlist can be created
            if breakFolder and workFolder then
                -- Keep only the wanted number of work / break files
                local workFiles = {}
                for _, workFile in pairs(shuffle(workElements)) do
                    if workFile ~= '.' and workFile ~= '..' and workFile ~= '.gitkeep' and nbElements > #workFiles then
                        table.insert(workFiles, workFolder .. '/' .. workFile)
                    end
                end

                local breakFiles = {}
                for _, breakFile in pairs(shuffle(vlc.io.readdir(breakFolder))) do
                    if breakFile ~= '.' and breakFile ~= '..' and breakFile ~= '.gitkeep' and nbElements > #breakFiles then
                        table.insert(breakFiles, breakFolder .. '/' .. breakFile)
                    end
                end

                -- Create the playlist
                local playlistItems = {}
                for index, workFile in ipairs(workFiles) do
                    if workMusic then
                        table.insert(
                            playlistItems,
                            {
                                ['path'] = 'file://' .. workMusic,
                                ['name'] = index .. ' - Let\'s Go !',
                            }
                        )
                    end

                    table.insert(
                        playlistItems,
                        {
                            ['path'] = 'file://' .. workFile,
                            ['name'] = index .. ' - Work !',
                        }
                    )

                    if breakMusic then
                        table.insert(
                            playlistItems,
                            {
                                ['path'] = 'file://' .. breakMusic,
                                ['name'] = index .. ' - Take a break !',
                            }
                        )
                    end

                    table.insert(
                        playlistItems,
                        {
                            ['path'] = 'file://' .. (breakFiles[index] or breakFiles[1]),
                            ['name'] = index .. ' - Break !',
                        }
                    )
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
        end
    end

    -- [[ Dialog box to ask needed pieces of information ]]
    dialog = vlc.dialog('Roadkill Dialog Box')
    dialog:set_title('Roadkill Configuration')
    -- [Input] Destination folder
    dialog:add_label('Folder', 1, 1)
    inputFolder = dialog:add_text_input(DEFAULT_VALUE_FOLDER, 2, 1)
    -- [Input] Nb elements
    dialog:add_label('Number of elements', 1, 2)
    inputNbElements = dialog:add_text_input(DEFAULT_VALUE_NB_ELEMENTS, 2, 2)
    labelError = dialog:add_label('', 2, 3)
    -- [Button] Go
    dialog:add_button('Go !', callbackGo, 1, 4)
    -- [Button] Clear
    dialog:add_button('Clear !', callbackClear, 2, 4)
    -- Display the dialog box
    dialog:show()
end

function close()
    dialog:delete()
    vlc.deactivate()
end

function deactivate()
    vlc.msg.dbg('Thanks for using the Roadkill Extension !')
end