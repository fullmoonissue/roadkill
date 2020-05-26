local context = require('src/context')
local playlist = require('src/playlist')
local uiWip = require('src/ui/wip')
local vlcWraps = require('src/vlc/wraps')

-- Form elements
local   inputFileName,
        listConfigurations
-- Methods
local   getFileNameValue,
        loadConfiguration,
        saveFileName
-- Own saved configurations
local savedConfigurations = {}

--
-- Methods
--

getFileNameValue = function()
    return inputFileName:get_text()
end

loadConfiguration = function()
    local uiFormFileName = require('src/ui/form/1-FileName')
    if uiFormFileName.getConfigurations() ~= nil then
        local savedConfiguration = require(
            'saves/' .. string.sub(uiFormFileName.getConfigurationValue(), 0, -5)
        )
        if context.isValid(savedConfiguration) then
            local playlistItems = {}
            playlist.compile(savedConfiguration, playlistItems)
            -- Give the playlist to VLC
            vlcWraps.launch(playlistItems)
        end
    end
end

saveFileName = function()
    uiWip.wipFileName = getFileNameValue()

    require('src/ui/roadkill').windowFormConfiguration()
end

--
-- Exports
--

return {
    appendCreateForm = function(row)
        local window = require('src/ui/roadkill').getWindow()
        window:add_label('Name of the new configuration :', 1, row)
        inputFileName = window:add_text_input('', 2, row)
        window:add_button('Create configuration', saveFileName, 3, row)
    end,

    appendLoadForm = function(row)
        local window = require('src/ui/roadkill').getWindow()
        if 0 == #savedConfigurations then
            window:add_label('No configuration to load...', 1, row)
        else
            window:add_label('Configuration to load :', 1, row)
            listConfigurations = window:add_dropdown(2, row)
            for index, savedConfiguration in ipairs(savedConfigurations) do
                listConfigurations:add_value(savedConfiguration, index)
            end
            window:add_button('Go !', loadConfiguration, 3, row)
        end
    end,

    getFileNameValue = getFileNameValue,

    getConfigurations = function()
        return listConfigurations
    end,

    getConfigurationValue = function()
        return savedConfigurations[listConfigurations:get_value()]
    end,

    fillSavedConfigurations = function()
        for _, savedConfiguration in ipairs(vlcWraps.readdir(context.pwd .. '/' .. context.savesFolder)) do
            if savedConfiguration ~= '.' and savedConfiguration ~= '..' and savedConfiguration ~= '.gitkeep' then
                table.insert(savedConfigurations, savedConfiguration)
            end
        end
    end
}