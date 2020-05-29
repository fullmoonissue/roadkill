-- --- --- --
-- Require --
-- --- --- --

local _vlc_ = require('src/vlc')
local context = require('src/context')
local utils = require('src/utils')

-- --- --- --
-- Header  --
-- --- --- --

-- Methods
local
addItem,
addItems,
compile,
compileItem

-- --- --- --
--  Code   --
-- --- --- --

-- Add item into the playlist if the item is properly setup
addItem = function(name, properties, playlistItems)
    if properties ~= nil then
        -- if we have a folder :
        -- 1. get items from the folder
        -- 2. add them individually to the playlist
        if properties['folder'] ~= nil then
            local items = {}
            compileItem(properties, items)
            for _, item in ipairs(items) do
                addItem(name, item, playlistItems)
            end
        else
            -- else, we have an item

            -- check that the protocol (and path) is set ...
            local path
            if properties['url'] ~= nil then
                path = properties['url']
            elseif properties['file'] ~= nil then
                path = 'file://' .. properties['file']
            end

            if path ~= nil then
                -- ... prepare a VLC playlist item ...
                local item = {
                    ['path'] = path,
                    ['name'] = name,
                    ['options'] = {},
                }
                -- ... add vlc options, if wanted
                for _, optionMethod in ipairs(_vlc_.options) do
                    if properties[optionMethod['option']] ~= nil then
                        table.insert(
                            item['options'],
                            _vlc_.optionMethod(optionMethod['option'])(properties[optionMethod['option']])
                        )
                    end
                end

                table.insert(playlistItems, item)
            end
        end
    end
end

-- Iterate overs items to add them into the playlist
addItems = function(name, items, playlistItems)
    if items ~= nil then
        for index, item in ipairs(utils.toList(items)) do
            addItem(
                string.format(name, index),
                item,
                playlistItems
            )
        end
    end
end

compile = function(config, playlistItems)
    if playlistItems == nil then
        playlistItems = {}
    end

    -- Transform work-items folder into work-items files
    local workItems = {}
    if config['work-items'] ~= nil then
        for _, workItem in ipairs(utils.toList(config['work-items'])) do
            compileItem(workItem, workItems)
        end
    end
    config['work-items'] = workItems

    -- Prepare all the items to be added to the playlist ...
    -- ... 1. items into the "work-before-all" root key ...
    addItems(context.texts['work-before-all'], config['work-before-all'], playlistItems)
    -- ... Then for each "work-items" root key items ...
    for _, workItem in ipairs(config['work-items']) do
        -- ... 2. items into the "work-start" root key
        addItems(context.texts['work-start'], config['work-start'], playlistItems)
        -- ... 3. the current work item
        addItem(context.texts['work-items'], workItem, playlistItems)
        -- ... 4. items into the "work-end" root key
        addItems(context.texts['work-end'], config['work-end'], playlistItems)
    end
    -- ... 5. finally, items into the "work-after-all" root key ...
    addItems(context.texts['work-after-all'], config['work-after-all'], playlistItems)
end

-- Transform item with a `folder` key into a list of items with a `file` key
-- Taking care of custom options (randomization, ...)
-- Keep already set VLC options (duration, ...)
compileItem = function(workItem, workItems)
    -- If a folder is present ...
    if workItem['folder'] ~= nil then
        -- ... list the valid files ...
        local workFiles = {}
        for _, workFile in ipairs(_vlc_.readdir(workItem['folder'])) do
            if workFile ~= '.' and workFile ~= '..' then
                table.insert(workFiles, workItem['folder'] .. '/' .. workFile)
            end
        end

        -- ... randomize them, if wanted ...
        if workItem['random'] ~= nil and workItem['random'] then
            workFiles = utils.shuffle(workFiles)
        end

        -- ... keep a certain number, if wanted ...
        if workItem['nbElements'] ~= nil then
            local selectedWorkFiles = {}
            for _, workFile in ipairs(workFiles) do
                if workItem['nbElements'] > #selectedWorkFiles then
                    table.insert(selectedWorkFiles, workFile)
                end
            end
            workFiles = selectedWorkFiles
        end

        -- ... repeat items, if wanted ...
        if workItem['loop'] ~= nil then
            local repeatedWorkFiles = {}
            for _, workFile in ipairs(workFiles) do
                for _ = 1, workItem['loop'] do
                    table.insert(repeatedWorkFiles, workFile)
                end
            end
            workFiles = repeatedWorkFiles
        end

        -- ... create new items for each file (and keeping the initial vlc options)
        for _, workFile in ipairs(workFiles) do
            local newWorkItem = {
                ['file'] = workFile
            }
            -- Bring back the options defined for the folder to the new work item
            for _, methodByOption in ipairs(_vlc_.options) do
                if workItem[methodByOption['option']] ~= nil then
                    newWorkItem[methodByOption['option']] = workItem[methodByOption['option']]
                end
            end

            table.insert(workItems, newWorkItem)
        end
    else
        -- ... else, just keep the item as it is
        table.insert(workItems, workItem)
    end
end

-- --- --- --
-- Exports --
-- --- --- --

return {
    addItem = addItem,
    addItems = addItems,
    compile = compile,
    compileItem = compileItem,
}