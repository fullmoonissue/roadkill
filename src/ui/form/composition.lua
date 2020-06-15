-- --- --- --
-- Require --
-- --- --- --

local context = require('src/context')
local i18nModule = require('src/ui/i18n')
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
buttonsRootKey,
buttonWorkAfterAll,
buttonWorkBeforeAll,
buttonWorkEnd,
buttonWorkItems,
buttonWorkStart,
dropdownRootKey, -- form dropdown about the root key
dropdownItemType, -- form dropdown about the item type
i18n,
labelFeedbackSave, -- form label when a file is saved
dropdownComplexActionsOnSelectedItem,
dropdownComplexActionsOnPosition,
dropdownComplexActionsOnTarget,
dropdownSimpleActionsOnSelectedItem,
listItems, -- form list about the root keys and items
listRootKeyCurrent

-- Methods
local
addItem, -- add a configured item to the composition
applyComplexActionOnSelectedItem,
applySimpleActionOnSelectedItem,
configureItemTypeValues, -- set wip values and call the window item composition
displayForm, -- add the form about the creation of a composition
fillListItems, -- fill the list
getButtonListLabel,
getRootKeyValue, -- retrieve the value of the root key
getItemTypeValue, -- retrieve the value of the item type
listWorkAfterAll,
listWorkBeforeAll,
listWorkEnd,
listWorkItems,
listWorkStart,
retrieveFileProperties,
retrieveFolderProperties,
retrieveItemProperties,
retrieveUrlProperties,
saveComposition, -- write the entries into a composition file
updateItem

-- --- --- --
--  Code   --
-- --- --- --

addItem = function()
    table.insert(context.wips.composition[context.wips.rootKey], retrieveItemProperties())

    require('src/ui/window').formComposition()
end

applyComplexActionOnSelectedItem = function()
    i18n = i18nModule.getTranslations()

    local selectedItem
    local selectedItems = listItems:get_selection()
    local rootKey = listRootKeyCurrent
    if context.wips.composition[rootKey] ~= nil then
        for index, item in ipairs(context.wips.composition[rootKey]) do
            if nil == selectedItem and selectedItems[index] ~= nil then
                selectedItem = item
                context.wips.position = index
            end
        end
    end

    if selectedItem ~= nil then
        -- Shift or Duplicate
        if -1 ~= dropdownComplexActionsOnSelectedItem:get_value() then
            local targetPosition = dropdownComplexActionsOnTarget:get_value()
            local position = dropdownComplexActionsOnPosition:get_value()
            if targetPosition >= 1 and position >= 1 then
                local keptComposition = {}
                local selectedItemInserted = false

                if context.wips.composition[context.rootKeys[targetPosition]] ~= nil then
                    for index, item in pairs(context.wips.composition[context.rootKeys[targetPosition]]) do
                        if index == position then
                            selectedItemInserted = true
                            table.insert(keptComposition, selectedItem)
                        end
                        table.insert(keptComposition, item)
                    end
                    -- If the choose position is higher than the length of the rootKey count of elements
                    if not selectedItemInserted then
                        table.insert(keptComposition, selectedItem)
                    end
                else
                    table.insert(keptComposition, selectedItem)
                end

                context.wips.composition[context.rootKeys[targetPosition]] = keptComposition

                local associatedButton = buttonsRootKey[targetPosition]
                associatedButton:set_text(
                    getButtonListLabel(
                        context.rootKeys[targetPosition],
                        i18n.textRootKeys[context.rootKeys[targetPosition]]
                    )
                )

                -- Shift
                if 1 == dropdownComplexActionsOnSelectedItem:get_value() then
                    keptComposition = {}

                    for index, item in pairs(context.wips.composition[rootKey]) do
                        if index ~= context.wips.position then
                            table.insert(keptComposition, item)
                        end
                    end

                    context.wips.composition[rootKey] = keptComposition

                    buttonRootKeyClicked:set_text(
                        getButtonListLabel(
                            rootKey,
                            i18n.textRootKeys[rootKey]
                        )
                    )
                end

                listItems:clear()
                fillListItems(rootKey)
            end
        end
    end
end

