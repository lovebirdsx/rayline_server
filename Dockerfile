FROM ubuntu

# 拷贝系统文件
COPY ./env/ubuntu/ssh \
     ./env/ubuntu/git \
     /usr/bin/

COPY ./env/ubuntu/libcrypto.so.1.0.0 /lib/x86_64-linux-gnu/

COPY ./env/ubuntu/libgssapi_krb5.so.2 \
     ./env/ubuntu/libkrb5.so.3 \
     ./env/ubuntu/libk5crypto.so.3 \
     ./env/ubuntu/libkrb5support.so.0 \
     ./env/ubuntu/libkeyutils.so.1 \
     /usr/lib/x86_64-linux-gnu/

# 拷贝git秘钥
COPY ./env/ubuntu/.ssh /root/.ssh

# 拷贝项目文件
COPY ./?*.* .gitignore .vscode /rayline_server/ 
COPY ./.git /rayline_server/.git 
COPY ./lib /rayline_server/lib
COPY ./stages /rayline_server/stages

# 拷贝环境
COPY ./env /rayline_server/env
