-- --- --- --
-- Require --
-- --- --- --

local context = require('src/context')
local uiFormItemFile = require('src/ui/form/type/file')
local uiFormItemFolder = require('src/ui/form/type/folder')
local uiFormItemUrl = require('src/ui/form/type/url')
local utils = require('src/utils')

-- --- --- --
-- Header  --
-- --- --- --

-- Fields
local
buttonRootKeyClicked,
buttonWorkAfterAll,
buttonWorkBeforeAll,
buttonWorkEnd,
buttonWorkItems,
buttonWorkStart,
dropdownRootKey, -- form dropdown about the root key
dropdownItemType, -- form dropdown about the item type
labelFeedbackSave, -- form label when a file is saved
listItems, -- form list about the root keys and items
listRootKeyCurrent

-- Methods
local
addItem, -- add a configured item to the configuration
configureItemTypeValues, -- set wip values and call the window item configuration
displayForm, -- add the form about the creation of a configuration
deleteSelectedItems, -- remove selected item(s) of the configuration
fillListItems, -- fill the list
getButtonListLabel,
getRootKeyValue, -- retrieve the value of the root key
getItemTypeValue, -- retrieve the value of the item type
listWorkAfterAll,
listWorkBeforeAll,
listWorkEnd,
listWorkItems,
listWorkStart,
moveDownSelectedItems,
moveUpSelectedItems,
saveConfiguration -- write the entries into a configuration file

-- --- --- --
--  Code   --
-- --- --- --

addItem = function()
    local item = {}
    if 'Folder' == context.wips.itemType then
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
    elseif 'File' == context.wips.itemType then
        item['file'] = uiFormItemFile.getPathValue()

        local duration = uiFormItemFile.getDurationValue()
        if duration ~= nil then
            item['duration'] = duration
        end

        local start = uiFormItemFile.getStartValue()
        if start ~= nil then
            item['start'] = start
        end
    elseif 'Url' == context.wips.itemType then
        item['url'] = uiFormItemUrl.getPathValue()
    end

    table.insert(context.wips.configuration[context.wips.rootKey], item)

    require('src/ui/window').formConfiguration()
end

displayForm = function()
    local uiWindow = require('src/ui/window')
    local window = uiWindow.get()

    local row = 1
    window:add_label('Add an item', 1, row)

    row = row + 1
    dropdownRootKey = window:add_dropdown(1, row)
    dropdownRootKey:add_value(context.textRootKeys['work-before-all'], 1)
    dropdownRootKey:add_value(context.textRootKeys['work-start'], 2)
    dropdownRootKey:add_value(context.textRootKeys['work-items'], 3)
    dropdownRootKey:add_value(context.textRootKeys['work-end'], 4)
    dropdownRootKey:add_value(context.textRootKeys['work-after-all'], 5)

    dropdownItemType = window:add_dropdown(2, row)
    for index, labelType in ipairs(context.itemTypes) do
        dropdownItemType:add_value(labelType, index)
    end

    window:add_button('Configure...', configureItemTypeValues, 3, row)

    row = row + 1
    window:add_label('List items', 1, row, 2)
    row = row + 1
    local col = 1
    buttonWorkBeforeAll = window:add_button(
        getButtonListLabel(context.rootKeys[col], context.textRootKeys[context.rootKeys[col]]),
        listWorkBeforeAll,
        col,
        row
    )
    col = col + 1
    buttonWorkStart = window:add_button(
        getButtonListLabel(context.rootKeys[col], context.textRootKeys[context.rootKeys[col]]),
        listWorkStart,
        col,
        row
    )
    col = col + 1
    buttonWorkItems = window:add_button(
        getButtonListLabel(context.rootKeys[col], context.textRootKeys[context.rootKeys[col]]),
        listWorkItems,
        col,
        row
    )
    col = col + 1
    buttonWorkEnd = window:add_button(
        getButtonListLabel(context.rootKeys[col], context.textRootKeys[context.rootKeys[col]]),
        listWorkEnd,
        col,
        row
    )
    col = col + 1
    buttonWorkAfterAll = window:add_button(
        getButtonListLabel(context.rootKeys[col], context.textRootKeys[context.rootKeys[col]]),
        listWorkAfterAll,
        col,
        row
    )
    row = row + 1
    listItems = window:add_list(1, row, 5)
    row = row + 1
    window:add_button('⬆️', moveUpSelectedItems, 1, row)
    window:add_button('🗑️', deleteSelectedItems, 2, row)
    window:add_button('⬇️', moveDownSelectedItems, 3, row)

    row = row + 1
    window:add_button('Back to dashboard', uiWindow.formFileName, 1, row)
    labelFeedbackSave = window:add_label('', 2, row, 3)
    window:add_button('Save', saveConfiguration, 5, row)
