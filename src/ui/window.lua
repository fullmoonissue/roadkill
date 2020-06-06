-- --- --- --
-- Require --
-- --- --- --

local context = require('src/context')
local uiFormFileName = require('src/ui/form/name')
local uiFormItems = require('src/ui/form/items')
local uiFormItemFile = require('src/ui/form/type/file')
local uiFormItemFolder = require('src/ui/form/type/folder')
local uiFormItemUrl = require('src/ui/form/type/url')

-- --- --- --
-- Header  --
-- --- --- --

-- Fields
local vlcDialog -- Window (VLC Dialog) where forms will be shown

-- Methods
local
delete, -- delete an existing window
formConfiguration, -- prepare, add form ans show the window about configuration building
formFileName, -- prepare, add form ans show the window about configurations
formItemType, -- prepare, add form ans show the window about a type of item
get, -- retrieve an existing window
prepare, -- setup a new window
show -- show the window

-- --- --- --
--  Code   --
-- --- --- --

delete = function()
    if vlcDialog ~= nil then
        vlcDialog:delete()
    end
end

formConfiguration = function()
    prepare(string.format('Items configuration of %s', context.wips.fileName))
    uiFormItems.displayForm()
    show()
end

formFileName = function()
    context.fillSavedConfigurations()
    prepare('Dashboard')
    uiFormFileName.displayForm()
    show()
end

formItemType = function()
    prepare(string.format('[%s]', context.wips.itemType))

    if 'Folder' == context.wips.itemType then
        uiFormItemFolder.displayForm()
    elseif 'File' == context.wips.itemType then
        uiFormItemFile.displayForm()
    elseif 'Url' == context.wips.itemType then
        uiFormItemUrl.displayForm()
    end

    show()
end

get = function()
    return vlcDialog
end

prepare = function(title)
    delete()
    vlcDialog = vlc.dialog('Roadkill Window')
    vlcDialog:set_title(string.format('[Roadkill] %s', title))
end

show = function()
    vlcDialog:show()
end

-- --- --- --
-- Exports --
-- --- --- --

return {
    delete = delete,
    formConfiguration = formConfiguration,
    formFileName = formFileName,
    formItemType = formItemType,
    get = get,
}