Exemplo de arquivo de configuração de VPN Wireguard no Linux, com regras de iptables para que os clientes saiam pra internet usando o ip publico do servidor, caso não queira esse tipo de vpn, somente ajustar os script de up e down no arquivo.

Gerar chave publica e privada e substituir no arquivo, usar comando abaixo.

wg genkey | tee privatekey | wg pubkey > publickey