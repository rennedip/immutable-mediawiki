ARG PHP_DIR= BUILD_DIR=/opt/build MEDIAWIKI_DIR=$BUILD_DIR/mediawiki WEBROOT_DIR=/var/www/html

FROM dhi.io/php:8.5.4-debian13 AS php

FROM dhi.io/python:3.14-debian13-dev AS build
ARG BUILD_DIR MEDIAWIKI_DIR
WORKDIR $BUILD_DIR
COPY src .
RUN apt-get update && apt-get install -y --no-install-recommends git=1:2.47.3-0+deb13u1
RUN pip install --no-cache-dir -r requirements.txt
RUN python install.py

FROM dhi.io/httpd:2.4.66-debian13 AS release
ARG MEDIAWIKI_DIR WEBROOT_DIR
COPY --from=build $MEDIAWIKI_DIR $WEBROOT_DIR
COPY --from=php /opt/php-8.5/bin /opt/php-8.5/bin
COPY --from=php /opt/php-8.5/lib /opt/php-8.5/lib
COPY --from=php /opt/php-8.5/etc /opt/php-8.5/etc