# Base image
FROM centos:7

MAINTAINER "jeeinn" <xieyw@esound.cn>
ENV SRC_PACKAGE_PATH /usr/local/src
# Update
RUN yum -y update
RUN yum -y install wget

# ======== Depends ========
# Nginx
RUN yum -y install gcc gcc-c++ glibc make automake autoconf libtool bison zlib-devel libxslt-devel libcurl-devel
RUN yum -y install gd gd-devel pcre pcre-devel openssl openssl-devel libxml2 libxml2-devel
# PHP
RUN yum -y install epel-release
RUN yum -y install sqlite-devel
RUN yum -y install curl-devel libjpeg-devel libpng-devel freetype-devel
RUN yum -y install libicu-devel
# Copy package to /usr/local/src
ADD docker_src_package/freetype-2.9.tar.gz ${SRC_PACKAGE_PATH}
ADD docker_src_package/libiconv-1.16.tar.gz ${SRC_PACKAGE_PATH}
ADD docker_src_package/nginx-1.19.0.tar.gz ${SRC_PACKAGE_PATH}
ADD docker_src_package/oniguruma-6.9.5_rev1.tar.gz ${SRC_PACKAGE_PATH}
ADD docker_src_package/php-7.4.6.tar.gz ${SRC_PACKAGE_PATH}
ADD docker_src_package/redis-5.2.2.tgz ${SRC_PACKAGE_PATH}
# php7.4 oniguruma
WORKDIR ${SRC_PACKAGE_PATH}/oniguruma-6.9.5_rev1
RUN ./autogen.sh
RUN ./configure --prefix=/usr --libdir=/lib64
RUN bash -c "make && make install"
# iconv
WORKDIR ${SRC_PACKAGE_PATH}/libiconv-1.16
RUN ./configure --prefix=/usr/local/iconv
RUN bash -c "make && make install"
# freetype
WORKDIR ${SRC_PACKAGE_PATH}/freetype-2.9
RUN ./configure --prefix=/usr/local/freetype
RUN bash -c "make && make install"
# centos7 libzip upgrade use rpm
RUN yum -y remove libzip libzip-devel
COPY docker_src_package/libzip5-1.7.0-1.el7.remi.x86_64.rpm ${SRC_PACKAGE_PATH}
COPY docker_src_package/libzip5-devel-1.7.0-1.el7.remi.x86_64.rpm ${SRC_PACKAGE_PATH}
WORKDIR ${SRC_PACKAGE_PATH}
RUN yum -y install libzip5-1.7.0-1.el7.remi.x86_64.rpm
RUN yum -y install libzip5-devel-1.7.0-1.el7.remi.x86_64.rpm

# ======== Make ========
RUN useradd -M -s /sbin/nologin www
# Nginx
WORKDIR ${SRC_PACKAGE_PATH}/nginx-1.19.0
RUN bash -c "./configure --user=www --group=www --prefix=/usr/local/nginx \
--sbin-path=/usr/local/nginx/sbin/nginx \
--with-file-aio \
--with-http_ssl_module \
--with-http_realip_module \
--with-http_addition_module \
--with-http_xslt_module \
--with-http_image_filter_module \
--with-http_sub_module \
--with-http_dav_module \
--with-http_flv_module \
--with-http_mp4_module \
--with-http_gunzip_module \
--with-http_gzip_static_module \
--with-http_auth_request_module \
--with-http_random_index_module \
--with-http_secure_link_module \
--with-http_degradation_module \
--with-http_stub_status_module"
RUN bash -c "make && make install"
EXPOSE 80 443
# PHP
WORKDIR ${SRC_PACKAGE_PATH}/php-7.4.6
RUN bash -c "./configure --prefix=/usr/local/php7 \
--with-config-file-path=/usr/local/php7/etc \
--with-config-file-scan-dir=/usr/local/php7/conf.d \
--enable-fpm --with-fpm-user=www --with-fpm-group=www \
--enable-mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd \
--enable-cli \
--enable-mbstring \
--enable-gd \
--enable-xml \
--enable-mbregex \
--enable-opcache \
--enable-soap \
--enable-sockets  \
--enable-intl \
--enable-pcntl \
--enable-bcmath \
--enable-shmop \
--enable-ftp \
--enable-inline-optimization \
--enable-sysvsem \
--enable-sysvshm \
--with-openssl \
--with-curl \
--with-zip \
--with-zlib \
--with-xmlrpc \
--with-iconv=/usr/local/iconv \
--with-freetype=/usr/local/freetype \
--with-jpeg \
--without-pear \
--disable-phar"
RUN bash -c "make && make install"
# PHPRedis Extension
WORKDIR ${SRC_PACKAGE_PATH}/redis-5.2.2
RUN /usr/local/php7/bin/phpize
RUN ./configure --with-php-config=/usr/local/php7/bin/php-config
RUN bash -c "make && make install"
EXPOSE 9000

# ======== Conf ========
# Nginx (Note:access.log need log dir exist)
RUN mkdir /usr/local/nginx/conf/conf.d
RUN mkdir /usr/local/nginx/conf/vhost
COPY docker_nginx/ /usr/local/nginx/conf/
# PHP
COPY docker_php/ /usr/local/php7/etc/

# ======== Cleanup ========
RUN rm -rf ${SRC_PACKAGE_PATH}/*
RUN yum clean all

# ======== Copy Project ========
ADD . /mnt/default
RUN chmod +x /mnt/default/docker-entrypoint.sh
ENTRYPOINT ["/mnt/default/docker-entrypoint.sh"]