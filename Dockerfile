FROM mcr.microsoft.com/powershell:7

WORKDIR /app

# Set default values for LISTEN_PORT and WEB_FILES
ENV LISTEN_PORT 8080
ENV WEB_FILES /app/webfiles

COPY . .

CMD ["pwsh", "-File", "/app/server.ps1"]
