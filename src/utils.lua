-- Little function to change a table{...} into table{table{...}} (to always use "for" to traverse what is returned)
local toList = function(tbl)
    if tbl[1] == nil then
        tbl = { tbl }
    end

    return tbl
end

-- Incremental seed, to be sure that the randomization will always be different (in addition to the os.time())
local seed = 0

-- Shuffle a table
-- @see https://gist.github.com/Uradamus/10323382
local function shuffle(tbl)
    seed = seed + 1
    math.randomseed(os.time() + seed)
    for index = #tbl, 2, -1 do
        local random = math.random(index)
        tbl[index], tbl[random] = tbl[random], tbl[index]
    end

    return tbl
end

return {
    toList = toList,
    shuffle = shuffle
}