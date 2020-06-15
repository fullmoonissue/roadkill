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
inputStopAt, -- form input text about the time of end of the file
inputPath, -- form input text about the absolute path of the file
inputStartAt, -- form input text about the time of start of the file
labelFeedbackLocation

-- Methods
local
add,
displayForm, -- add the form about the creation of the file item
getStopAtValue, -- retrieve the value of the stopAt
getPathValue, -- retrieve the value of the path
getStartAtValue, -- retrieve the value of the time of start
isFormValid,
update

-- --- --- --
--  Code   --
-- --- --- --

add = function()
    if isFormValid() then
        require('src/ui/form/composition').addItem()
    end
end

isFormValid = function()
    i18n = i18nModule.getTranslations()
    if getPathValue() == '' then
        labelFeedbackLocation:set_text(
            string.format(
                '<span style="color:red;">%s</span>',
                i18n.formItemTypeFile.error.pathRequired
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

    window:add_label(i18n.formItemTypeFile.label.path, 1, 1)
    inputPath = window:add_text_input(context.wips.formFile['path'], 2, 1)
    labelFeedbackLocation = window:add_label('', 3, 1)

    window:add_label(i18n.formItemTypeFile.label.startAt, 1, 2)
    inputStartAt = window:add_text_input(context.wips.formFile['startAt'], 2, 2)

    window:add_label(i18n.formItemTypeFile.label.stopAt, 1, 3)
    inputStopAt = window:add_text_input(context.wips.formFile['stopAt'], 2, 3)

    window:add_button(i18n.formItemTypeFile.button.goBack, windowModule.formComposition, 1, 4)
    window:add_button(
        context.wips.formFile['path'] == '' and i18n.formItemTypeFile.button.add or i18n.formItemTypeFile.button.update,
        context.wips.formFile['path'] == '' and add or update,
        3,
        4
    )
end

getStopAtValue = function()
    return tonumber(inputStopAt:get_text())
end

getPathValue = function()
    return inputPath:get_text()
end

getStartAtValue = function()
    return tonumber(inputStartAt:get_text())
end

update = function()
    if isFormValid() then
        require('src/ui/form/composition').updateItem()
    end
end

-- --- --- --
-- Exports --
-- --- --- --

return {
    displayForm = displayForm,
    getStopAtValue = getStopAtValue,
    getPathValue = getPathValue,
    getStartAtValue = getStartAtValue,
}