FROM alpine:latest

COPY bin /usr/bin

COPY crontab.txt .
RUN /usr/bin/crontab crontab.txt

CMD ["/usr/sbin/crond", "-f"]

