#!/bin/sh

LUA=env/ubuntu/lua
GIT=env/ubuntu/git

$GIT pull
$LUA lib/test/file_server.lua

