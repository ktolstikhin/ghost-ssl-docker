FROM alpine:latest

COPY bin/*.sh /usr/local/bin/

COPY crontab.txt .
RUN /usr/bin/crontab crontab.txt && rm crontab.txt

CMD ["/usr/sbin/crond", "-f"]

