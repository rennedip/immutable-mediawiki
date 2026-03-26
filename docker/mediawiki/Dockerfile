FROM dhi.io/python:3.14-debian13-dev AS build
COPY src /opt/build
WORKDIR /opt/build
RUN apt-get update && apt-get install -y git
RUN pip install -r requirements.txt
RUN python /opt/build/install.py

FROM dhi.io/httpd:2.4.66-debian13 AS release
COPY --from=build /opt/build/mediawiki /var/www/html