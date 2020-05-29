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
                ['duration'] = 'duration',
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
                ['start'] = 'start'
            },
        },
        messages
    )
    table.sort(messages)
    lu.assertEquals(
        {
            'Key "duration" must be a number in work-start',
            'Key "file" must be a string in work-before-all',
            'Key "folder" must be a string in work-items',
            'Key "loop" must be a number in work-items',
            'Key "nbElements" must be a number in work-items',
            'Key "random" must be a boolean in work-items',
            'Key "start" must be a number in work-after-all',
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
                ['duration'] = 1,
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
                ['start'] = 1
            },
        },
        messages
    )
    table.sort(messages)
    lu.assertEquals({}, messages)
end

os.exit(lu.LuaUnit.run())