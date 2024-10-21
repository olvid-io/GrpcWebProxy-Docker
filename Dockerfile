FROM golang:1.23.2-alpine AS builder

RUN apk update && apk upgrade && \
    apk add --no-cache git openssh openssl gettext curl

RUN mkdir -p /go
ENV GOPATH=/go

# install proxy
RUN git clone https://github.com/improbable-eng/grpc-web.git $GOPATH/src/github.com/improbable-eng/grpc-web
RUN cd $GOPATH/src/github.com/improbable-eng/grpc-web && git checkout tags/v0.15.0
RUN cd $GOPATH/src/github.com/improbable-eng/grpc-web && go install ./go/grpcwebproxy

FROM alpine:latest

COPY --from=builder /go/bin/grpcwebproxy .

ENTRYPOINT ["./grpcwebproxy"]
