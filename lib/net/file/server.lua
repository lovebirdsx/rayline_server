require 'lib.common.table'

local class = require 'lib.common.class'
local TcpServer = require 'lib.net.tcpsv'
local File = require 'lib.common.file'

local function is_linux()
	return package.config:sub(1, 1) == '/'
end

local FileServer = class(function (self, port)
	self.server = TcpServer(port)
end)

local function gen_git_cmd(message)
	if is_linux() then
		return './commit.sh ' .. message
	else
		return 'commit ' .. message
	end
end

function FileServer:sync()
	local command = gen_git_cmd('\"robot sync\"')
	local ok, reason, code = os.execute(command)
	return {ok = ok, reason = reason, code = code}
end

function FileServer:callback(req)
	local cmd, params = req.cmd, req.params
	local fun = File[cmd]
	if fun then		
		local result = fun(unpack(params))
		print(string.format('cmd = %s params = %s resp = %s', cmd, table.tostring(params), table.tostring(result)))
		return result
	else
		if cmd == 'sync' then
			return self:sync()
		else
			print(string.format('unknown cmd %s', cmd))
		end
	end
end

function FileServer:start()
	self.server:set_callback(self.callback, self)
	self.server:start()
end

return FileServer
