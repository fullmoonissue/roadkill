-- --- --- --
-- Header  --
-- --- --- --

-- Fields
local
checkboxRandom, -- form checkbox about the randomization or not of the selected files into the folder
inputDuration, -- form input text about the time of end of the selected files into the folder
inputLoop, -- form input text about the number of repetitions for each selected files into the folder
inputNbElements, -- form input text about the number of files to select into the folder
inputPath, -- form input text about the path of the folder
inputStart, -- form input text about the time of start of the selected files into the folder
labelFeedbackLocation

-- Methods
local
add,
displayForm, -- add the form about the creation of the folder item
getDurationValue, -- retrieve the value of the duration
getLoopValue, -- retrieve the value of the number of repetitions
getNbElementsValue, -- retrieve the value of number of files to select
getPathValue, -- retrieve the value of the path
getRandomValue, -- retrieve the value of the randomization
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

    window:add_label('Location of the folder ?', 1, 1)
    inputPath = window:add_text_input('', 2, 1)
    labelFeedbackLocation = window:add_label('', 3, 1)

    window:add_label('Randomize file selection ?', 1, 2)
    checkboxRandom = window:add_check_box('Yes', false, 2, 2)

    window:add_label('Number of loop by element ?', 1, 3)
    inputLoop = window:add_text_input('', 2, 3)

    window:add_label('Number of elements ?', 1, 4)
    inputNbElements = window:add_text_input('', 2, 4)

    window:add_label('Duration ?', 1, 5)
    inputDuration = window:add_text_input('', 2, 5)

    window:add_label('Start ?', 1, 6)
    inputStart = window:add_text_input('', 2, 6)

    window:add_button('Go back', windowModule.formConfiguration, 1, 7)
    window:add_button('Add', add, 3, 7)
end

getDurationValue = function()
    return tonumber(inputDuration:get_text())
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

getStartValue = function()
    return tonumber(inputStart:get_text())
end

-- --- --- --
-- Exports --
-- --- --- --

return {
    displayForm = displayForm,
    getDurationValue = getDurationValue,
    getLoopValue = getLoopValue,
    getNbElementsValue = getNbElementsValue,
    getPathValue = getPathValue,
    getRandomValue = getRandomValue,
    getStartValue = getStartValue,
}