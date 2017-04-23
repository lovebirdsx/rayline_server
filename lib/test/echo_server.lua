local Serializer = require 'lib.common.serializer'

io.stdout:setvbuf('no')

local TcpServer = require 'lib.net.tcpsv'
local class = require 'lib.common.class'

local EchoServer = class(function (self, port)
	self.server = TcpServer(port)
end)

function EchoServer:callback(req)
	print(Serializer.format(req))
	return req
end

function EchoServer:start()
	self.server:set_callback(self.callback, self)
	self.server:set_timeout(1)
	self.server:start()
end

local server = EchoServer(10001)
server:start()
