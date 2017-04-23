require 'lib.common.table'

local File = require 'lib.common.file'

local test = {}

function test_all()
	for name, case in pairs(test) do
		print('test ' .. name)
		case()
	end
end

function test.list_file()
	File.save('a/1.txt', 'hello')
	File.save('a/2.txt', 'hello')

	local r = File.list_file('a')
	assert(table.find(r, 'a/1.txt') > 0)
	assert(table.find(r, 'a/2.txt') > 0)

	File.remove('a/1.txt')
	File.remove('a/2.txt')
	File.rmdir('a')
end

function test.list_dir()
	File.mkdir('a')
	File.mkdir('b')

	local r = File.list_dir('.')
	assert(table.find(r, 'a') > 0)
	assert(table.find(r, 'b') > 0)

	File.rmdir('a')
	File.rmdir('b')
end

function test.save()
	File.save('a/b/c.txt', 'hello')
	File.remove('a/b/c.txt')
	File.rmdir('a/b')
	File.rmdir('a')
end

test_all()
