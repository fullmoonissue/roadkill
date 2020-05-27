local uiFormFileName = require('src/ui/form/1-FileName')
local uiFormConfiguration = require('src/ui/form/2-Configuration')
local uiFormItemFile = require('src/ui/form/3-ItemFile')
local uiFormItemFolder = require('src/ui/form/3-ItemFolder')
local uiFormItemUrl = require('src/ui/form/3-ItemUrl')
local uiWip = require('src/ui/wip')

-- Window where forms will be shown
local window
-- Methods
local   deleteWindow,
        getWindow,
        prepareWindow,
        showWindow,
        windowFormConfiguration,
        windowFormFileName,
        windowFormItemType

--
-- Methods
--

deleteWindow = function()
    if window ~= nil then
        window:delete()
    end
end

getWindow = function()
    return window
end

prepareWindow = function(title)
    deleteWindow()
    window = vlc.dialog('Roadkill Window')
    window:set_title(string.format('[Roadkill] %s', title))
end

showWindow = function()
    window:show()
end

windowFormConfiguration = function()
    prepareWindow('Items configuration')

    uiFormConfiguration.appendNewForm()

    showWindow()
end

windowFormFileName = function()
    uiFormFileName.fillSavedConfigurations()
    prepareWindow('Load / Create configuration')

    local row = 1
    uiFormFileName.appendLoadForm(row)
    row = row + 1
    uiFormFileName.appendCreateForm(row)

    showWindow()
end

windowFormItemType = function()
    prepareWindow('Item configuration')

    local yButtonAdd
    if 1 == uiWip.wipType then
        uiFormItemFolder.appendNewForm()

        yButtonAdd = 7
    elseif 2 == uiWip.wipType then
        uiFormItemFile.appendNewForm()

        yButtonAdd = 4
    elseif 3 == uiWip.wipType then
        uiFormItemUrl.appendNewForm()

        yButtonAdd = 2
    end

    window:add_button('Go back', windowFormConfiguration, 1, yButtonAdd)
    window:add_button('Add', uiFormConfiguration.addMediumToConfiguration, 2, yButtonAdd)

    showWindow()
end

--
-- Exports
--

return {
    quit = function()
        deleteWindow()
        vlc.deactivate()
    end,

    getWindow = getWindow,
    prepareWindow = prepareWindow,
    showWindow = showWindow,
    deleteWindow = deleteWindow,

    windowFormConfiguration = windowFormConfiguration,
    windowFormFileName = windowFormFileName,
    windowFormItemType = windowFormItemType,
}