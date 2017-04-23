local class = require 'lib.common.class'
local TcpClient = require 'lib.net.tcpcl'
local Serializer = require 'lib.common.serializer'

local FileClient = class(function (self, addr, port)
	self.tcp_cl = TcpClient(addr, port)
end)

function FileClient:call(cmd, ...)
	local req = {cmd = cmd, params = {...}}
	local ok, resp = self.tcp_cl:do_req(req)
	if ok then
		return true, resp
	else
		return false, resp
	end
end

function FileClient:list_file(path)
	return self:call('list_file', path)
end

function FileClient:list_dir(path)
	return self:call('list_dir', path)
end

function FileClient:save(path, content)
	return self:call('save', path, content)
end

function FileClient:write_table(path, t)
	return self:call('write_table', path, t)
end

function FileClient:remove(path)
	return self:call('remove', path)
end

function FileClient:read(path)
	return self:call('read', path)
end

function FileClient:write(path, content)
	return self:call('write', path, content)
end

function FileClient:read_table(path)
	local ok, s = self:read(path)
	if ok then
		local t = Serializer.parse(s)
		if t then return true, t end
	end

	return false, s
end

function FileClient:write_table(path, t)
	local s = Serializer.format(t)
	return self:write(path, s)
end

function FileClient:save_table(path, t)
	local s = Serializer.format(t)
	return self:save(path, s)
end

return FileClient
