ARG alpine_version=3.21
FROM alpine:${alpine_version} AS build

RUN apk add curl \
            make \
            cmake \
            gcc \
            g++ \
            poppler-utils \
            wv \
            lynx \
            tesseract-ocr-dev

# Install Go manually. That way we are not tied to a specific version of Go + Alpine.
# @todo, Update this to buildx in a future release.
ARG go_version=1.26.0
RUN set -eux; \
    arch="$(apk --print-arch)"; \
    case "$arch" in \
      x86_64) goarch="amd64" ;; \
      aarch64) goarch="arm64" ;; \
      *) echo "unsupported arch: $arch" && exit 1 ;; \
    esac; \
    curl -fsSL https://go.dev/dl/go${go_version}.linux-${goarch}.tar.gz \
      | tar -C /usr/local -xz

ENV PATH="/usr/local/go/bin:${PATH}"

WORKDIR /go/src/code.sajari.com/docconv
COPY . /go/src/code.sajari.com/docconv

RUN go build -o dist/docconv -tags ocr code.sajari.com/docconv/docd

ARG alpine_version=3.21
FROM alpine:${alpine_version}

RUN apk add tesseract-ocr \
            tesseract-ocr-dev \
            poppler-utils

COPY --from=build /go/src/code.sajari.com/docconv/dist/docconv /usr/local/bin/docconv

ENTRYPOINT ["/usr/local/bin/docconv"]
