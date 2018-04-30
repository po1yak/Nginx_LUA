FROM ubuntu:16.04
 
MAINTAINER Sergey Polyakov s.v.polyakov@gmail.com
#----- 
RUN apt-get -y update

RUN apt-get -y install wget make  gcc libpcre3 libpcre3-dev libghc-zlib-dev git unzip

RUN wget 'http://luajit.org/download/LuaJIT-2.0.5.tar.gz'
RUN tar -xzvf LuaJIT-2.0.5.tar.gz
RUN rm LuaJIT-2.0.5.tar.gz -rf
RUN cd LuaJIT-2.0.5 && \
    make && \
    make install && \
    cd .. && rm /LuaJIT-2.0.5 -rf

RUN wget 'https://github.com/simplresty/ngx_devel_kit/archive/v0.3.1rc1.tar.gz'
RUN tar -xzvf v0.3.1rc1.tar.gz
RUN rm v0.3.1rc1.tar.gz -rf

RUN wget 'https://github.com/openresty/lua-nginx-module/archive/v0.10.12rc2.tar.gz'
RUN tar -xzvf v0.10.12rc2.tar.gz
RUN rm v0.10.12rc2.tar.gz -rf

RUN wget 'http://nginx.org/download/nginx-1.13.8.tar.gz'
RUN tar -xzvf nginx-1.13.8.tar.gz
RUN rm nginx-1.13.8.tar.gz -rf
ENV LUAJIT_LIB=/usr/local/lib/libluajit-5.1.so
ENV LUAJIT_INC=/usr/local/include/luajit-2.0/ 
ENV LD_LIBRARY_PATH=/usr/local/lib/:$LD_LIBRARY_PATH
RUN cd nginx-1.13.8 && \
    ./configure --prefix=/opt/nginx \
                --with-ld-opt="-Wl,-rpath,/usr/local/lib/libluajit-5.1.so" \
                --add-module=/ngx_devel_kit-0.3.1rc1 \
                --add-module=/lua-nginx-module-0.10.12rc2 && \
    make -j2 && \
    make install && \
    cd .. && rm /nginx-1.13.8 -rf && rm /ngx_devel_kit-0.3.1rc1 -rf && rm /lua-nginx-module-0.10.12rc2 -rf

RUN wget --no-check-certificate -O master.zip https://github.com/tmppolyak/Nginx_LUA/archive/master.zip
RUN unzip master.zip && rm /master.zip  && \ 
    mv /Nginx_LUA-master/nginx.conf /opt/nginx/conf/ && \
    mv /Nginx_LUA-master/index.lua /opt/nginx/html/ && \
    rm /Nginx_LUA-master -rf

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["/opt/nginx/sbin/nginx", "-g", "daemon off;"]
