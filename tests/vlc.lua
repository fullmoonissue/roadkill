local _vlc_ = require('src/vlc')
local lu = require('luaunit')

local time = 60
function testOptionMethod()
    lu.assertEquals(
        'start-time=60',
        _vlc_.optionMethod('startAt')(time)
    )
    lu.assertEquals(
        'stop-time=60',
        _vlc_.optionMethod('stopAt')(time)
    )
end

os.exit(lu.LuaUnit.run())