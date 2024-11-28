FROM nginx
RUN /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' >/etc/timezone \
RUN rm -rf /usr/share/nginx/html/*
RUN mkdir /usr/share/nginx/dist
COPY ./dist /usr/share/nginx/dist
RUN mv /usr/share/nginx/dist/* /usr/share/nginx/html \
    && rm -rf /usr/share/nginx/dist
EXPOSE 80