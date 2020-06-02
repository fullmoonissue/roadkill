-- --- --- --
-- Header  --
-- --- --- --

-- Fields
local inputPath -- form input text about the url


-- Methods
local
displayForm, -- add the form about the creation of the url item
getPathValue -- retrieve the value of the path

-- --- --- --
--  Code   --
-- --- --- --

displayForm = function()
    local window = require('src/ui/roadkill').getWindow()
    window:add_label('Url ?', 1, 1)
    inputPath = window:add_text_input('', 2, 1)
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