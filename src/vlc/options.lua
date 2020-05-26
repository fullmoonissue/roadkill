-- VLC options
local options = {
    -- VLC option to stop the stream at a certain number of seconds
    {
        option = 'duration',
        method = function(duration)
            return string.format('stop-time=%d', duration)
        end
    },
    -- VLC option to start the stream at a certain number of seconds
    {
        option = 'start',
        method = function(startAt)
            return string.format('start-time=%d', startAt)
        end
    }
}

local optionMethod = function(option)
    for _, properties in ipairs(options) do
        if properties['option'] == option then
            return properties['method']
        end
    end
end

return {
    options = options,
    optionMethod = optionMethod,
}