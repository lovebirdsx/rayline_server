local FileServer = require 'lib.net.file.server'

local fs = FileServer(10000)

fs:start()
