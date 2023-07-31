# HTTP Listener Web Server in PowerShell

This is a simple HTTP server implemented in PowerShell. The server listens on a specified port for incoming HTTP requests and serves files based on those requests. The server supports only the HTTP GET method. 

## Features

- Support for common web file formats (HTML, CSS, JavaScript, JSON, PNG, JPEG, GIF, SVG, BMP, ICO, MP4, MOV, AVI).
- Configuration of the server's listening port and the root directory of the files to be served through environment variables.
- Correct assignment of MIME types based on the file extension.
- Handling of HTTP GET requests.
- Return of 404 Not Found status codes for non-existent files.
- Return of 405 Method Not Allowed status codes for HTTP methods other than GET.
- Return of 400 Bad Request status codes for malformed requests.

## Usage

Set the `WEB_FILES` environment variable to the root directory of the files you want to serve. Set the `LISTEN_PORT` environment variable to the port you want the server to listen on.

```powershell
$env:WEB_FILES = "/path/to/your/files"
$env:LISTEN_PORT = "8080"
```

Then, run the script:

```powershell
.\server.ps1
```

The server will start and begin listening on the specified port. You can now request files from the server using a web browser or a tool like `curl`:

```bash
curl http://localhost:8080/index.html
```

## Notes

This server is intended for simple use cases and should not be used for production purposes. For serving files over HTTP in a production setting, a full-fledged web server like Apache, Nginx, or IIS should be used.

The server does not support HTTPS, so all traffic is sent unencrypted. This may be insecure, depending on the files you are serving and the networks the traffic is passing through.
