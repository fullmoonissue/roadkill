-- --- --- --
-- Header  --
-- --- --- --

-- Fields
local seed = 0 -- Incremental seed, to be sure that the randomization will always be different

-- Methods
local
createFile,
deleteFile,
toList, -- Function to change a table{...} into table{table{...}} (to always use "for" to traverse what is returned)
shuffle -- Shuffle a table, @see https://gist.github.com/Uradamus/10323382

-- --- --- --
--  Code   --
-- --- --- --

createFile = function(path, content)
    local file = vlc.io.open(path, 'w')
    file:write(content)
    file:close()
end

deleteFile = function(path)
    vlc.io.unlink(path)
end

toList = function(tbl)
    if tbl[1] == nil then
        tbl = { tbl }
    end

    return tbl
end

shuffle = function(tbl)
    seed = seed + 1
    math.randomseed(os.time() + seed)
    for index = #tbl, 2, -1 do
        local random = math.random(index)
        tbl[index], tbl[random] = tbl[random], tbl[index]
    end

    return tbl
end

-- --- --- --
-- Exports --
-- --- --- --

return {
    createFile = createFile,
    deleteFile = deleteFile,
    toList = toList,
    shuffle = shuffle
}