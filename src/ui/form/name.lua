-- --- --- --
-- Require --
-- --- --- --

local _vlc_ = require('src/vlc')
local context = require('src/context')
local playlist = require('src/playlist')
local uiWip = require('src/ui/wip')

-- --- --- --
-- Header  --
-- --- --- --

-- Fields
local
inputFileName, -- form input text about the file name
listConfigurations -- form list about the configurations

-- Methods
local
deleteConfiguration, -- delete an existing configuration
displayForm, -- add the form about configurations
getConfigurationValue, -- retrieve the value of the selected configuration
getFileNameValue, -- retrieve the value of the file name
launchConfiguration, -- launch an existing configuration
saveFileName, -- save the file name
updateConfiguration -- update an existing configuration

-- --- --- --
--  Code   --
-- --- --- --

deleteConfiguration = function()
    vlc.io.unlink(context.getPwd() .. '/' .. context.savesFolder .. '/' .. getConfigurationValue() .. '.lua')
    require('src/ui/roadkill').windowFormFileName()
end

displayForm = function()
    local window = require('src/ui/roadkill').getWindow()
    local row = 1
    local colspan = 1
    if 0 < #context.getSavedConfigurations() then

        window:add_label('Configurations :', 1, row)
        listConfigurations = window:add_dropdown(2, row)
        for index, savedConfiguration in ipairs(context.getSavedConfigurations()) do
            listConfigurations:add_value(savedConfiguration, index)
        end
        window:add_button('Launch', launchConfiguration, 3, row)
        window:add_button('Update', updateConfiguration, 4, row)
        window:add_button('Delete', deleteConfiguration, 5, row)

        row = row + 1
        colspan = 3
    end

    window:add_label('Name :', 1, row)
    inputFileName = window:add_text_input('', 2, row)
    window:add_button('Create configuration', saveFileName, 3, row, colspan)
end

getConfigurationValue = function()
    return context.getSavedConfigurations()[listConfigurations:get_value()]
end

getFileNameValue = function()
    return inputFileName:get_text()
end

launchConfiguration = function()
    local savedConfiguration = require(
        context.savesFolder .. '/' .. getConfigurationValue()
    )
    if context.isValid(savedConfiguration) then
        local playlistItems = {}
        playlist.compile(savedConfiguration, playlistItems)
        -- Give the playlist to VLC
        _vlc_.launch(playlistItems)
    end
end

saveFileName = function()
    uiWip.configuration = {}
    uiWip.fileName = getFileNameValue()

    require('src/ui/roadkill').windowFormConfiguration()
end

updateConfiguration = function()
    uiWip.configuration = require(
        context.savesFolder .. '/' .. getConfigurationValue()
    )
    uiWip.fileName = getConfigurationValue()

    require('src/ui/roadkill').windowFormConfiguration()
end

-- --- --- --
-- Exports --
-- --- --- --

return {
    displayForm = displayForm,
}