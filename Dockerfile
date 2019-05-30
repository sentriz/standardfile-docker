FROM golang:1.12-alpine as builder
ENV SF_VERSION=0.4.2
RUN \
    apk add git build-base && \
    wget http://github.com/tectiv3/standardfile/archive/v${SF_VERSION}.zip -O /tmp/zip && \
    unzip /tmp/zip -d /tmp && \
    mkdir /lib64 && \
    ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2 && \
    cd /tmp/standardfile-${SF_VERSION} && \
    GO111MODULE=on GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -a -o /tmp/standardfile .

FROM alpine:3.9
COPY --from=builder /tmp/standardfile /
EXPOSE 8888
VOLUME /stdfile
WORKDIR /stdfile
ENTRYPOINT ["/standardfile"] 
CMD ["-cors", "-foreground"]
