FROM ghcr.io/pacroy/azure-cli:latest

# Install dig
RUN apk add --no-cache bind-tools

WORKDIR /work
COPY entrypoint.sh /work/
RUN chown -R 1000:0 /work && \
    chmod +x /work/entrypoint.sh
ENV HOME=/work
USER 1000

ENTRYPOINT [ "/work/entrypoint.sh" ]
