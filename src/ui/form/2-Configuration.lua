local context = require('src/context')
local uiFormItemFile = require('src/ui/form/3-ItemFile')
local uiFormItemFolder = require('src/ui/form/3-ItemFolder')
local uiFormItemUrl = require('src/ui/form/3-ItemUrl')
local uiWip = require('src/ui/wip')

-- Form elements
local   dropdownRootKey,
        dropdownType,
        listEntries
-- Methods
local   addEntries,
        addMediumToConfiguration,
        configureItemTypeValues,
        deleteSelectedItems,
        getRootKeyValue,
        getTypeValue,
        saveConfiguration

--
-- Methods
--

addEntries = function()
    local index = 0
    for _, rootKey in ipairs(context.rootKeys) do
        if uiWip.wipConfiguration[rootKey] ~= nil then
            for _, item in ipairs(uiWip.wipConfiguration[rootKey]) do
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
                listEntries:add_value(
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

addMediumToConfiguration = function()
    local item = {}
    if 1 == uiWip.wipType then
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
    elseif 2 == uiWip.wipType then
        item['file'] = uiFormItemFile.getPathValue()

        local duration = uiFormItemFile.getDurationValue()
        if duration ~= nil then
            item['duration'] = duration
        end

        local start = uiFormItemFile.getStartValue()
        if start ~= nil then
            item['start'] = start
        end
    elseif 3 == uiWip.wipType then
        item['url'] = uiFormItemUrl.getPathValue()
    end

    table.insert(uiWip.wipConfiguration[uiWip.wipWhen], item)

    require('src/ui/roadkill').windowFormConfiguration()
end

configureItemTypeValues = function()
    uiWip.wipWhen = getRootKeyValue()
    if uiWip.wipConfiguration[uiWip.wipWhen] == nil then
        uiWip.wipConfiguration[uiWip.wipWhen] = {}
    end
    uiWip.wipType = getTypeValue()

    require('src/ui/roadkill').windowFormItemType()
end

deleteSelectedItems = function()
    local selectedItems = listEntries:get_selection()
    local index = 0
    local keptWipConfiguration = {}
    for _, rootKey in ipairs(context.rootKeys) do
        if uiWip.wipConfiguration[rootKey] ~= nil then
            keptWipConfiguration[rootKey] = {}
            for _, item in ipairs(uiWip.wipConfiguration[rootKey]) do
                index = index + 1
                if selectedItems[index] == nil then
                    table.insert(keptWipConfiguration[rootKey], item)
                end
            end
        end
    end

    uiWip.wipConfiguration = keptWipConfiguration

    listEntries:clear()
    addEntries()
end

getRootKeyValue = function()
    return context.rootKeys[dropdownRootKey:get_value()]
end

getTypeValue = function()
    return dropdownType:get_value()
end

saveConfiguration = function()
    local lines = { 'return {' }
    for _, rootKey in ipairs(context.rootKeys) do
        if uiWip.wipConfiguration[rootKey] ~= nil then
            table.insert(lines, string.format('%s[\'%s\'] = {', string.rep(' ', 4), rootKey))
            for _, item in ipairs(uiWip.wipConfiguration[rootKey]) do
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

    local file = vlc.io.open(context.pwd .. '/' .. context.savesFolder .. '/' .. uiWip.wipFileName .. '.lua', 'w')
    file:write(table.concat(lines, "\n"))
    file:close()
end

--
-- Exports
--

return {
    appendNewForm = function()
        local roadkill = require('src/ui/roadkill')
        local window = roadkill.getWindow()

        local row = 1
        window:add_label('When ?', 1, row, 2)
        dropdownRootKey = window:add_dropdown(2, row, 2)
        for index, labelWhen in ipairs(context.when) do
            dropdownRootKey:add_value(labelWhen, index)
        end

        row = row + 1
        window:add_label('Type ?', 1, row)
        dropdownType = window:add_dropdown(2, row)
        for index, labelType in ipairs(context.type) do
            dropdownType:add_value(labelType, index)
        end
        window:add_button('Configure...', configureItemTypeValues, 3, row)

        row = row + 1
        window:add_label('Current items', 1, row, 2)
        row = row + 1
        listEntries = window:add_list(1, row, 4)
        addEntries()
        row = row + 1
        window:add_button('🗑️', deleteSelectedItems, 1, row)

        row = row + 1
        window:add_button('Back to dashboard', roadkill.windowFormFileName, 1, row)
        window:add_label('', 2, row, 2)
        window:add_button('Save', saveConfiguration, 4, row)
    end,

    addMediumToConfiguration = addMediumToConfiguration,
    getRootKeyValue = getRootKeyValue,
    getTypeValue = getTypeValue,
}