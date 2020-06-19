# FROM golang:1.13-alpine AS build-env
# WORKDIR /go/src/app
# RUN  /bin/sed -i 's,http://dl-cdn.alpinelinux.org,https://mirrors.aliyun.com,g' /etc/apk/repositories

# ENV  GO111MODULE=on
# ENV  GOPROXY=https://goproxy.cn
# COPY . .
# RUN apk update && apk add git \
#     && go build -o rest-api

FROM alpine:latest
WORKDIR /app
RUN  /bin/sed -i 's,http://dl-cdn.alpinelinux.org,https://mirrors.aliyun.com,g' /etc/apk/repositories
RUN apk update && apk add ca-certificates && apk add  --no-cache tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone && rm -rf /var/cache/apk/*
COPY --from=ochinchina/supervisord:latest /usr/local/bin/supervisord /usr/local/bin/supervisord
# COPY --from=build-env /go/src/app/rest-api /app/rest-api
COPY supervisor.conf /etc/supervisord.conf
EXPOSE 8080
CMD ["/usr/local/bin/supervisord"]