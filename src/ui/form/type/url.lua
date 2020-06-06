-- --- --- --
-- Header  --
-- --- --- --

-- Fields
local
inputPath, -- form input text about the url
labelFeedbackLocation

-- Methods
local
add,
displayForm, -- add the form about the creation of the url item
getPathValue -- retrieve the value of the path

-- --- --- --
--  Code   --
-- --- --- --

add = function()
    if getPathValue() == '' then
        labelFeedbackLocation:set_text('<span style="color:red;">Required</span>')
    else
        require('src/ui/form/items').addItem()
    end
end

displayForm = function()
    local windowModule = require('src/ui/window')
    local window = windowModule.get()

    window:add_label('Url ?', 1, 1)
    inputPath = window:add_text_input('', 2, 1)
    labelFeedbackLocation = window:add_label('', 3, 1)

    window:add_button('Go back', windowModule.formConfiguration, 1, 2)
    window:add_button('Add', add, 3, 2)
end

getPathValue = function()
    return inputPath:get_text()
end

-- --- --- --
-- Exports --
-- --- --- --

return {
    displayForm = displayForm,
    getPathValue = getPathValue
}