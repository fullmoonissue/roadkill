-- Form element
local inputPath

--
-- Exports
--

return {
    appendNewForm = function()
        local window = require('src/ui/roadkill').getWindow()
        window:add_label('Url ?', 1, 1)
        inputPath = window:add_text_input('', 2, 1)
    end,

    getPathValue = function()
        return inputPath:get_text()
    end,
}