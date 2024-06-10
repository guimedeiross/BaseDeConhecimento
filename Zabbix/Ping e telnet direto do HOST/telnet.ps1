param (
    [Parameter(Mandatory=$true)]
    [string]$TargetHost,
    [Parameter(Mandatory=$true)]
    [int]$TargetPort
)

try {
    $tcpClient = New-Object System.Net.Sockets.TcpClient
    $tcpClient.Connect($TargetHost, $TargetPort)
    $tcpClient.Close()
    Write-Output "0"
}
catch {
    Write-Output "1"
}