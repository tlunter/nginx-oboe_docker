FROM ubuntu:14.04

RUN apt-get -y update
RUN apt-get -y install build-essential zlib1g-dev libssl-dev wget libpcre3 libpcre3-dev

# Add tracelytics stuff
ADD appneta.list /etc/apt/sources.list.d/appneta.list
RUN /bin/sh -c "wget -qO- https://apt.appneta.com/appneta-apt-key.pub | apt-key add -"
RUN apt-get -y update
RUN apt-get -y install liboboe0 liboboe-dev

# Download nginx 1.7.9
WORKDIR /tmp/
RUN wget -q -O nginx-1.7.9.tar.gz http://nginx.org/download/nginx-1.7.9.tar.gz
RUN tar xvf nginx-1.7.9.tar.gz

# Download nginx-oboe
RUN wget -q -O nginx-oboe.tar.gz https://files.tracelytics.com/src/nginx_oboe-latest.x86_64.tar.gz
RUN tar xvf nginx-oboe.tar.gz

# Install nginx 1.7.9
WORKDIR /tmp/nginx-1.7.9/
RUN ./configure \
    --prefix=/opt/nginx \
    --conf-path=/opt/nginx/nginx.conf \
    --sbin-path=/opt/nginx/bin/nginx \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/lock/nginx.lock \
    --user=http \
    --group=http \
    --http-log-path=/var/log/nginx/access.log \
    --error-log-path=stderr \
    --http-client-body-temp-path=/var/lib/nginx/client-body \
    --http-proxy-temp-path=/var/lib/nginx/proxy \
    --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
    --http-scgi-temp-path=/var/lib/nginx/scgi \
    --http-uwsgi-temp-path=/var/lib/nginx/uwsgi \
    --with-imap \
    --with-imap_ssl_module \
    --with-ipv6 \
    --with-pcre-jit \
    --with-file-aio \
    --with-http_dav_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_realip_module \
    --with-http_spdy_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_addition_module \
    --with-http_degradation_module \
    --with-http_flv_module \
    --with-http_mp4_module \
    --with-http_secure_link_module \
    --with-http_sub_module \
    --add-module=../nginx_oboe
RUN make -j 4
RUN make -j 4 install

ADD nginx.conf /opt/nginx/nginx.conf
USER root
CMD /opt/nginx/bin/nginx -c /opt/nginx/nginx.conf -g "daemon off;"
