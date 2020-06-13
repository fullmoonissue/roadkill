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
checkboxRandom, -- form checkbox about the randomization or not of the selected files into the folder
i18n,
inputStopAt, -- form input text about the time of end of the selected files into the folder
inputLoop, -- form input text about the number of repetitions for each selected files into the folder
inputNbElements, -- form input text about the number of files to select into the folder
inputPath, -- form input text about the path of the folder
inputStartAt, -- form input text about the time of start of the selected files into the folder
labelFeedbackLocation

-- Methods
local
add,
displayForm, -- add the form about the creation of the folder item
getStopAtValue, -- retrieve the value of the stopAt
getLoopValue, -- retrieve the value of the number of repetitions
getNbElementsValue, -- retrieve the value of number of files to select
getPathValue, -- retrieve the value of the path
getRandomValue, -- retrieve the value of the randomization
getStartAtValue, -- retrieve the value of the time of start
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
                i18n.folder.form.error.pathRequired
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

    window:add_label(i18n.folder.form.label.path, 1, 1)
    inputPath = window:add_text_input(context.wips.formFolder['path'], 2, 1)
    labelFeedbackLocation = window:add_label('', 3, 1)

    window:add_label(i18n.folder.form.label.random, 1, 2)
    checkboxRandom = window:add_check_box(
        i18n.folder.form.checkbox.yes,
        true == context.wips.formFolder['random'],
        2,
        2
    )

    window:add_label(i18n.folder.form.label.loop, 1, 3)
    inputLoop = window:add_text_input(context.wips.formFolder['loop'], 2, 3)

    window:add_label(i18n.folder.form.label.nbElements, 1, 4)
    inputNbElements = window:add_text_input(context.wips.formFolder['nbElements'], 2, 4)

    window:add_label(i18n.folder.form.label.startAt, 1, 5)
    inputStartAt = window:add_text_input(context.wips.formFolder['startAt'], 2, 5)

    window:add_label(i18n.folder.form.label.stopAt, 1, 6)
    inputStopAt = window:add_text_input(context.wips.formFolder['stopAt'], 2, 6)

    window:add_button(i18n.folder.form.button.goBack, windowModule.formComposition, 1, 7)
    window:add_button(
        context.wips.formFolder['path'] == '' and i18n.folder.form.button.add or i18n.folder.form.button.update,
        context.wips.formFolder['path'] == '' and add or update,
        3,
        7
    )
end

getStopAtValue = function()
    return tonumber(inputStopAt:get_text())
end

getLoopValue = function()
    return tonumber(inputLoop:get_text())
end

getNbElementsValue = function()
    return tonumber(inputNbElements:get_text())
end

getPathValue = function()
    return inputPath:get_text()
end

getRandomValue = function()
    return checkboxRandom:get_checked()
end

getStartAtValue = function()
    return tonumber(inputStartAt:get_text())
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
    getStopAtValue = getStopAtValue,
    getLoopValue = getLoopValue,
    getNbElementsValue = getNbElementsValue,
    getPathValue = getPathValue,
    getRandomValue = getRandomValue,
    getStartAtValue = getStartAtValue,
}