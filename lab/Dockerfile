FROM nginx
COPY files/ /usr/share/nginx/html
COPY nginx/ /etc/nginx
ADD entry.bash /opt/entry.bash
RUN export HTTPS_PROXY="http://10.232.233.70:8080/"  \
    && export HTTP_PROXY="http://10.232.233.70:8080/"  \
    && export http_proxy="http://10.232.233.70:8080/"  \
    && export https_proxy="http://10.232.233.70:8080/"  \
    && apt update  \
    && apt install vim -y \
    && unset HTTPS_PROXY; unset HTTP_PROXY; unset https_proxy ; unset http_proxy
