-- --- --- --
-- Require --
-- --- --- --

local context = require('src/context')
local uiFormItemFile = require('src/ui/form/type/file')
local uiFormItemFolder = require('src/ui/form/type/folder')
local uiFormItemUrl = require('src/ui/form/type/url')
local uiWip = require('src/ui/wip')

-- --- --- --
-- Header  --
-- --- --- --

-- Fields
local
dropdownRootKey, -- form dropdown about the root key
dropdownItemType, -- form dropdown about the item type
labelFeedbackSave, -- form label when a file is saved
listItems -- form list about the root keys and items

-- Methods
local
addItem, -- add a configured item to the configuration
configureItemTypeValues, -- set wip values and call the window item configuration
displayForm, -- add the form about the creation of a configuration
deleteSelectedItems, -- remove selected item(s) of the configuration
fillListItems, -- fill the list
getRootKeyValue, -- retrieve the value of the root key
getItemTypeValue, -- retrieve the value of the item type
saveConfiguration -- write the entries into a configuration file

-- --- --- --
--  Code   --
-- --- --- --

addItem = function()
    local item = {}
    if 'Folder' == uiWip.itemType then
        item['folder'] = uiFormItemFolder.getPathValue()

        if uiFormItemFolder.getRandomValue() then
            item['random'] = true
        end

        local loop = uiFormItemFolder.getLoopValue()
        if loop ~= nil then
            item['loop'] = loop
        end

        local nbElements = uiFormItemFolder.getNbElementsValue()
        if nbElements ~= nil then
            item['nbElements'] = nbElements
        end

        local duration = uiFormItemFolder.getDurationValue()
        if duration ~= nil then
            item['duration'] = duration
        end

        local start = uiFormItemFolder.getStartValue()
        if start ~= nil then
            item['start'] = start
        end
    elseif 'File' == uiWip.itemType then
        item['file'] = uiFormItemFile.getPathValue()

        local duration = uiFormItemFile.getDurationValue()
        if duration ~= nil then
            item['duration'] = duration
        end

        local start = uiFormItemFile.getStartValue()
        if start ~= nil then
            item['start'] = start
        end
    elseif 'Url' == uiWip.itemType then
        item['url'] = uiFormItemUrl.getPathValue()
    end

    table.insert(uiWip.configuration[uiWip.rootKey], item)

    require('src/ui/roadkill').windowFormConfiguration()
end

displayForm = function()
    local roadkill = require('src/ui/roadkill')
    local window = roadkill.getWindow()

    local row = 1
    window:add_label('When ?', 1, row, 2)
    dropdownRootKey = window:add_dropdown(2, row, 2)
    for index, labelRootKey in ipairs(context.textRootKeys) do
        dropdownRootKey:add_value(labelRootKey, index)
    end

    row = row + 1
    window:add_label('Type ?', 1, row)
    dropdownItemType = window:add_dropdown(2, row)
    for index, labelType in ipairs(context.itemTypes) do
        dropdownItemType:add_value(labelType, index)
    end
    window:add_button('Configure...', configureItemTypeValues, 3, row)

    row = row + 1
    window:add_label('Current items', 1, row, 2)
    row = row + 1
    listItems = window:add_list(1, row, 4)
    fillListItems()
    row = row + 1
    window:add_button('🗑️', deleteSelectedItems, 1, row)

    row = row + 1
    window:add_button('Back to dashboard', roadkill.windowFormFileName, 1, row)
    labelFeedbackSave = window:add_label('', 2, row, 2)
    window:add_button('Save', saveConfiguration, 4, row)
end

configureItemTypeValues = function()
    uiWip.rootKey = getRootKeyValue()
    if uiWip.configuration[uiWip.rootKey] == nil then
        uiWip.configuration[uiWip.rootKey] = {}
    end
    uiWip.itemType = getItemTypeValue()

    require('src/ui/roadkill').windowFormItemType()
end

