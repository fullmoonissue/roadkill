-- Form elements
local   checkboxRandom,
        inputDuration,
        inputLoop,
        inputNbElements,
        inputPath,
        inputStart

--
-- Exports
--

return {
    appendNewForm = function()
        local window = require('src/ui/roadkill').getWindow()

        window:add_label('Location of the folder ?', 1, 1)
        inputPath = window:add_text_input('', 2, 1)

        window:add_label('Randomize file selection ?', 1, 2)
        checkboxRandom = window:add_check_box('Yes', false, 2, 2)

        window:add_label('Number of loop by element ?', 1, 3)
        inputLoop = window:add_text_input('', 2, 3)

        window:add_label('Number of elements to select into the folder ?', 1, 4)
        inputNbElements = window:add_text_input('', 2, 4)

        window:add_label('Duration ?', 1, 5)
        inputDuration = window:add_text_input('', 2, 5)

        window:add_label('Start ?', 1, 6)
        inputStart = window:add_text_input('', 2, 6)
    end,

    getDurationValue = function()
        return tonumber(inputDuration:get_text())
    end,

    getLoopValue = function()
        return tonumber(inputLoop:get_text())
    end,

    getNbElementsValue = function()
        return tonumber(inputNbElements:get_text())
    end,

    getPathValue = function()
        return inputPath:get_text()
    end,

    getRandomValue = function()
        return checkboxRandom:get_checked()
    end,

    getStartValue = function()
        return tonumber(inputStart:get_text())
    end
}