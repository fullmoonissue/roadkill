local roadkill

function descriptor()
    return {
        title = 'Roadkill',
        version = '3.1.0',
        author = 'fullmoonissue',
        url = 'http://www.fullmoonissue.net/',
        shortdesc = 'Roadkill, VLC Extension';
        description = 'Roadkill is a VLC Extension to setup work / break sequences.'
    }
end

function activate()
    -- Add the roadkill folder as a known path to be able to require()
    local pwd = debug.getinfo(1).source:match('@?(.*/)') .. 'roadkill'
    package.path = package.path .. ';' .. pwd .. '/?.lua'

    require('src/context').setPwd(pwd)
    roadkill = require('src/ui/roadkill')
    roadkill.windowFormFileName()
end

function close()
    roadkill.quit()
end

function deactivate()
    vlc.msg.dbg('Thanks for using the Roadkill Extension !')
end