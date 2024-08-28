# Definir o endereço de destino e o caminho do arquivo de log
$endereco = "8.8.8.8"
$caminhoArquivo = "C:\pingGoogle.txt"

# Criar ou limpar o arquivo de log se já existir
if (Test-Path $caminhoArquivo) {
    Clear-Content -Path $caminhoArquivo
} else {
    New-Item -Path $caminhoArquivo -ItemType File
}

# Loop infinito para testar o ping a cada 1 segundo
while ($true) {
    # Testar o ping
    $resultado = Test-Connection -ComputerName $endereco -Count 1 -Quiet

    # Verificar se o ping falhou
    if (-not $resultado) {
        # Obter a data e hora atuais
        $dataHora = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

        # Escrever a falha no arquivo de log
        $mensagem = "$dataHora - Falha ao pingar $endereco"
        Add-Content -Path $caminhoArquivo -Value $mensagem
    }

    # Aguardar 1 segundo antes de tentar novamente
    Start-Sleep -Seconds 1
}
