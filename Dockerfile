FROM ubuntu
COPY ./?*.* ./lua /home/lovebird/git_project/rayline_server/ 
COPY ./lib /home/lovebird/git_project/rayline_server/lib
COPY ./socket /home/lovebird/git_project/rayline_server/socket
COPY ./stages /home/lovebird/git_project/rayline_server/stages

