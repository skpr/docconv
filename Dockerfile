ARG alpine_version=3.18
FROM golang:1.23-alpine${alpine_version} as build

RUN apk add make \
            cmake \
            gcc \
            g++ \
            poppler-utils \
            wv \
            lynx \
            tesseract-ocr-dev

WORKDIR /go/src/code.sajari.com/docconv
COPY . /go/src/code.sajari.com/docconv

RUN go build -o dist/docconv -tags ocr code.sajari.com/docconv/docd

ARG alpine_version=3.18
FROM alpine:${alpine_version}

RUN apk add tesseract-ocr \
            tesseract-ocr-dev \
            poppler-utils

COPY --from=build /go/src/code.sajari.com/docconv/dist/docconv /usr/local/bin/docconv

ENTRYPOINT ["/usr/local/bin/docconv"]
