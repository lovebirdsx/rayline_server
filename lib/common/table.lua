function table.size(t)
    local r = 0
    for k, v in pairs(t) do
        r = r + 1
    end
    return r
end

function table.copy(t)
    local r = {}
    for k,v in pairs(t) do
        r[k] = v
    end
    return r
end

function table.get_keys(t)
    local keys = {}
    for k, _ in pairs(t) do
        table.insert(keys, k)
    end
    return keys
end

function table.array_to_kv(t, key)
    local r = {}
    for i, v in ipairs(t) do
        r[v[key]] = v
    end
    return r
end

function table.find(t, e)
    for i, v in ipairs(t) do
        if v == e then return i end
    end
    return 0
end

function table.is_array(t)
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

function table.tostring(t, indent)
    indent = indent or '  '
    local function str(t, n)
        local indent_str1 = string.rep(indent, n)
        local indent_str2 = string.rep(indent, n + 1)
        if type(t) == 'table' then
            if table.is_array(t) then
                local strs = {}
                for i = 1, #t do
                    local v = t[i]
                    if type(v) == 'table' then
                        strs[i] = str(v, n + 1)
                    else
                        strs[i] = tostring(v)
                    end
                end
                return '{' .. table.concat(strs, ', ') ..'}'
            else
                local strs = {}
                for k, v in pairs(t) do
                    if type(v) == 'table' then
                        strs[#strs + 1] = indent_str2 .. tostring(k) .. ' = ' .. str(v, n + 1)
                    else
                        strs[#strs + 1] = indent_str2 .. tostring(k) .. ' = ' .. tostring(v)
                    end
                end
                return '{\n' .. table.concat(strs, ',\n') .. indent_str1 .. '\n' .. indent_str1 .. '}'
            end
        else
            return indent_str1 .. tostring(t)
        end
    end

    return str(t, 0)
end

function table.is_equal(t1, t2)
    for k, v in pairs(t1) do
        local v2 = t2[k]        
        if type(v2) == 'table' then
            if not table.is_equal(v, v2) then
                return false
            end
        else
            if v ~= v2 then
                return false
            end
        end
    end

    for k, v in pairs(t2) do
        if not t1[k] then
            return false
        end
    end

    return true
end

function table.is_string_array(array)
    for _, e in ipairs(array) do
        if type(e) ~= 'string' then
            return false
        end
    end
    
    return true
end