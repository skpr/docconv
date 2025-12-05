ARG ALPINE_VERSION=3.23
FROM alpine:$ALPINE_VERSION

RUN apk add --no-cache tesseract-ocr tesseract-ocr-dev poppler-utils

ARG TARGETPLATFORM
COPY $TARGETPLATFORM/docconv /usr/bin/docconv
ENTRYPOINT ["/usr/bin/docconv"]
