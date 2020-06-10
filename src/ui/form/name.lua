-- --- --- --
-- Require --
-- --- --- --

local _vlc_ = require('src/vlc')
local context = require('src/context')
local i18nModule = require('src/ui/i18n')
local playlist = require('src/playlist')
local utils = require('src/utils')

-- --- --- --
-- Header  --
-- --- --- --

-- Fields
local
i18n,
inputFileName, -- form input text about the file name
labelFeedbackCreate,
listConfigurations -- form list about the configurations

-- Methods
local
deleteConfiguration, -- delete an existing configuration
displayForm, -- add the form about configurations
en,
fr,
getConfigurationValue, -- retrieve the value of the selected configuration
getFileNameValue, -- retrieve the value of the file name
launchConfiguration, -- launch an existing configuration
saveFileName, -- save the file name
updateConfiguration -- update an existing configuration

-- --- --- --
--  Code   --
-- --- --- --

deleteConfiguration = function()
    utils.deleteFile(string.format('%s/%s/%s.lua', context.getPwd(), context.savesFolder, getConfigurationValue()))
    require('src/ui/window').formFileName()
end

displayForm = function()
    i18n = i18nModule.getTranslations()
    local window = require('src/ui/window').get()
    local row = 1
    local colspan = 1
    window:add_label(string.format('<b>%s</b>', i18n.name.form.label.language), 1, row)
    local col = 1
    for locale, flag in pairs(i18nModule.locales) do
        col = col + 1
        window:add_button(flag, 'en' == locale and en or fr, col, row)
    end
    row = row + 1
    if 0 < #context.getSavedConfigurations() then
        window:add_label(string.format('<b>%s</b>', i18n.name.form.label.existingConfigurations), 1, row, 4)
        row = row + 1
        listConfigurations = window:add_dropdown(1, row)
        for index, savedConfiguration in ipairs(context.getSavedConfigurations()) do
            listConfigurations:add_value(savedConfiguration, index)
        end
        window:add_button(i18n.name.form.button.launch, launchConfiguration, 2, row)
        window:add_button(i18n.name.form.button.update, updateConfiguration, 3, row)
        window:add_button(i18n.name.form.button.delete, deleteConfiguration, 4, row)

        row = row + 1
        colspan = 3
    end

    window:add_label(string.format('<b>%s</b>', i18n.name.form.label.newConfiguration), 1, row, 1 + colspan)
    row = row + 1
    inputFileName = window:add_text_input('', 1, row)
    window:add_button(i18n.name.form.button.create, saveFileName, 2, row)
    labelFeedbackCreate = window:add_label('', 3, row, colspan > 1 and 2 or 1)
end

en = function()
    i18nModule.setLocale('en')
    i18n = i18nModule.getTranslations()
    require('src/ui/window').formFileName()
end

fr = function()
    i18nModule.setLocale('fr')
    i18n = i18nModule.getTranslations()
    require('src/ui/window').formFileName()
end

getConfigurationValue = function()
    return context.getSavedConfigurations()[listConfigurations:get_value()]
end

getFileNameValue = function()
    return inputFileName:get_text()
end

launchConfiguration = function()
    local savedConfiguration = require(string.format('%s/%s', context.savesFolder, getConfigurationValue()))
    if context.isValid(savedConfiguration) then
        local playlistItems = {}
        playlist.compile(savedConfiguration, playlistItems)
        _vlc_.launch(playlistItems)
    end
end

saveFileName = function()
    i18n = i18nModule.getTranslations()
    local fileNameValue = getFileNameValue()
    if fileNameValue == '' then
        labelFeedbackCreate:set_text(
            string.format(
                '<span style="color:red;">%s</span>',
                i18n.name.form.error.nameRequired
            )
        )
    else
        local isConfigurationAlreadyExisting = false
        local folderPath = string.format('%s/%s', context.getPwd(), context.savesFolder)
        for _, savedConfiguration in ipairs(_vlc_.readdir(folderPath)) do
            if savedConfiguration == string.format('%s.lua', fileNameValue) then
                isConfigurationAlreadyExisting = true
            end
        end
        if isConfigurationAlreadyExisting then
            labelFeedbackCreate:set_text(
                string.format(
                    '<span style="color:red;">%s</span>',
                    i18n.name.form.error.alreadyExists
                )
            )
        else
            context.wips.configuration = {}
            context.wips.fileName = fileNameValue

            require('src/ui/window').formConfiguration()
        end
    end
end

updateConfiguration = function()
    context.wips.configuration = require(string.format('%s/%s', context.savesFolder, getConfigurationValue()))
    context.wips.fileName = getConfigurationValue()

    require('src/ui/window').formConfiguration()
end

-- --- --- --
-- Exports --
-- --- --- --

return {
    displayForm = displayForm,
}