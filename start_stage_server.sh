#!/bin/sh

LUA=env/ubuntu/lua

git pull
$LUA lib/test/file_server.lua

