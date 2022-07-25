FROM alpine:3.15.5 as build

COPY . /tmp
WORKDIR /tmp
RUN [ -f *zip ] && unzip *zip || true
RUN [ -f *gz ] && gunzip *gz || true
RUN [ -f *tar ] && tar xf *tar || true
RUN mkdir /usr/dbvisit
RUN apk add libc6-compat strace
RUN chmod 755 ./install-control-v* && ./install-control-v* -batch -passphrase dummy-please-ignore

FROM alpine:3.15.5
MAINTAINER bartowl gitbub@bartowl.eu
COPY --from=build /usr/dbvisit /usr/dbvisit
COPY run_service.sh /usr/dbvisit/run_service.sh
RUN chmod 755 /usr/dbvisit/run_service.sh && apk --no-cache add libc6-compat strace
VOLUME /usr/dbvisit/persistent
EXPOSE 4433
EXPOSE 5533
CMD ["/usr/dbvisit/run_service.sh"]
