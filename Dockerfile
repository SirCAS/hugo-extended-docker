#
# Step 1: Build gohugo from source
#
FROM --platform=$TARGETPLATFORM golang:alpine as hugo-build
ARG HUGO_VERSION

WORKDIR /gohugo

# Install git.
# Git is required for fetching the dependencies.
RUN apk update && apk add --no-cache alpine-sdk

RUN wget -O "v${HUGO_VERSION}.tar.gz" "https://github.com/gohugoio/hugo/archive/refs/tags/v${HUGO_VERSION}.tar.gz"
RUN tar -C /gohugo -xzf "v${HUGO_VERSION}.tar.gz" --strip-components=1
RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -ldflags="-w -s" --tags extended -o /usr/local/bin/hugo

#
# Step 2: Copy binary to clean image
#
FROM --platform=$TARGETPLATFORM scratch as hugo-image
ARG HUGO_VERSION
ENV HUGO_VERSION=${HUGO_VERSION}

LABEL org.opencontainers.image.source https://github.com/SirCAS/hugo-extended-docker

# Copy our static executable
COPY --from=hugo-build /usr/local/bin/hugo /usr/local/bin/hugo

ENTRYPOINT ["/usr/local/bin/hugo"]