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
inputPath, -- form input text about the url
labelFeedbackLocation

-- Methods
local
add,
displayForm, -- add the form about the creation of the url item
getPathValue, -- retrieve the value of the path
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
                i18n.url.form.error.pathRequired
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

    window:add_label(i18n.url.form.label.path, 1, 1)
    inputPath = window:add_text_input(context.wips.formUrl['path'], 2, 1)
    labelFeedbackLocation = window:add_label('', 3, 1)

    window:add_button(i18n.url.form.button.goBack, windowModule.formComposition, 1, 2)
    window:add_button(
        context.wips.formUrl['path'] == '' and i18n.url.form.button.add or i18n.url.form.button.update,
        context.wips.formUrl['path'] == '' and add or update,
        3,
        2
    )
end

getPathValue = function()
    return inputPath:get_text()
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
    getPathValue = getPathValue
}