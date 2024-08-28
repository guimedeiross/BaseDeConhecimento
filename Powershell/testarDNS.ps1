# Defina o domínio a ser testado
$dominio = "globo.com.br"

# Defina o caminho do arquivo de log
$caminhoArquivoLog = "C:\logDNS.txt"

# Loop infinito para testar a resolução a cada segundo
while ($true) {
    try {
        # Limpa o cache DNS
        Clear-DnsClientCache

        # Tenta resolver o nome do domínio
        $resultado = Resolve-DnsName -Name $dominio -ErrorAction Stop
        Write-Host "$dominio resolvido com sucesso."
    } catch {
        # Se ocorrer uma exceção, loga a data e hora no arquivo
        $dataHoraAtual = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $mensagemErro = "{0}: Não conseguiu resolver o nome {1}" -f $dataHoraAtual, $dominio
        Add-Content -Path $caminhoArquivoLog -Value $mensagemErro
        Write-Host "Erro: $mensagemErro"
    }
    
    # Aguarda 1 segundo antes de tentar novamente
    Start-Sleep -Seconds 1
}

