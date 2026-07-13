$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$server = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, 8765)
$server.Start()
Write-Host 'Local Image Tool is running at http://127.0.0.1:8765/image-resizer.html'
Write-Host 'Only this computer can reach the server. Press Ctrl+C to stop it.'
try {
  Start-Process 'http://127.0.0.1:8765/image-resizer.html'
} catch {
  Write-Warning 'The browser did not open automatically. Open this address manually: http://127.0.0.1:8765/image-resizer.html'
}
try {
  while ($true) {
    $client = $server.AcceptTcpClient()
    try {
      $stream = $client.GetStream()
      $reader = [System.IO.StreamReader]::new($stream, [System.Text.Encoding]::ASCII, $false, 1024, $true)
      $requestLine = $reader.ReadLine()
      while ($reader.ReadLine() -ne '') { }
      if ($requestLine -notmatch '^GET /image-resizer\.html HTTP/1\.[01]$') {
        $header = "HTTP/1.1 404 Not Found`r`nContent-Length: 0`r`nConnection: close`r`n`r`n"
        $body = [System.Text.Encoding]::ASCII.GetBytes($header)
      } else {
        $content = [System.IO.File]::ReadAllBytes((Join-Path $root 'image-resizer.html'))
        $header = "HTTP/1.1 200 OK`r`nContent-Type: text/html; charset=utf-8`r`nContent-Length: $($content.Length)`r`nCache-Control: no-store`r`nConnection: close`r`n`r`n"
        $body = [System.Text.Encoding]::ASCII.GetBytes($header) + $content
      }
      $stream.Write($body, 0, $body.Length)
      $stream.Flush()
    } finally {
      $client.Close()
    }
  }
} finally {
  $server.Stop()
}
