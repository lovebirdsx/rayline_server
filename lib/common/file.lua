local class = require 'lib.common.class'
local Serializer = require 'lib.common.serializer'
local import = require

local File = class(function (self)
end)

function File.write(path, str)
	local f, err = io.open(path, 'w+')
	if not f then
		print(string.format('write file %s failed: %s', path, err))
        return false
	end
	f:write(str)
	f:close()
    return true
end

function File.read(path)
    local f, err = io.open(path)
    if not f then
        print(string.format('read file %s failed: %s', path, err))
    else
	    local str = f:read('*all')
	    f:close()
	    return str
    end
end

function File.read_table(path)
	local s = File.read(path)
	if s then
		return Serializer.parse(s)
	else
		return {}
	end
end

function File.write_table(path, t)
	local s = Serializer.format(t)
	return File.write(path, s)
end

function File.copy(from, to)
    local content = File.read(from)
    File.write(to, content)
end

function File.cut(from, to)
	local content = File.read(from)
    File.write(to, content)
    File.remove(from)
end

function File.remove(path)
	local ret, reason = os.remove(path)
	if not ret then
		print(string.format('remove %s failed : %s', path, reason))
	end
	return ret
end

function File.exist(path)
	local lfs = import('lfs')
	return lfs.attributes(path, 'mode') == 'file'
end

function File.exist_dir(path)
	local lfs = import('lfs')
	return lfs.attributes(path, 'mode') == 'directory'
end

function File.list_file(path)
	local lfs = import('lfs')
	local result = {}
	local prefix = (path == '' or path == '.') and '' or path .. '/'
	for name in lfs.dir(path) do
		local file = prefix .. name
	    if lfs.attributes(file, 'mode') == 'file' then
	    	table.insert(result, file)
	    end
	end
	return result
end

function File.list_dir(path)
	local lfs = import('lfs')
	local result = {}
	local prefix = (path == '' or path == '.') and '' or path .. '/'
	for name in lfs.dir(path) do
		local file =  prefix .. name
	    if lfs.attributes(file, 'mode') == 'directory' and file:sub(1,1) ~= '.' then
	    	table.insert(result, file)
	    end
	end
	return result
end

function File.mkdir(dir)
	local lfs = import('lfs')
	local curr_dir = ''
	for sdir in string.gmatch(dir, '[^\\/]+') do
		curr_dir = curr_dir == '' and sdir or curr_dir .. '/' .. sdir
		lfs.mkdir(curr_dir)
	end
end

function File.save(path, content)
	-- make sure dir exsit
	local dir, file, ext = string.match(path, '(.-)([^\\/]-%.?([^%.\\/]*))$')
	File.mkdir(dir)

	return File.write(path, content)
end

function File.rmdir(dir)
	local lfs = import('lfs')
	lfs.rmdir(dir)
end

return File
