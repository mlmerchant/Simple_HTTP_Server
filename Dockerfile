# Start from the PowerShell 7 Linux image
FROM mcr.microsoft.com/powershell:7

# Set the working directory
WORKDIR /app

# Set default values for LISTEN_PORT and WEB_FILES
ENV LISTEN_PORT 8080
ENV WEB_FILES /app/webfiles

# Copy the server.ps1 file from your host to your Docker container's filesystem
COPY server.ps1 .

# CMD instruction provides defaults for executing container 
CMD ["pwsh", "-File", "/app/server.ps1"]
