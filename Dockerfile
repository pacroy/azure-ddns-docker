FROM mcr.microsoft.com/azure-cli:2.21.0

# Install dig
RUN apk add --no-cache bind-tools

WORKDIR /work
COPY entrypoint.sh /work/
RUN chown -R 1000:0 /work
ENV HOME=/work
USER 1000

ENTRYPOINT [ "/work/entrypoint.sh" ]
