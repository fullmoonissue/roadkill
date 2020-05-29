local _vlc_ = require('src/vlc')
local lu = require('luaunit')

local time = 60
function testOptionMethod()
    lu.assertEquals(
        'start-time=60',
        _vlc_.optionMethod('start')(time)
    )
    lu.assertEquals(
        'stop-time=60',
        _vlc_.optionMethod('duration')(time)
    )
end

os.exit(lu.LuaUnit.run())