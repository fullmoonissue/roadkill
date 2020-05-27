local lu = require('luaunit')
local vlcOptions = require('src/vlc/options')

local time = 60
function testOptionMethod()
    lu.assertEquals(
        'start-time=60',
        vlcOptions.optionMethod('start')(time)
    )
    lu.assertEquals(
        'stop-time=60',
        vlcOptions.optionMethod('duration')(time)
    )
end

os.exit(lu.LuaUnit.run())