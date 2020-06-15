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
dropdownCompositions, -- form list about the compositions
i18n,
inputFileName, -- form input text about the file name
labelFeedbackCreate

-- Methods
local
deleteComposition, -- delete an existing composition
displayForm, -- add the form about compositions
en,
fr,
getCompositionValue, -- retrieve the value of the selected composition
getFileNameValue, -- retrieve the value of the file name
launchComposition, -- launch an existing composition
saveFileName, -- save the file name
updateComposition -- update an existing composition

-- --- --- --
--  Code   --
-- --- --- --

deleteComposition = function()
    utils.deleteFile(string.format('%s/%s/%s.lua', context.getPwd(), context.savesFolder, getCompositionValue()))
    require('src/ui/window').formFileName()
end

displayForm = function()
    context.wips.composition = {}
    i18n = i18nModule.getTranslations()
    local window = require('src/ui/window').get()
    local row = 1
    local colspan = 1
    window:add_label(string.format('<b>%s</b>', i18n.formDashboard.label.language), 1, row)
    local col = 1
    for locale, flag in pairs(i18nModule.locales) do
        col = col + 1
        window:add_button(flag, 'en' == locale and en or fr, col, row)
    end
    row = row + 1
    if 0 < #context.getSavedCompositions() then
        window:add_label(string.format('<br /><b>%s</b>', i18n.formDashboard.label.existingCompositions), 1, row, 4)
        row = row + 1
        dropdownCompositions = window:add_dropdown(1, row)
        for index, savedComposition in ipairs(context.getSavedCompositions()) do
            dropdownCompositions:add_value(savedComposition, index)
        end
        window:add_button(i18n.formDashboard.button.launch, launchComposition, 2, row)
        window:add_button(i18n.formDashboard.button.update, updateComposition, 3, row)
        window:add_button(i18n.formDashboard.button.delete, deleteComposition, 4, row)

        row = row + 1
        colspan = 3
    end

    window:add_label(string.format('<br /><b>%s</b>', i18n.formDashboard.label.newComposition), 1, row, 1 + colspan)
    row = row + 1
    inputFileName = window:add_text_input('', 1, row)
    window:add_button(i18n.formDashboard.button.create, saveFileName, 2, row)
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

getCompositionValue = function()
    return context.getSavedCompositions()[dropdownCompositions:get_value()]
end

getFileNameValue = function()
    return inputFileName:get_text()
end

launchComposition = function()
    local savedComposition = require(string.format('%s/%s', context.savesFolder, getCompositionValue()))
    if context.isValid(savedComposition) then
        local playlistItems = {}
        playlist.compile(savedComposition, playlistItems)
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
                i18n.formDashboard.error.nameRequired
            )
        )
    else
        local isCompositionAlreadyExisting = false
        local folderPath = string.format('%s/%s', context.getPwd(), context.savesFolder)
        for _, savedComposition in ipairs(_vlc_.readdir(folderPath)) do
            if savedComposition == string.format('%s.lua', fileNameValue) then
                isCompositionAlreadyExisting = true
            end
        end
        if isCompositionAlreadyExisting then
            labelFeedbackCreate:set_text(
                string.format(
                    '<span style="color:red;">%s</span>',
                    i18n.formDashboard.error.alreadyExists
                )
            )
        else
            context.wips.composition = {}
            context.wips.fileName = fileNameValue

            require('src/ui/window').formComposition()
        end
    end
end

updateComposition = function()
    context.wips.fileName = getCompositionValue()
    context.wips.composition = require(string.format('%s/%s', context.savesFolder, context.wips.fileName))

    require('src/ui/window').formComposition()
end

-- --- --- --
-- Exports --
-- --- --- --

return {
    displayForm = displayForm,
}