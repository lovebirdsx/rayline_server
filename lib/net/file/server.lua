require 'lib.common.table'

local class = require 'lib.common.class'
local TcpServer = require 'lib.net.tcpsv'
local File = require 'lib.common.file'

local FileServer = class(function (self, port)
	self.server = TcpServer(port)
end)

function FileServer:callback(req)
	local cmd, params = req.cmd, req.params
	local fun = File[cmd]
	if fun then
		local result = fun(unpack(params))
		print(string.format('cmd = %s params = %s resp = %s', cmd, table.tostring(params), table.tostring(result)))
		return result
	else
		print(string.format('unknown cmd %s', cmd))
	end
end

function FileServer:start()
	self.server:set_callback(self.callback, self)
	self.server:start()
end

return FileServer
