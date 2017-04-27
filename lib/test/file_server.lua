io.stdout:setvbuf('no') 

local function is_linux()
    return package.config:sub(1, 1) == '/' 
end

-- 确保ubuntu环境下可以直接从env中加载对应的lua模块
if is_linux() then
    package.path = 'env/ubuntu/?.lua;' .. package.path
    package.cpath = 'env/ubuntu/?.so;' .. package.cpath
end

local FileServer = require 'lib.net.file.server'

local fs = FileServer(10000)
fs:start()
