local window

function descriptor()
    return {
        title = 'Roadkill',
        version = '3.3.0',
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
    window = require('src/ui/window')
    window.formFileName()
end

function close()
    window.delete()
    vlc.deactivate()
end

function deactivate()
    vlc.msg.dbg('Thanks for using the Roadkill Extension !')
end