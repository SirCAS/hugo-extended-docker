#
# Step 1: Build gohugo from source
#
FROM --platform=$TARGETPLATFORM golang:alpine as hugo-build
ARG HUGO_VERSION

WORKDIR /gohugo

# Install git.
# Git is required for fetching the dependencies.
RUN apk update
RUN apk add alpine-sdk
RUN apk add openssl

RUN wget -U "Mozilla/5.0 (X11; Linux x86_64; rv:94.0) Gecko/20100101 Firefox/94.0" -O "v${HUGO_VERSION}.tar.gz" "https://github.com/gohugoio/hugo/archive/refs/tags/v${HUGO_VERSION}.tar.gz"
RUN tar -C /gohugo -xzf "v${HUGO_VERSION}.tar.gz" --strip-components=1
RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -ldflags="-w -s" --tags extended -o /usr/local/bin/hugo

#
# Step 2: Copy binary to clean image
#
FROM --platform=$TARGETPLATFORM alpine:3.13 as hugo-image
ARG HUGO_VERSION
ENV HUGO_VERSION=${HUGO_VERSION}

LABEL org.opencontainers.image.source https://github.com/SirCAS/hugo-extended-docker

# Add dependencies
RUN apk upgrade --no-cache && apk add --no-cache libgcc libstdc++

# Copy our static executable
COPY --from=hugo-build /usr/local/bin/hugo /usr/local/bin/hugo

ENTRYPOINT ["/usr/local/bin/hugo"]
