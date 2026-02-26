# Definir o endereço de destino e o caminho do arquivo de log
$endereco = "8.8.8.8"
$caminhoArquivo = "C:\pingGoogle.txt"
$limiteLatencia = 10  # ms

# Criar ou limpar o arquivo de log se já existir
if (Test-Path $caminhoArquivo) {
    Clear-Content -Path $caminhoArquivo
} else {
    New-Item -Path $caminhoArquivo -ItemType File | Out-Null
}

# Loop infinito para testar o ping a cada 1 segundo
while ($true) {

    # Executa o ping com detalhes
    $reply = Test-Connection -ComputerName $endereco -Count 1 -ErrorAction SilentlyContinue

    $dataHora = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    if ($reply) {
        # Extrai a latência (funciona no PowerShell 5.1 e 7+)
        $latencia = $reply.ResponseTime
        if (-not $latencia) {
            $latencia = $reply.Latency.TotalMilliseconds
        }

        # Verifica latência alta
        if ($latencia -gt $limiteLatencia) {
            Add-Content -Path $caminhoArquivo -Value "$dataHora - High latency: ${latencia}ms (limit: ${limiteLatencia}ms)"
        }

    } else {
        # Perda de pacote → mensagem amigável igual ao ping.exe
        Add-Content -Path $caminhoArquivo -Value "$dataHora - Request timed out."
    }

    Start-Sleep -Seconds 1
}