end

configureItemTypeValues = function()
    context.wips.rootKey = getRootKeyValue()
    if context.wips.configuration[context.wips.rootKey] == nil then
        context.wips.configuration[context.wips.rootKey] = {}
    end
    context.wips.itemType = getItemTypeValue()

    require('src/ui/window').formItemType()
end

deleteSelectedItems = function()
    local selectedItems = listItems:get_selection()
    local index = 0
    local keptWipConfiguration = {}
    local rootKey = listRootKeyCurrent
    if context.wips.configuration[rootKey] ~= nil then
        keptWipConfiguration = {}
        for _, item in ipairs(context.wips.configuration[rootKey]) do
            index = index + 1
            if selectedItems[index] == nil then
                table.insert(keptWipConfiguration, item)
            end
        end
    end

    context.wips.configuration[rootKey] = keptWipConfiguration

    listItems:clear()
    fillListItems(rootKey)
    buttonRootKeyClicked:set_text(getButtonListLabel(rootKey, context.textRootKeys[rootKey]))
end

fillListItems = function(rootKey)
    local index = 0
    if context.wips.configuration[rootKey] ~= nil then
        for _, item in ipairs(context.wips.configuration[rootKey]) do
            index = index + 1
            local toStringsItem = {}
            if item.folder ~= nil then
                table.insert(toStringsItem, '📁')
                table.insert(toStringsItem, '|')
                local addSeparator = false
                if item.random ~= nil and item.random then
                    addSeparator = true
                    table.insert(toStringsItem, '🔀')
                end
                if item.loop ~= nil then
                    addSeparator = true
                    table.insert(toStringsItem, string.format('🔁 (%d)', item.loop))
                end
                if item.nbElements ~= nil then
                    addSeparator = true
                    table.insert(toStringsItem, string.format('🔢 (%d)', item.nbElements))
                end
                if item.start ~= nil then
                    addSeparator = true
                    table.insert(toStringsItem, string.format('🎬 (%d)', item.start))
                end
                if item.duration ~= nil then
                    addSeparator = true
                    table.insert(toStringsItem, string.format('⏲️ (%d)', item.duration))
                end
                if addSeparator then
                    table.insert(toStringsItem, '|')
                end
                table.insert(toStringsItem, string.format('%s', item.folder))
            elseif item.file ~= nil then
                table.insert(toStringsItem, '📄')
                table.insert(toStringsItem, '|')
                if item.start ~= nil then
                    table.insert(toStringsItem, string.format('🎬 (%d)', item.start))
                end
                if item.duration ~= nil then
                    table.insert(toStringsItem, string.format('⏲️ (%d)', item.duration))
                end
                table.insert(toStringsItem, '|')
                table.insert(toStringsItem, string.format('%s', item.file))
            elseif item.url ~= nil then
                table.insert(toStringsItem, '🔗')
                table.insert(toStringsItem, '|')
                table.insert(toStringsItem, string.format('%s', item.url))
            end
            listItems:add_value(
                table.concat(toStringsItem, ' '),
                index
            )
        end
    end
