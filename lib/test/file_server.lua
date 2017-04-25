package.path = 'env/ubuntu/?.lua;' .. package.path
package.cpath = 'env/ubuntu/?.so;' .. package.cpath

local FileServer = require 'lib.net.file.server'

local fs = FileServer(10000)

fs:start()
