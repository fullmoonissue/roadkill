-- --- --- --
-- Require --
-- --- --- --

local i18nModule = require('src/ui/i18n')

-- --- --- --
-- Header  --
-- --- --- --

-- Methods
local areKeysEquivalent, areReferencesEquivalent, deepCompare

-- --- --- --
--  Code   --
-- --- --- --

areKeysEquivalent = function(catalog)
    local locales = {}
    for localeReference, _ in pairs(catalog) do
        table.insert(locales, localeReference)
    end
    for index = 1, #locales - 1 do
        if not deepCompare(catalog[locales[index]], catalog[locales[index + 1]]) then
            return false
        end
    end

    return true
end

areReferencesEquivalent = function()
    local missingReferences = {}
    for _, properties in pairs(i18nModule.allTranslations) do
        i18nModule.subsituteReference(properties, properties['_references'], missingReferences)
    end

    return 0 == #missingReferences
end

deepCompare = function(t1, t2)
    local ty1 = type(t1)
    local ty2 = type(t2)

    if ty1 ~= ty2 then
        return false
    end

    if ty1 ~= 'table' and ty2 ~= 'table' then
        return true
    end

    for k1, v1 in pairs(t1) do
        local v2 = t2[k1]
        if v2 == nil or not deepCompare(v1, v2) then
            return false
        end
    end

    for k2, v2 in pairs(t2) do
        local v1 = t1[k2]
        if v1 == nil or not deepCompare(v1, v2) then
            return false
        end
    end

    return true
end

-- --- --- --
-- Exports --
-- --- --- --

return {
    areKeysEquivalent = areKeysEquivalent,
    areReferencesEquivalent = areReferencesEquivalent,
}