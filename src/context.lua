local utils = require('src/utils')

-- Keys (and associated type) available in root keys
local keyTypes = {
    file = 'string',
    duration = 'number',
    start = 'number',
    folder = 'string',
    random = 'boolean',
    loop = 'number',
    nbElements = 'number',
    url = 'string',
}

-- Root keys to put into the configuration table
local rootKeys = {
    'work-before-all',
    'work-start',
    'work-items',
    'work-end',
    'work-after-all'
}

return {
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
    end,
    keyTypes = keyTypes,
    pwd = '', -- unknown at the beginning
    rootKeys = rootKeys,
    savesFolder = 'saves',
    -- Texts which are displayed in the playlist
    texts = {
        ['work-before-all'] = 'Before Starting !',
        ['work-start'] = 'Let\'s Go !',
        ['work-items'] = 'Work !',
        ['work-end'] = 'Take a break !',
        ['work-after-all'] = 'Finish !',
    },
    when = {
        'Before all exercices',
        'Before any exercice',
        'Exercices',
        'After any exercice',
        'After all exercices',
    },
    type = {
        'Folder',
        'File',
        'Url',
    },
}