applySimpleActionOnSelectedItem = function()
    i18n = i18nModule.getTranslations()

    local selectedItem
    local selectedItems = listItems:get_selection()
    local rootKey = listRootKeyCurrent
    if context.wips.composition[rootKey] ~= nil then
        for index, item in ipairs(context.wips.composition[rootKey]) do
            if nil == selectedItem and selectedItems[index] ~= nil then
                selectedItem = item
                context.wips.position = index
            end
        end
    end

    if selectedItem ~= nil then
        -- Move Up
        if 1 == dropdownSimpleActionsOnSelectedItem:get_value() then
            for index, _ in ipairs(context.wips.composition[rootKey]) do
                if index > 1 and selectedItems[index] ~= nil then
                    local permutation = context.wips.composition[rootKey][(index - 1)]
                    context.wips.composition[rootKey][(index - 1)] = context.wips.composition[rootKey][index]
                    context.wips.composition[rootKey][index] = permutation
                end
            end

            listItems:clear()
            fillListItems(rootKey)
        -- Move Down
        elseif 2 == dropdownSimpleActionsOnSelectedItem:get_value() then
            for index = #context.wips.composition[rootKey], 1, -1 do
                if index < #context.wips.composition[rootKey] and selectedItems[index] ~= nil then
                    local permutation = context.wips.composition[rootKey][(index + 1)]
                    context.wips.composition[rootKey][(index + 1)] = context.wips.composition[rootKey][index]
                    context.wips.composition[rootKey][index] = permutation
                end
            end

            listItems:clear()
            fillListItems(rootKey)
        -- Update
        elseif 3 == dropdownSimpleActionsOnSelectedItem:get_value() then
            local itemType
            if selectedItem.folder ~= nil then
                itemType = 'Folder'
                context.wips.formFolder = {
                    path = selectedItem.folder,
                    random = selectedItem.random,
                    loop = selectedItem.loop,
                    nbElements = selectedItem.nbElements,
                    startAt = selectedItem.startAt,
                    stopAt = selectedItem.stopAt,
                }
            elseif selectedItem.file ~= nil then
                itemType = 'File'
                context.wips.formFile = {
                    path = selectedItem.file,
                    startAt = selectedItem.startAt,
                    stopAt = selectedItem.stopAt,
                }
            elseif selectedItem.url ~= nil then
                itemType = 'Url'
                context.wips.formUrl = {
                    path = selectedItem.url,
                }
            end

            context.wips.rootKey = rootKey
            context.wips.itemType = itemType

            require('src/ui/window').formItemType()
        -- Delete
        elseif 4 == dropdownSimpleActionsOnSelectedItem:get_value() then
            if context.wips.composition[rootKey] ~= nil then
                local index = 0
                local keptWipComposition = {}
                for _, item in ipairs(context.wips.composition[rootKey]) do
                    index = index + 1
                    if selectedItems[index] == nil then
                        table.insert(keptWipComposition, item)
                    end
                end

                context.wips.composition[rootKey] = keptWipComposition

                listItems:clear()
                fillListItems(rootKey)
                buttonRootKeyClicked:set_text(getButtonListLabel(rootKey, i18n.textRootKeys[rootKey]))
            end
        end
    end
end

