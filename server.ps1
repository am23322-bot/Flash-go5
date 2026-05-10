$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:8080/")
$listener.Start()
Write-Host "Server running at http://localhost:8080/"
while ($listener.IsListening) {
    $context = $listener.GetContext()
    $req = $context.Request
    $res = $context.Response
    $path = $req.Url.AbsolutePath
    if ($path -eq "/") { $path = "\index.html" }
    $filePath = "C:\Users\win 10\Documents\Project1" + $path
    if (Test-Path $filePath) {
        $bytes = [System.IO.File]::ReadAllBytes($filePath)
        $ext = [System.IO.Path]::GetExtension($filePath)
        $map = @{".html"="text/html";".js"="application/javascript";".css"="text/css";".json"="application/json";".png"="image/png";".ico"="image/x-icon";".map"="application/json"}
        $res.ContentType = if ($map.ContainsKey($ext)) { $map[$ext] } else { "text/plain" }
        $res.ContentLength64 = $bytes.Length
        $res.OutputStream.Write($bytes, 0, $bytes.Length)
    } else {
        $res.StatusCode = 404
        $err = [text.encoding]::UTF8.GetBytes("404 Not Found")
        $res.ContentLength64 = $err.Length
        $res.OutputStream.Write($err, 0, $err.Length)
    }
    $res.Close()
}
