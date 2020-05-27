local lu = require('luaunit')
local utils = require('src/utils')

function testToList()
    local tbl = { ['file'] = 'file' }
    lu.assertEquals(
        { tbl },
        utils.toList(tbl)
    )
    lu.assertEquals(
        { tbl },
        utils.toList({ tbl })
    )
end

os.exit(lu.LuaUnit.run())