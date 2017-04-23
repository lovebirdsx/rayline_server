local class = require 'lib.common.class'

local Serializer = class()

function Serializer.parse(s)
	local t = type(s)
	if t == 'nil' or s == '' then
	    return nil
	elseif t == 'number' or t == 'string' or t == 'boolean' then
	    s = tostring(s)
	else
	    error('can not unserialize a ' .. t .. ' type.')
	end

	s = 'return ' .. s
	local func = loadstring(s)
	if func == nil then
	    return nil
	end
	return func()
end

local function is_array(t)
	local max = 0
	local count = 0
	for k, v in pairs(t) do
		if type(k) == 'number' then
			if k > max then max = k end
			count = count + 1
		else
			return false
		end
	end
	if max > count * 2 then
		return false
	end

	return true
end

function Serializer.format(obj, indent)
	indent = indent or '\t'

	-- key不支持table类型
	local function key_str(key)
		local type_k = type(key)
		assert(type_k ~= 'table')

		if type_k == 'string' then
			return '[' .. string.format('%q', key) .. ']'
		else
			return '[' .. tostring(key) .. ']'
		end
	end

	local function str(obj, n)
		local indent_str1 = string.rep(indent, n)
		local indent_str2 = string.rep(indent, n + 1)
		if type(obj) == 'table' then
			if is_array(obj) then
				local strs = {}
				for i = 1, #obj do
					local v = obj[i]
					local type_v = type(v)
					if type_v == 'table' then
						strs[i] = str(v, n + 1)
					elseif type_v == 'string' then
						strs[i] = string.format('%q', v)
					else
						strs[i] = tostring(v)
					end
				end
				return '{' .. table.concat(strs, ', ') ..'}'
			else
				local strs = {}

				local keys = table.get_keys(obj)

				-- 如果所有的key都是string类型,则排序,便于查看
				if table.is_string_array(keys) then
					table.sort(keys)
				end

				for _, k in ipairs(keys) do
					local v = obj[k]
					local type_v = type(v)
					if type_v == 'table' then
						strs[#strs + 1] = indent_str2 .. key_str(k) .. ' = ' .. str(v, n + 1)
					elseif type_v == 'string' then
						strs[#strs + 1] = indent_str2 .. key_str(k) .. ' = ' .. string.format('%q', v)
					else
						strs[#strs + 1] = indent_str2 .. key_str(k) .. ' = ' .. tostring(v)
					end
				end
				return '{\n' .. table.concat(strs, ',\n') .. indent_str1 .. '\n' .. indent_str1 .. '}'
			end
		else
			local type_v = type(obj)
			if type_v == 'string' then
				return indent_str1 .. string.format('%q', obj)
			else
				return indent_str1 .. tostring(obj)
			end
		end
	end

	return str(obj, 0)
end

return Serializer
