cd "\\hyper-v\bkpLocal$\temrinal-Windowsw-Server-Backup";
$data = Get-Date -Format dd-MM-yyyy-HH-mm;
mv .\WindowsImageBackup "bkp-$($data)";
Get-ChildItem -path "\\hyper-v\bkpLocal$\temrinal-Windowsw-Server-Backup" | Where-Object {$_.LastWriteTime -le (Get-Date).AddDays(-2)} | Remove-Item -Recurse -Force