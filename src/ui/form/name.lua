-- --- --- --
-- Require --
-- --- --- --

local _vlc_ = require('src/vlc')
local context = require('src/context')
local playlist = require('src/playlist')
local utils = require('src/utils')

-- --- --- --
-- Header  --
-- --- --- --

-- Fields
local
inputFileName, -- form input text about the file name
labelFeedbackCreate,
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
    utils.deleteFile(context.getPwd() .. '/' .. context.savesFolder .. '/' .. getConfigurationValue() .. '.lua')
    require('src/ui/window').formFileName()
end

displayForm = function()
    local window = require('src/ui/window').get()
    local row = 1
    local colspan = 1
    if 0 < #context.getSavedConfigurations() then
        window:add_label('<b>Existing configurations</b>', 1, row, 4)
        row = row + 1
        listConfigurations = window:add_dropdown(1, row)
        for index, savedConfiguration in ipairs(context.getSavedConfigurations()) do
            listConfigurations:add_value(savedConfiguration, index)
        end
        window:add_button('Launch', launchConfiguration, 2, row)
        window:add_button('Update', updateConfiguration, 3, row)
        window:add_button('Delete', deleteConfiguration, 4, row)

        row = row + 1
        colspan = 3
    end

    window:add_label('<b>New configuration</b>', 1, row, 1 + colspan)
    row = row + 1
    inputFileName = window:add_text_input('Placeholder', 1, row)
    window:add_button('Create', saveFileName, 2, row)
    labelFeedbackCreate = window:add_label('', 3, row, colspan > 1 and 2 or 1)
end

getConfigurationValue = function()
    return context.getSavedConfigurations()[listConfigurations:get_value()]
end

getFileNameValue = function()
    return inputFileName:get_text()
end

launchConfiguration = function()
    local savedConfiguration = require(context.savesFolder .. '/' .. getConfigurationValue())
    if context.isValid(savedConfiguration) then
        local playlistItems = {}
        playlist.compile(savedConfiguration, playlistItems)
        -- Give the playlist to VLC
        _vlc_.launch(playlistItems)
    end
end

saveFileName = function()
    local fileNameValue = getFileNameValue()
    if fileNameValue == '' then
        labelFeedbackCreate:set_text('<span style="color:red;">Name required</span>')
    else
        context.wips.configuration = {}
        context.wips.fileName = fileNameValue

        require('src/ui/window').formConfiguration()
    end
end

updateConfiguration = function()
    context.wips.configuration = require(
        context.savesFolder .. '/' .. getConfigurationValue()
    )
    context.wips.fileName = getConfigurationValue()

    require('src/ui/window').formConfiguration()
end

-- --- --- --
-- Exports --
-- --- --- --

return {
    displayForm = displayForm,
}