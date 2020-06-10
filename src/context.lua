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
    duration = 'number',
    start = 'number',
    folder = 'string',
    random = 'boolean',
    loop = 'number',
    nbElements = 'number',
    url = 'string',
}
local pwd = '' -- unknown at the beginning
local rootKeys = { -- Root keys to put into the configuration table
    'work-before-all',
    'work-start',
    'work-items',
    'work-end',
    'work-after-all'
}
local savedConfigurations = {}
local savesFolder = 'saves'
local wips = { -- These wip variables are the memory of the set values across windows
    configuration = {},
    fileName = nil,
    formFile = {
        path = '',
        duration = '',
        start = '',
    },
    formFolder = {
        path = '',
        random = '',
        loop = '',
        nbElements = '',
        duration = '',
        start = '',
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
fillSavedConfigurations,
getPwd,
getSavedConfigurations,
isValid,
setPwd

-- --- --- --
--  Code   --
-- --- --- --

fillSavedConfigurations = function()
    savedConfigurations = {}
    for _, savedConfiguration in ipairs(_vlc_.readdir(string.format('%s/%s', pwd, savesFolder))) do
        if savedConfiguration ~= '.' and savedConfiguration ~= '..' and savedConfiguration ~= '.gitkeep' then
            table.insert(savedConfigurations, string.sub(savedConfiguration, 0, -5))
        end
    end

    table.sort(savedConfigurations)
end

getPwd = function()
    return pwd
end

getSavedConfigurations = function()
    return savedConfigurations
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
    fillSavedConfigurations = fillSavedConfigurations,
    getPwd = getPwd,
    getSavedConfigurations = getSavedConfigurations,
    isValid = isValid,
    itemTypes = itemTypes,
    keyTypes = keyTypes,
    rootKeys = rootKeys,
    savesFolder = savesFolder,
    setPwd = setPwd,
    wips = wips,
}