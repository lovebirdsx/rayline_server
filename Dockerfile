FROM ubuntu

# 拷贝项目文件
COPY ./*.* /home/lovebird/git_project/rayline_server/ 
COPY ./.git /home/lovebird/git_project/rayline_server/.git 
COPY ./lib /home/lovebird/git_project/rayline_server/lib
COPY ./stages /home/lovebird/git_project/rayline_server/stages

# 拷贝环境
COPY ./env /home/lovebird/git_project/rayline_server/env
