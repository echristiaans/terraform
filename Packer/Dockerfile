FROM nginx
RUN rm /etc/nginx/conf.d/default.conf
#RUN rm /etc/nginx/conf.d/examplessl.conf
RUN mkdir /usr/share/nginx/html/src
COPY kickstart.cfg /usr/share/nginx/html/src
COPY nginx.conf /etc/nginx
