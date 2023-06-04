FROM mcr.microsoft.com/powershell

WORKDIR /app

# Set default values for LISTEN_PORT and WEB_FILES
ENV LISTEN_PORT 8080
ENV WEB_FILES /app/webfiles

COPY . .

CMD ["pwsh", "-File", "/app/server.ps1"]
