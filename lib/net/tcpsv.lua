require 'lib.net.common'
require 'lib.common.table'

local class = require 'lib.common.class'
local Serializer = require 'lib.common.serializer'
local import = require

local TcpServer = class(function (self, port)
	self.port = port
	self.timeout = 3
	self.socket = socket or import 'socket'
end)

function TcpServer:set_callback(cb, data)
	self.callback = cb
	self.data = data
end

function TcpServer:set_timeout(timeout)
	self.timeout = timeout
end

function TcpServer:_access_one_req(cl)
	cl:settimeout(self.timeout)
	local ip, port = cl:getpeername()
	if not ip then
		-- getpeername有可能会返回nil
		cl:close()
		print(string.format('TcpServer._access_on_req: getpeername failed'))
		return
	else
		print(string.format('connected %s:%g', ip, port))
	end

	local req, err = recv_data(cl)
	if req then
		local resp = self.callback(self.data, req)
		if resp then
			send_data(cl, resp)
		else
			print(string.format('access request failed!\nfrom %s:%g\n%s', ip, port, table.tostring(req)))
		end
	else
		print(string.format('error: [%s] when receive from %s:%g', err, ip, port))
	end

	-- 确保数据能够正常发送完毕
	cl:setoption('linger', {on=true, timeout=20})
	cl:close()
end

function TcpServer:start()
	local server = assert(self.socket.bind('*', self.port))
	local ip, port = server:getsockname()
	print(string.format('tcp server start at %s:%g', ip, port))

	server:settimeout(self.timeout)
	while true do
		local cl, err, reason = server:accept()
		if cl then
			self:_access_one_req(cl)
		else
			if not err then
				print('accept err: [' .. reason .. ']')
			end
		end		
	end
end

return TcpServer
