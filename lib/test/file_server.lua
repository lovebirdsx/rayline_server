io.stdout:setvbuf('no')

function os.capture(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end

local function is_linux()
    return package.config:sub(1, 1) == '/'
end

function os.system_type()
	if is_linux() then
		return os.capture('uname')
	else
		return 'windows'
	end
end

-- 确保ubuntu环境下可以直接从env中加载对应的lua模块
if os.system_type() == 'Linux' then
    package.path = 'env/ubuntu/?.lua;' .. package.path
    package.cpath = 'env/ubuntu/?.so;' .. package.cpath
end

local FileServer = require 'lib.net.file.server'

local fs = FileServer(10000)
fs:start()
