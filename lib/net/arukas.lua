local M = {}

local _token
local _secret

local function is_linux()
	return package.config:sub(1, 1) == '/'
end 

function M.set_token_secret(token, secret)
	_token = token
	_secret = secret
end

function M.resolve(endpoint, port)
	local params = {_token, _secret, endpoint, port}
	local params_str = table.concat(params, " ")

	local command
	if is_linux() then
		command = string.format('./endpoint.sh %s', params_str)
	else
		command = string.format('\"C:\\Program Files\\Git\\usr\\bin\\sh.exe\" endpoint.sh %s', params_str)
	end

	local handle = io.popen(command)
	local result = handle:read("*a")
	handle:close()
	
	local ip, port = string.match(result, '([%w.]+) (%w+)')
	return ip, tonumber(port)
end 

return M
