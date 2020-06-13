local context = require('src/context')
local lu = require('luaunit')

local messages
function testIsValid()
    messages = {}
    context.isValid(
        {
            ['work-before-all'] = {
                ['file'] = 42
            },
            ['work-start'] = {
                ['stopAt'] = 'stopAt',
            },
            ['work-items'] = {
                ['folder'] = 42,
                ['random'] = 42,
                ['loop'] = 'loop',
                ['nbElements'] = 'nbElements',
            },
            ['work-end'] = {
                ['url'] = 42
            },
            ['work-after-all'] = {
                ['startAt'] = 'startAt'
            },
        },
        messages
    )
    table.sort(messages)
    lu.assertEquals(
        {
            'Key "file" must be a string in work-before-all',
            'Key "folder" must be a string in work-items',
            'Key "loop" must be a number in work-items',
            'Key "nbElements" must be a number in work-items',
            'Key "random" must be a boolean in work-items',
            'Key "startAt" must be a number in work-after-all',
            'Key "stopAt" must be a number in work-start',
            'Key "url" must be a string in work-end'
        },
        messages
    )

    messages = {}
    context.isValid(
        {
            ['work-before-all'] = {
                ['file'] = 'file'
            },
            ['work-start'] = {
                ['stopAt'] = 1,
            },
            ['work-items'] = {
                ['folder'] = 'folder',
                ['random'] = true,
                ['loop'] = 1,
                ['nbElements'] = 1,
            },
            ['work-end'] = {
                ['url'] = 'url'
            },
            ['work-after-all'] = {
                ['startAt'] = 1
            },
        },
        messages
    )
    table.sort(messages)
    lu.assertEquals({}, messages)
end

os.exit(lu.LuaUnit.run())