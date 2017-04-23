io.stdout:setvbuf('no')

local class = require 'lib.common.class'
local TcpClient = require 'lib.net.tcpcl'
local Serializer = require 'lib.common.serializer'

local EchoClient = class(function (self, addr, port)
	self.client = TcpClient(addr, port)
end)

function EchoClient:echo(req)
	return self.client:do_req(req)
end

function EchoClient:on_response(resp)
	self.resp = resp
	print(resp)
end

function EchoClient:on_error(err)
	self.err = err
	print(err)
end

function EchoClient:echo_async(req)
	self.resp = nil
	self.err = nil
	self.client:do_req_async(req, self.on_response, self.on_error, self)
end

function EchoClient:get_resp()
	return self.resp
end

function EchoClient:get_err()
	return self.err
end

function EchoClient:update()
	self.client:update()
end

local client = EchoClient('127.0.0.1', 10001)

for i = 1, 4 do
	local req = {
		foo = 'bar',
		hello = {1,2,3,4,5}
	}
	local ok, resp = client:echo(req)
	print(Serializer.format(resp))
end