displayForm = function()
    i18n = i18nModule.getTranslations()

    local uiWindow = require('src/ui/window')
    local window = uiWindow.get()

    local row = 1
    window:add_label(string.format('<b>%s</b>', i18n.formComposition.label.addItem), 1, row)

    row = row + 1
    dropdownRootKey = window:add_dropdown(1, row)
    dropdownRootKey:add_value(i18n.textRootKeys['work-before-all'], 1)
    dropdownRootKey:add_value(i18n.textRootKeys['work-start'], 2)
    dropdownRootKey:add_value(i18n.textRootKeys['work-items'], 3)
    dropdownRootKey:add_value(i18n.textRootKeys['work-end'], 4)
    dropdownRootKey:add_value(i18n.textRootKeys['work-after-all'], 5)

    dropdownItemType = window:add_dropdown(2, row)
    for index, labelType in ipairs(context.itemTypes) do
        dropdownItemType:add_value(i18n.textItemTypes[labelType], index)
    end

    window:add_button(i18n.formComposition.button.configureType, configureItemTypeValues, 3, row)

    row = row + 1
    window:add_label(string.format('<br /><b>%s</b>', i18n.formComposition.label.listItems), 1, row, 2)
    row = row + 1
    local col = 1
    buttonWorkBeforeAll = window:add_button(
        getButtonListLabel(context.rootKeys[col], i18n.textRootKeys[context.rootKeys[col]]),
        listWorkBeforeAll,
        col,
        row
    )
    col = col + 1
    buttonWorkStart = window:add_button(
        getButtonListLabel(context.rootKeys[col], i18n.textRootKeys[context.rootKeys[col]]),
        listWorkStart,
        col,
        row
    )
    col = col + 1
    buttonWorkItems = window:add_button(
        getButtonListLabel(context.rootKeys[col], i18n.textRootKeys[context.rootKeys[col]]),
        listWorkItems,
        col,
        row
    )
    col = col + 1
    buttonWorkEnd = window:add_button(
        getButtonListLabel(context.rootKeys[col], i18n.textRootKeys[context.rootKeys[col]]),
        listWorkEnd,
        col,
        row
    )
    col = col + 1
    buttonWorkAfterAll = window:add_button(
        getButtonListLabel(context.rootKeys[col], i18n.textRootKeys[context.rootKeys[col]]),
        listWorkAfterAll,
        col,
        row
    )
    buttonsRootKey = {
        buttonWorkBeforeAll,
        buttonWorkStart,
        buttonWorkItems,
        buttonWorkEnd,
        buttonWorkAfterAll,
    }
    row = row + 1

    listItems = window:add_list(1, row, 5)

    row = row + 1

    window:add_label(string.format('<br /><b>%s</b>', i18n.formComposition.label.actions), 1, row)

    row = row + 1

    dropdownSimpleActionsOnSelectedItem = window:add_dropdown(1, row)
    dropdownSimpleActionsOnSelectedItem:add_value(i18n.formComposition.dropdown.onSelectedItem, -1)
    dropdownSimpleActionsOnSelectedItem:add_value(string.format('⬆ %s', i18n.formComposition.dropdown.moveUp), 1)
    dropdownSimpleActionsOnSelectedItem:add_value(string.format('⬇ %s', i18n.formComposition.dropdown.moveDown), 2)
    dropdownSimpleActionsOnSelectedItem:add_value(string.format('✏ %s', i18n.formComposition.dropdown.update), 3)
    dropdownSimpleActionsOnSelectedItem:add_value(string.format('🗑️ %s', i18n.formComposition.dropdown.delete), 4)

    window:add_button(i18n.formComposition.button.apply, applySimpleActionOnSelectedItem, 2, row)

    row = row + 1

    dropdownComplexActionsOnSelectedItem = window:add_dropdown(1, row)
    dropdownComplexActionsOnSelectedItem:add_value(i18n.formComposition.dropdown.onSelectedItem, -1)
    dropdownComplexActionsOnSelectedItem:add_value(string.format('📦 %s', i18n.formComposition.dropdown.shift), 1)
    dropdownComplexActionsOnSelectedItem:add_value(string.format('➿ %s', i18n.formComposition.dropdown.duplicate), 2)

    dropdownComplexActionsOnTarget = window:add_dropdown(2, row)
    dropdownComplexActionsOnTarget:add_value(i18n.formComposition.dropdown.to, 1)
    dropdownComplexActionsOnTarget:add_value(i18n.textRootKeys['work-before-all'], 1)
    dropdownComplexActionsOnTarget:add_value(i18n.textRootKeys['work-start'], 2)
    dropdownComplexActionsOnTarget:add_value(i18n.textRootKeys['work-items'], 3)
    dropdownComplexActionsOnTarget:add_value(i18n.textRootKeys['work-end'], 4)
    dropdownComplexActionsOnTarget:add_value(i18n.textRootKeys['work-after-all'], 5)

    dropdownComplexActionsOnPosition = window:add_dropdown(3, row)
    dropdownComplexActionsOnPosition:add_value(i18n.formComposition.dropdown.position, -1)
    local maxItems = 0
    for _, items in pairs(context.wips.composition) do
        if #items > maxItems then
            maxItems = #items
        end
    end
    for position = 1, maxItems + 1 do
        dropdownComplexActionsOnPosition:add_value(position, position)
    end

    window:add_button(i18n.formComposition.button.apply, applyComplexActionOnSelectedItem, 4, row)

    row = row + 1

    window:add_label('<br />', 1, row)

    row = row + 1
    window:add_button(i18n.formComposition.button.backToDashboard, uiWindow.formFileName, 1, row)
    labelFeedbackSave = window:add_label('', 2, row, 3)
    window:add_button(i18n.formComposition.button.save, saveComposition, 5, row)