end

getButtonListLabel = function(rootKey, textRootKey)
    return string.format(
        '(%d) %s',
        nil == context.wips.configuration[rootKey]
            and 0
            or #context.wips.configuration[rootKey],
        textRootKey
    )
end

getRootKeyValue = function()
    return context.rootKeys[dropdownRootKey:get_value()]
end

getItemTypeValue = function()
    return context.itemTypes[dropdownItemType:get_value()]
end

listWorkAfterAll = function()
    local currentRootKey = 'work-after-all'
    listRootKeyCurrent = currentRootKey
    buttonRootKeyClicked = buttonWorkAfterAll
    listItems:clear()
    fillListItems(currentRootKey)
end

listWorkBeforeAll = function()
    local currentRootKey = 'work-before-all'
    listRootKeyCurrent = currentRootKey
    buttonRootKeyClicked = buttonWorkBeforeAll
    listItems:clear()
    fillListItems(currentRootKey)
end

listWorkEnd = function()
    local currentRootKey = 'work-end'
    listRootKeyCurrent = currentRootKey
    buttonRootKeyClicked = buttonWorkEnd
    listItems:clear()
    fillListItems(currentRootKey)
end

listWorkItems = function()
    local currentRootKey = 'work-items'
    listRootKeyCurrent = currentRootKey
    buttonRootKeyClicked = buttonWorkItems
    listItems:clear()
    fillListItems(currentRootKey)
end

listWorkStart = function()
    local currentRootKey = 'work-start'
    listRootKeyCurrent = currentRootKey
    buttonRootKeyClicked = buttonWorkStart
    listItems:clear()
    fillListItems(currentRootKey)
end

moveDownSelectedItems = function()
    local selectedItems = listItems:get_selection()
    local rootKey = listRootKeyCurrent
    for index = #context.wips.configuration[rootKey], 1, -1 do
        if index < #context.wips.configuration[rootKey] and selectedItems[index] ~= nil then
            local permutation = context.wips.configuration[rootKey][(index + 1)]
            context.wips.configuration[rootKey][(index + 1)] = context.wips.configuration[rootKey][index]
            context.wips.configuration[rootKey][index] = permutation
        end
    end

    listItems:clear()
    fillListItems(rootKey)
    buttonRootKeyClicked:set_text(getButtonListLabel(rootKey, context.textRootKeys[rootKey]))
end

moveUpSelectedItems = function()
    local selectedItems = listItems:get_selection()
    local rootKey = listRootKeyCurrent
    for index, _ in ipairs(context.wips.configuration[rootKey]) do
        if index > 1 and selectedItems[index] ~= nil then
            local permutation = context.wips.configuration[rootKey][(index - 1)]
            context.wips.configuration[rootKey][(index - 1)] = context.wips.configuration[rootKey][index]
            context.wips.configuration[rootKey][index] = permutation
        end
    end

    listItems:clear()
    fillListItems(rootKey)
    buttonRootKeyClicked:set_text(getButtonListLabel(rootKey, context.textRootKeys[rootKey]))
end

saveConfiguration = function()
    local lines = { 'return {' }
    for _, rootKey in ipairs(context.rootKeys) do
        if context.wips.configuration[rootKey] ~= nil then
            table.insert(lines, string.format('%s[\'%s\'] = {', string.rep(' ', 4), rootKey))
            for _, item in ipairs(context.wips.configuration[rootKey]) do
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

    utils.createFile(
        context.getPwd() .. '/' .. context.savesFolder .. '/' .. context.wips.fileName .. '.lua',
        table.concat(lines, "\n")
    )

    labelFeedbackSave:set_text('<span style="color:green;">File saved</span>')
end

-- --- --- --
-- Exports --
-- --- --- --

return {
    addItem = addItem,
    displayForm = displayForm,
}