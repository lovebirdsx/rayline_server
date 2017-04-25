function is_linux()
    return package.config:sub(1, 1) == '/' 
end

if is_linux() then
    package.path = 'env/ubuntu/?.lua;' .. package.path
    package.cpath = 'env/ubuntu/?.so;' .. package.cpath
end

local FileServer = require 'lib.net.file.server'

local HOOM_CMDS = {
    ['save'] = true,
    ['write_table'] = true,
    ['write'] = true,
    ['save_table'] = true,
}

function gen_git_cmd(message)
    if is_linux() then
        return './commit ' .. message
    else
        return 'commit ' .. message
    end
end

function hook(cmd, ...)
    if HOOM_CMDS[cmd] then
        local command = gen_git_cmd(string.format('\"robot %s\"', cmd)) 
        local handle = io.popen(command)
        local result = handle:read("*a")
        handle:close()        
        print(result)
    end
end

local fs = FileServer(10000)
fs:set_hook(hook)
fs:start()
