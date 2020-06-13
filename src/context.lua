-- --- --- --
-- Require --
-- --- --- --

local _vlc_ = require('src/vlc')
local utils = require('src/utils')

-- --- --- --
-- Header  --
-- --- --- --

-- Fields
local itemTypes = {
    'Folder',
    'File',
    'Url',
}
local keyTypes = { -- Keys (and associated type) available in root keys
    file = 'string',
    startAt = 'number',
    stopAt = 'number',
    folder = 'string',
    random = 'boolean',
    loop = 'number',
    nbElements = 'number',
    url = 'string',
}
local pwd = '' -- unknown at the beginning
local rootKeys = { -- Root keys to put into the composition table
    'work-before-all',
    'work-start',
    'work-items',
    'work-end',
    'work-after-all'
}
local savedCompositions = {}
local savesFolder = 'saves'
local wips = { -- These wip variables are the memory of the set values across windows
    composition = {},
    fileName = nil,
    formFile = {
        path = '',
        startAt = '',
        stopAt = '',
    },
    formFolder = {
        path = '',
        random = '',
        loop = '',
        nbElements = '',
        startAt = '',
        stopAt = '',
    },
    formUrl = {
        path = '',
    },
    itemType = nil,
    position = nil,
    rootKey = nil,
}

-- Methods
local
fillSavedCompositions,
getPwd,
getSavedCompositions,
isValid,
setPwd

-- --- --- --
--  Code   --
-- --- --- --

fillSavedCompositions = function()
    savedCompositions = {}
    for _, savedComposition in ipairs(_vlc_.readdir(string.format('%s/%s', pwd, savesFolder))) do
        if savedComposition ~= '.' and savedComposition ~= '..' and savedComposition ~= '.gitkeep' then
            table.insert(savedCompositions, string.sub(savedComposition, 0, -5))
        end
    end

    table.sort(savedCompositions)
end

getPwd = function()
    return pwd
end

getSavedCompositions = function()
    return savedCompositions
end

isValid = function(config, messages)
    local errorMessage = 'Key "%s" must be a %s in %s'
    if messages == nil then
        messages = {}
    end

    for _, rootKey in ipairs(rootKeys) do
        if config[rootKey] ~= nil then
            for _, item in ipairs(utils.toList(config[rootKey])) do
                for key, keyType in pairs(keyTypes) do
                    if item[key] ~= nil then
                        if type(item[key]) ~= keyType then
                            table.insert(messages, string.format(errorMessage, key, keyType, rootKey))
                        end
                    end
                end
            end
        end
    end

    return 0 == #messages
end

setPwd = function(newPwd)
    pwd = newPwd
end

-- --- --- --
-- Exports --
-- --- --- --

return {
    fillSavedCompositions = fillSavedCompositions,
    getPwd = getPwd,
    getSavedCompositions = getSavedCompositions,
    isValid = isValid,
    itemTypes = itemTypes,
    keyTypes = keyTypes,
    rootKeys = rootKeys,
    savesFolder = savesFolder,
    setPwd = setPwd,
    wips = wips,
}