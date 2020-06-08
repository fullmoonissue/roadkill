-- --- --- --
-- Header  --
-- --- --- --

-- Fields
local
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
getStartValue -- retrieve the value of the time of start

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

    window:add_label('Location of the file ?', 1, 1)
    inputPath = window:add_text_input('', 2, 1)
    labelFeedbackLocation = window:add_label('', 3, 1)

    window:add_label('Duration ?', 1, 2)
    inputDuration = window:add_text_input('', 2, 2)

    window:add_label('Start ?', 1, 3)
    inputStart = window:add_text_input('', 2, 3)

    window:add_button('Go back', windowModule.formConfiguration, 1, 4)
    window:add_button('Add', add, 3, 4)
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

-- --- --- --
-- Exports --
-- --- --- --

return {
    displayForm = displayForm,
    getDurationValue = getDurationValue,
    getPathValue = getPathValue,
    getStartValue = getStartValue,
}