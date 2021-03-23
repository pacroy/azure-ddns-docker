FROM python:3.8-alpine

# Install dig and curl
RUN apk add --no-cache bind-tools curl bash && \
    dig -v && \
    curl --version
