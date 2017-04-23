require 'lib.net.common'

local class = require 'lib.common.class'
local Serializer = require 'lib.common.serializer'
local import = require

local TcpClient = class(function (self, addr, port)
	self.socket = socket or import 'socket'
	self.addr = addr
	self.port = port
	self.connect_timeout = 3
end)

function TcpClient:update()
	if self.state == 'connect' then
		local read, write = self.socket.select(nil, {self.cl}, 0)
		if #write > 0 then
			self.state = 'read'
			self.cl:send(self.req_s:gsub('\n', '') .. '\n')
		else
			if os.clock() - self.connect_time > self.connect_timeout then
				self.state = 'finish'
				self.error_cb(self.data, 'connect timeout')
			end
		end
	elseif self.state == 'read' then
		local read, write = self.socket.select({self.cl}, nil, 0)
		if #read > 0 then
			local resp_s, err = self.cl:receive()
			if not resp_s then
				if err ~= 'timeout' then
					self.error_cb(self.data, err)
					self.state = 'error'
				end
			else
				local resp = Serializer.parse(resp_s)
				if not resp then
					self.error_cb(self.data, 'parse resp err')
					self.state = 'error'
				else
					self.cl:close()
					self.state = 'finish'
					self.cb(self.data, resp)
				end
			end
		end
	end
end

-- function cb(data, resp)
-- function error_cb(data, reason)
function TcpClient:do_req_async(req, cb, error_cb, data)
	self.cl = self.socket.tcp()
	self.cl:settimeout(0)
	local ok, err = self.cl:connect(self.addr, self.port)
	if not ok and err ~= 'timeout' then
		error_cb(data, err)
	else
		self.req_s = Serializer.format(req)
		self.state = 'connect'
		self.cb = cb
		self.error_cb = error_cb
		self.data = data
		self.connect_time = os.clock()
	end
end

function TcpClient:do_req(req)
	local cl = self.socket.tcp()
	cl:settimeout(3)
	local ok, reason = cl:connect(self.addr, self.port)
	if not ok then
		return false, 'connect failed: [' .. reason .. ']'
	end

	local ok, reason = send_data(cl, req)
	if not ok then
		return false, 'send failed: [' .. reason .. ']'
	end

	local resp, err = recv_data(cl)	
	cl:close()
	if resp then
		return true, resp
	else
		return false, 'recv failed: [' .. err .. ']'
	end
end

return TcpClient