deleteSelectedItems = function()
    local selectedItems = listItems:get_selection()
    local index = 0
    local keptWipConfiguration = {}
    for _, rootKey in ipairs(context.rootKeys) do
        if uiWip.configuration[rootKey] ~= nil then
            keptWipConfiguration[rootKey] = {}
            for _, item in ipairs(uiWip.configuration[rootKey]) do
                index = index + 1
                if selectedItems[index] == nil then
                    table.insert(keptWipConfiguration[rootKey], item)
                end
            end
        end
    end

    uiWip.configuration = keptWipConfiguration

    listItems:clear()
    fillListItems()
end

fillListItems = function()
    local index = 0
    for _, rootKey in ipairs(context.rootKeys) do
        if uiWip.configuration[rootKey] ~= nil then
            for _, item in ipairs(uiWip.configuration[rootKey]) do
                index = index + 1
                local toStringsItem = {}
                if item.folder ~= nil then
                    table.insert(toStringsItem, 'Type : folder')
                    if item.random ~= nil and item.random then
                        table.insert(toStringsItem, 'Random : yes')
                    end
                    if item.loop ~= nil then
                        table.insert(toStringsItem, string.format('Loop : %d', item.loop))
                    end
                    if item.nbElements ~= nil then
                        table.insert(toStringsItem, string.format('Number of elements : %d', item.nbElements))
                    end
                    if item.duration ~= nil then
                        table.insert(toStringsItem, string.format('Duration : %d', item.duration))
                    end
                    if item.start ~= nil then
                        table.insert(toStringsItem, string.format('Start : %d', item.start))
                    end
                    table.insert(toStringsItem, string.format('Location : %s', item.folder))
                elseif item.file ~= nil then
                    table.insert(toStringsItem, 'Type : file')
                    if item.duration ~= nil then
                        table.insert(toStringsItem, string.format('Duration : %d', item.duration))
                    end
                    if item.start ~= nil then
                        table.insert(toStringsItem, string.format('Start : %d', item.start))
                    end
                    table.insert(toStringsItem, string.format('Location : %s', item.file))
                elseif item.url ~= nil then
                    table.insert(toStringsItem, 'Type : url')
                    table.insert(toStringsItem, string.format('Location : %s', item.url))
                end
                listItems:add_value(
                    string.format(
                        '[%s] %s',
                        rootKey,
                        table.concat(toStringsItem, ', ')
                    ),
                    index
                )
            end
        end
    end
end

getRootKeyValue = function()
    return context.rootKeys[dropdownRootKey:get_value()]
end

getItemTypeValue = function()
    return context.itemTypes[dropdownItemType:get_value()]
end

saveConfiguration = function()
    local lines = { 'return {' }
    for _, rootKey in ipairs(context.rootKeys) do
        if uiWip.configuration[rootKey] ~= nil then
            table.insert(lines, string.format('%s[\'%s\'] = {', string.rep(' ', 4), rootKey))
            for _, item in ipairs(uiWip.configuration[rootKey]) do
                table.insert(lines, string.format('%s{', string.rep(' ', 8)))
                for key, _ in pairs(context.keyTypes) do
                    if item[key] ~= nil then
                        table.insert(
                            lines,
                            string.format(
                                '%s[\'%s\'] = \'%s\',',
                                string.rep(' ', 12),
                                key,
                                item[key]
                            )
                        )
                    end
                end
                table.insert(lines, string.format('%s},', string.rep(' ', 8)))
            end
            table.insert(lines, string.format('%s},', string.rep(' ', 4)))
        end
    end
    table.insert(lines, '}')

    local file = vlc.io.open(
        context.getPwd() .. '/' .. context.savesFolder .. '/' .. uiWip.fileName .. '.lua',
        'w'
    )
    file:write(table.concat(lines, "\n"))
    file:close()

    labelFeedbackSave:set_text('File saved')
end

-- --- --- --
-- Exports --
-- --- --- --

return {
    addItem = addItem,
    displayForm = displayForm,
}