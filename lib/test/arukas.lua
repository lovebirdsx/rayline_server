local Arukas = require('lib.net.arukas')

local test = {}

function test_all()
	for name, case in pairs(test) do
		print('test ' .. name)
		case()
	end
end

function test.reserve()
    local token = '7439f664-4a1e-43b5-a682-4bf60007cdca'
    local secret = 'OogDLwth8zoqqePl9YMsMPEjysR6jQp1XAlPrr8z3oXcQcyHxzbSls4tPKKQs0Sa'

    Arukas.set_token_secret(token, secret)
    local ip, port = Arukas.resolve('lovebird.arukascloud.io', 10000)
    print(ip, port)
end

test_all()