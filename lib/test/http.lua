local http = require("socket.http")
local ltn12 = require("ltn12")

function deep_print(tbl)
	for i, v in pairs(tbl) do
		if type(v) == "table" then
			deep_print(v)
		else
			print(i, v)
		end
	end
end

function http_request(base_url, path, args)
	--http.request(base_url, path[, body])
	--http.request{
    --  base_url = string,
	--  url = string,
	--  [sink = LTN12 sink,]
	--  [method = string,]
	--  [headers = header-table,]
	--  [source = LTN12 source],
	--  [step = LTN12 pump step,]
	--  [proxy = string,]
	--  [redirect = boolean,]
	--  [create = function]
	--}
	--
	local resp, r = {}, {}
    args = args or {}
	if path then
		local params = ""
		if args.method == nil or args.method == "GET" then
			if args.params then
				for i, v in pairs(args.params) do
					params = params .. i .. "=" .. v .. "&"
				end
			end
		end
		params = string.sub(params, 1, - 2)
		local url = ""
		if params then url = base_url .. path .. "?" .. params
		else url = base_url .. path end
		client, code, headers, status = http.request {url = url, sink = ltn12.sink.table(resp),
		method = args.method or "GET", headers = args.headers, source = args.source,
		step = args.step, proxy = args.proxy, redirect = args.redirect, create = args.create}
		r['code'], r['headers'], r['status'], r['response'] = code, headers, status, resp
	else
		error("path is missing")
	end
	return r
end

function main()
    local base_url = "https://httpbin.org/" 
	local path = "/ip"
	print(path)
	deep_print(http_request(base_url, path))
	path = "/user-agent"
	print(path)
	deep_print(http_request(base_url, path))
end

main() 