FROM golang:1.13.4-alpine as build

RUN apk update && apk add curl git

RUN go get golang.org/x/sys/unix \
    && go get golang.org/x/crypto/ssh \
    && go get gopkg.in/ini.v1 \
    && go get github.com/julienschmidt/httprouter

COPY ./gw_stats_iox ./gw_stats_iox

RUN pwd 

RUN go build -o gw_server ./gw_stats_iox/gw_server.go

FROM alpine

COPY --from=build /go/gw_server .
COPY ./gw_stats_iox/package_config.ini .

EXPOSE 8080

CMD ["./gw_server"]



