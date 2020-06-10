-- --- --- --
-- Require --
-- --- --- --

local context = require('src/context')
local i18nModule = require('src/ui/i18n')

-- --- --- --
-- Header  --
-- --- --- --

-- Fields
local
i18n,
inputDuration, -- form input text about the time of end of the file
inputPath, -- form input text about the absolute path of the file
inputStart, -- form input text about the time of start of the file
labelFeedbackLocation

-- Methods
local
add,
displayForm, -- add the form about the creation of the file item
getDurationValue, -- retrieve the value of the duration
getPathValue, -- retrieve the value of the path
getStartValue, -- retrieve the value of the time of start
isFormValid,
update

-- --- --- --
--  Code   --
-- --- --- --

add = function()
    if isFormValid() then
        require('src/ui/form/items').addItem()
    end
end

isFormValid = function()
    i18n = i18nModule.getTranslations()
    if getPathValue() == '' then
        labelFeedbackLocation:set_text(
            string.format(
                '<span style="color:red;">%s</span>',
                i18n.file.form.error.pathRequired
            )
        )

        return false
    end

    return true
end

displayForm = function()
    i18n = i18nModule.getTranslations()
    local windowModule = require('src/ui/window')
    local window = windowModule.get()

    window:add_label(i18n.file.form.label.path, 1, 1)
    inputPath = window:add_text_input(context.wips.formFile['path'], 2, 1)
    labelFeedbackLocation = window:add_label('', 3, 1)

    window:add_label(i18n.file.form.label.duration, 1, 2)
    inputDuration = window:add_text_input(context.wips.formFile['duration'], 2, 2)

    window:add_label(i18n.file.form.label.start, 1, 3)
    inputStart = window:add_text_input(context.wips.formFile['start'], 2, 3)

    window:add_button(i18n.file.form.button.goBack, windowModule.formConfiguration, 1, 4)
    window:add_button(
        context.wips.formFile['path'] == '' and i18n.file.form.button.add or i18n.file.form.button.update,
        context.wips.formFile['path'] == '' and add or update,
        3,
        4
    )
end

getDurationValue = function()
    return tonumber(inputDuration:get_text())
end

getPathValue = function()
    return inputPath:get_text()
end

getStartValue = function()
    return tonumber(inputStart:get_text())
end

update = function()
    if isFormValid() then
        require('src/ui/form/items').updateItem()
    end
end

-- --- --- --
-- Exports --
-- --- --- --

return {
    displayForm = displayForm,
    getDurationValue = getDurationValue,
    getPathValue = getPathValue,
    getStartValue = getStartValue,
}