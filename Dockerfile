# syntax=docker/dockerfile:1

#
# Build gohugo from source
#
FROM --platform=$TARGETPLATFORM docker.io/buildpack-deps:21.04 as hugo-build
WORKDIR /gohugo

ARG HUGO_VERSION=0.88.1

RUN apt-get update && apt-get install -y build-essential golang-go

RUN curl -fsSLO --compressed "https://github.com/gohugoio/hugo/archive/refs/tags/v${HUGO_VERSION}.tar.gz"
RUN tar -C /gohugo -xzf "v${HUGO_VERSION}.tar.gz" --strip-components=1
RUN go build --tags extended -o /usr/local/bin/hugo

#
# Copy binary to clean image
#
FROM --platform=$TARGETPLATFORM docker.io/buildpack-deps:21.04 as hugo-image
ARG HUGO_VERSION
ENV HUGO_VERSION=${HUGO_VERSION}
COPY --from=hugo-build /usr/local/bin/hugo /usr/local/bin/hugo
