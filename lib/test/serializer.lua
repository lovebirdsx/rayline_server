require 'lib.common.table'

local Serializer = require 'lib.common.serializer'

local function test_ser_print()
    local t = {
        foo = 'hello',
	bar = {
	    just = 'do'
	},
	    [1] = 'world',
	    [2] = {1,2,3,4,5}
    }

    local s = Serializer.format(t)
    print(s)

    print(Serializer.format(1))
    print(Serializer.format('hello'))
    print(Serializer.format(nil))

    print(Serializer.format(
    {
        ['stages/puzzle/8/7.stg'] = 1
    }))
end

local function assert_equal(t1, t2)
    if not table.is_equal(t1, t2) then
        print(table.format(t1))
        print(table.format(t2))
        assert(false)
    end
end

local function test_parse()
    local function case(t)		
	local s = Serializer.format(t)
	print(s)
	local t2 = Serializer.parse(s)
	assert_equal(t, t2)
	print(Serializer.format(t2))
    end

    case {1, {1,2,3}, 3}
    case {1, 2, 3}
    case {foo = {1, {1,2,3}, 3}}
    case {foo = 'wahaha \''}
end

-- 解析多行字符串会失败
-- 原因在于loadstring不能正确处理该情况
local function test_parse_muti_linestr()
    local s = 
[['{
    ["stages/puzzle/1/1.stg"] = 40,
    ["stages/puzzle/1/2.stg"] = 19,
}'
]]

    local s1 = tostring(s)
    local t = Serializer.parse(s)
    print(table.tostring(t))
end

test_parse_muti_linestr()