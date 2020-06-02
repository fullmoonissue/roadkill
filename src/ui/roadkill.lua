-- --- --- --
-- Require --
-- --- --- --

local context = require('src/context')
local uiFormFileName = require('src/ui/form/name')
local uiFormConfiguration = require('src/ui/form/configuration')
local uiFormItemFile = require('src/ui/form/type/file')
local uiFormItemFolder = require('src/ui/form/type/folder')
local uiFormItemUrl = require('src/ui/form/type/url')
local uiWip = require('src/ui/wip')

-- --- --- --
-- Header  --
-- --- --- --

-- Fields
local window -- Window where forms will be shown

-- Methods
local
deleteWindow, -- delete an existing window
getWindow, -- retrieve an existing window
prepareWindow, -- setup a new window
quit, -- Quit the extension
showWindow, -- show the window
windowFormConfiguration, -- prepare, add form ans show the window about configuration building
windowFormFileName, -- prepare, add form ans show the window about configurations
windowFormItemType -- prepare, add form ans show the window about a type of item

-- --- --- --
--  Code   --
-- --- --- --

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

quit = function()
    deleteWindow()
    vlc.deactivate()
end

showWindow = function()
    window:show()
end

windowFormConfiguration = function()
    prepareWindow('Items configuration')
    uiFormConfiguration.displayForm()
    showWindow()
end

windowFormFileName = function()
    context.fillSavedConfigurations()
    prepareWindow('Manage configuration(s)')
    uiFormFileName.displayForm()
    showWindow()
end

windowFormItemType = function()
    prepareWindow('Item configuration')

    local yButtonAdd
    if 'Folder' == uiWip.itemType then
        uiFormItemFolder.displayForm()

        yButtonAdd = 7
    elseif 'File' == uiWip.itemType then
        uiFormItemFile.displayForm()

        yButtonAdd = 4
    elseif 'Url' == uiWip.itemType then
        uiFormItemUrl.displayForm()

        yButtonAdd = 2
    end

    window:add_button('Go back', windowFormConfiguration, 1, yButtonAdd)
    window:add_button('Add', uiFormConfiguration.addItem, 2, yButtonAdd)

    showWindow()
end

-- --- --- --
-- Exports --
-- --- --- --

return {
    getWindow = getWindow,
    quit = quit,
    windowFormConfiguration = windowFormConfiguration,
    windowFormFileName = windowFormFileName,
    windowFormItemType = windowFormItemType,
}