FROM debian:buster
COPY ./srcs/start.sh .
COPY ./srcs/toto.conf ./tmp/
COPY ./srcs/config.inc.php ./tmp/
COPY ./srcs/index.html ./tmp/
CMD bash start.sh
