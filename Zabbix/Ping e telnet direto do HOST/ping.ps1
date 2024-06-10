param (
    [string]$hostname,
    [int]$count = 1
)

$pingResult = Test-Connection -ComputerName $hostname -Count $count -ErrorAction SilentlyContinue

if ($pingResult) {
    $responseTime = $pingResult.ResponseTime
    Write-Output "$responseTime"
} else {
	Write-Output "0"
}