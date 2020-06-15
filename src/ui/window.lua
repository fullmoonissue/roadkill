-- --- --- --
-- Require --
-- --- --- --

local context = require('src/context')
local i18nModule = require('src/ui/i18n')
local uiDashboard = require('src/ui/form/dashboard')
local uiComposition = require('src/ui/form/composition')
local uiFormItemFile = require('src/ui/form/type/file')
local uiFormItemFolder = require('src/ui/form/type/folder')
local uiFormItemUrl = require('src/ui/form/type/url')

-- --- --- --
-- Header  --
-- --- --- --

-- Fields
local
i18n,
vlcDialog -- Window (VLC Dialog) where forms will be shown

-- Methods
local
delete, -- delete an existing window
formComposition, -- prepare, add form ans show the window about composition building
formFileName, -- prepare, add form ans show the window about compositions
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

formComposition = function()
    i18n = i18nModule.getTranslations()
    prepare(string.format(i18n.window.formComposition, context.wips.fileName))
    uiComposition.displayForm()
    show()
end

formFileName = function()
    i18n = i18nModule.getTranslations()
    context.fillSavedCompositions()
    prepare(i18n.window.formDashboard)
    uiDashboard.displayForm()
    show()
end

formItemType = function()
    i18n = i18nModule.getTranslations()
    prepare(string.format(i18n.window.formItemType, i18n.textItemTypes[context.wips.itemType]))

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
    i18n = i18nModule.getTranslations()
    delete()
    vlcDialog = vlc.dialog('')
    vlcDialog:set_title(string.format(i18n.window.prefix, title))
end

show = function()
    vlcDialog:show()
end

-- --- --- --
-- Exports --
-- --- --- --

return {
    delete = delete,
    formComposition = formComposition,
    formFileName = formFileName,
    formItemType = formItemType,
    get = get,
}