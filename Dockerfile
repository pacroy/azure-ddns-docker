FROM mcr.microsoft.com/azure-cli:2.20.0

# Install dig
RUN apk add --no-cache bind-tools
