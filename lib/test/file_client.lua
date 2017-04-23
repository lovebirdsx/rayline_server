local FileClient = require 'lib.net.file.client'
local Config = require 'lib.config.base'

local test = {}

function test_all()
	for name, case in pairs(test) do
		print('test ' .. name)
		case()
	end
end

function test.list_file()
	local cl = FileClient('127.0.0.1', 10000)
	local ok, result = cl:list_file('.')
	if ok then
		for _, file in ipairs(result) do
			print(file)
		end
	else
		print('err: ', result)
	end
end

function test.list_dir()
	local cl = FileClient('127.0.0.1', 10000)
	local ok, result = cl:list_dir('.')
	if ok then
		for _, file in ipairs(result) do
			print(file)
		end
	else
		print('err: ', result)
	end
end

function test.save_file()
	local cl = FileClient('127.0.0.1', 10000)
	local ok, result = cl:save('hello.txt', 'hello world')
	print(ok, result)
	cl:remove('hello.txt')
	print(ok, result)
end

test_all()
