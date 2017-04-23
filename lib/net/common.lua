local Serializer = require 'lib.common.serializer'

local EOF_DATA = '######eof_data#####'

function send_data(socket, data)
	local f_data = Serializer.format(data)
	local send_data = f_data .. '\n' .. EOF_DATA .. '\n'
	local send_len = string.len(send_data)
	local index, err_msg = socket:send(send_data, 1, send_len)
	if index == send_len then
		return true
	else
		return false, err_msg
	end
end

function recv_data(socket)
	local lines = {}
	local data, err
	while not err do
		line, err = socket:receive()
		if line then
			if line ~= EOF_DATA then
				table.insert(lines, line)
			else
				break
			end
		else
		end
	end

	if not err then
		local f_data = table.concat(lines, '\n')
		local data = Serializer.parse(f_data)		
		if data then
			return data
		else
			return data, 'parse failed: ' .. f_data
		end
	else
		return nil, err
	end
end
