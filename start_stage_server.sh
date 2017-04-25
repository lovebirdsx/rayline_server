#!/bin/sh

LUA_EXE=/usr/bin/lua
ENV=env/ubuntu

# 找不到配置,则全部拷贝
if [! -d "$LUA_EXE"]; then 
    cp -avx $ENV/bin/* /usr/local/bin
    cp -avx $ENV/lib/* /usr/local/lib
    cp -avx $ENV/share/* /usr/local/share
fi 

lua lib/test/file_server.lua
