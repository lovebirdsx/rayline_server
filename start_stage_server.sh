#!/bin/sh

LUA=env/ubuntu/lua

git checkout .
git pull
$LUA lib/test/file_server.lua

