FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl /var/run/nginx

COPY conf/nginx.conf /etc/nginx/conf.d/default.conf
COPY tools/setup.sh /usr/local/bin/setup.sh

RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 443

CMD ["/usr/local/bin/setup.sh"]