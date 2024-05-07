/ip firewall address-list
add address=192.168.1.0/24 list=ACESSOMK
add address=192.168.5.0/24 list=ACESSOMK
/ip firewall filter
add action=accept chain=input comment=\
    "ACEITA CONEX\D5ES ESTABELECIDAS OU RELACIONADAS" connection-state=\
    established,related
add action=accept chain=input comment="ACEITA ACESSO AO ROTEADOR REDE LOCAL" \
    src-address-list=ACESSOMK
add action=accept chain=input comment=\
    "ACEITA 50 PACOTES DE ICMP(PING) POR SEGUNDO" limit=50,5:packet protocol=\
    icmp
add action=accept chain=input comment="LIBERA VPN" dst-port=13231 protocol=\
    udp
add action=drop chain=input comment="DROP GERAL"
/ip firewall nat
add action=masquerade chain=srcnat comment="fix the ntp client by changing its\
    \_source port 123 with something higher (mikrotik forum 794718)" \
    out-interface-list=WANs protocol=udp src-port=123 to-ports=12400-12440
add action=masquerade chain=srcnat out-interface-list=WANs
/ipv6 firewall filter
add action=accept chain=input comment=\
    "ACEITA CONEX\D5ES ESTABELECIDAS E RELACIONADAS" connection-state=\
    established,related
add action=accept chain=input comment=\
    "ACEITA 50 PACOTES DE ICMP(PING) POR SEGUNDO" limit=50,5:packet protocol=\
    icmpv6
add action=accept chain=input comment="LIBERA DHCP CLIENT" in-interface=\
    ether1 protocol=udp src-port=546,547
add action=drop chain=input comment="DROP GERAL"