end

configureItemTypeValues = function()
    context.wips.rootKey = getRootKeyValue()
    if context.wips.composition[context.wips.rootKey] == nil then
        context.wips.composition[context.wips.rootKey] = {}
    end
    context.wips.itemType = getItemTypeValue()

    require('src/ui/window').formItemType()
end

fillListItems = function(rootKey)
    local index = 0
    if context.wips.composition[rootKey] ~= nil then
        for _, item in ipairs(context.wips.composition[rootKey]) do
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
                if item.startAt ~= nil then
                    addSeparator = true
                    table.insert(toStringsItem, string.format('🎬 (%d)', item.startAt))
                end
                if item.stopAt ~= nil then
                    addSeparator = true
                    table.insert(toStringsItem, string.format('⏲️ (%d)', item.stopAt))
                end
                if addSeparator then
                    table.insert(toStringsItem, '|')
                end
                table.insert(toStringsItem, string.format('%s', item.folder))
            elseif item.file ~= nil then
                table.insert(toStringsItem, '📄')
                table.insert(toStringsItem, '|')
                local addSeparator = false
                if item.startAt ~= nil then
                    addSeparator = true
                    table.insert(toStringsItem, string.format('🎬 (%d)', item.startAt))
                end
                if item.stopAt ~= nil then
                    addSeparator = true
                    table.insert(toStringsItem, string.format('⏲️ (%d)', item.stopAt))
                end
                if addSeparator then
                    table.insert(toStringsItem, '|')
                end
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
        nil == context.wips.composition[rootKey]
            and 0
            or #context.wips.composition[rootKey],
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

retrieveItemProperties = function()
    local associationMethod = {
        Folder = retrieveFolderProperties,
        File = retrieveFileProperties,
        Url = retrieveUrlProperties,
    }

    return associationMethod[context.wips.itemType]()
end

retrieveFileProperties = function()
    local item = {}
    item['file'] = uiFormItemFile.getPathValue()

    local startAt = uiFormItemFile.getStartAtValue()
    if startAt ~= nil then
        item['startAt'] = startAt
    end

    local stopAt = uiFormItemFile.getStopAtValue()
    if stopAt ~= nil then
        item['stopAt'] = stopAt
    end

    return item
end

retrieveFolderProperties = function()
    local item = {}
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

    local startAt = uiFormItemFolder.getStartAtValue()
    if startAt ~= nil then
        item['startAt'] = startAt
    end

    local stopAt = uiFormItemFolder.getStopAtValue()
    if stopAt ~= nil then
        item['stopAt'] = stopAt
    end

    return item
end

retrieveUrlProperties = function()
    return {
        url = uiFormItemUrl.getPathValue()
    }
end

saveComposition = function()
    i18n = i18nModule.getTranslations()

    local nbItemsInserted = 0
    local lines = { 'return {' }
    for _, rootKey in ipairs(context.rootKeys) do
        if context.wips.composition[rootKey] ~= nil then
            table.insert(lines, string.format('%s[\'%s\'] = {', string.rep(' ', 4), rootKey))
            for _, item in ipairs(context.wips.composition[rootKey]) do
                table.insert(lines, string.format('%s{', string.rep(' ', 8)))
                for key, _ in pairs(context.keyTypes) do
                    if item[key] ~= nil then
                        nbItemsInserted = nbItemsInserted + 1
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

    if 0 == nbItemsInserted then
        labelFeedbackSave:set_text(
            string.format(
                '<span style="color:red;">%s</span>',
                i18n.formComposition.error.noItemsNoSave
            )
        )
    else
        utils.createFile(
            string.format('%s/%s/%s.lua', context.getPwd(), context.savesFolder, context.wips.fileName),
            table.concat(lines, "\n")
        )

        labelFeedbackSave:set_text(
            string.format(
                '<span style="color:green;">%s</span>',
                i18n.formComposition.success.fileSaved
            )
        )
    end
end

updateItem = function()
    context.wips.composition[context.wips.rootKey][context.wips.position] = retrieveItemProperties()
    context.wips.formFile = {
        path = '',
        startAt = '',
        stopAt = '',
    }

    require('src/ui/window').formComposition()
end

-- --- --- --
-- Exports --
-- --- --- --

return {
    addItem = addItem,
    displayForm = displayForm,
    updateItem = updateItem,
}