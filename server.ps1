# Host in a container using a ECS Fargate Cluster
# Provide environment variables for port & EFS mount folder.
# Move it behind CloudFront for TLS & DDoS Protection

function Get-ContentType($filePath) {
	foreach ($extension in $contentTypes.Keys) {
    	if ($filePath -match "\.$extension$") {
        	return $contentTypes[$extension]
    	}
	}
	return 'text/plain'
}

$contentTypes = @{
	'html'  = 'text/html'
	'css'   = 'text/css'
	'js'	= 'application/javascript'
	'json'  = 'application/json'
	'png'   = 'image/png'
	'jpg'   = 'image/jpeg'
	'jpeg'  = 'image/jpeg'
	'gif'   = 'image/gif'
	'svg'   = 'image/svg+xml'
	'bmp'   = 'image/bmp'
	'ico'   = 'image/vnd.microsoft.icon'
	'mp4'   = 'video/mp4'
	'mov'   = 'video/quicktime'
	'avi'   = 'video/x-msvideo'
}

$webfiles = $env:WEB_FILES
$port = $env:LISTEN_PORT

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://*:$port/")
$listener.Start()
Write-Host "Listening at all IP addresses on port $port..."

while ($true) {
	$listener.GetContextAsync().ContinueWith([Action[System.Threading.Tasks.Task[System.Net.HttpListenerContext]]]{
    	param($task)

    	$context = $task.Result
    	$request = $context.Request
    	$response = $context.Response

    	try {
        	if ($request.HttpMethod -eq 'GET') {
            	$localPath = $request.Url.LocalPath
            	if ($localPath -eq '/') { $localPath = '/index.html' }

            	$filePath = [System.IO.Path]::GetFullPath("$webfiles$localPath")

            	if ($filePath.StartsWith($webfiles) -and (Test-Path $filePath)) {
                	$response.ContentType = Get-ContentType $filePath

                	foreach ($extension in $contentTypes.Keys) {
                    	if ($filePath -match "\.$extension$") {
                        	$buffer = [System.IO.File]::ReadAllBytes($filePath)
                        	break
                    	} else {
                        	$content = Get-Content $filePath -Raw
                        	$buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
                    	}
                	}
            	} else {
                	$response.StatusCode = 404
                	$content = 'File not found'
                	$buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
            	}

            	$response.ContentLength64 = $buffer.Length
            	$output = $response.OutputStream
            	$output.Write($buffer, 0, $buffer.Length)
            	$output.Close()
        	} else {
            	$response.StatusCode = 405
            	$content = 'Method not allowed'
            	$buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
            	$response.ContentLength64 = $buffer.Length
            	$output = $response.OutputStream
            	$output.Write($buffer, 0, $buffer.Length)
            	$output.Close()
        	}
    	}
    	catch {
        	$response.StatusCode = 400
        	$content = 'Bad Request'
        	$buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
        	$response.ContentLength64 = $buffer.Length
        	$output = $response.OutputStream
        	$output.Write($buffer, 0, $buffer.Length)
        	$output.Close()
    	}
	}) > $null
}
