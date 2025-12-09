Resetar a senha de admin do UNIFI Controller no Windows:

1 - Baixar o software "MongoDB Shell Download", tem que ser a versão 1.10 para funcionar, deixei em anexo junto da pasta aqui no git

2 - Extrair para C:\passwordrecoverunifi

3 - Abrir o software da controladora unifi caso não esteja aberto

4 - Ir pelo cmd na pasta "C:\passwordrecoverunifi\bin" e executar os commandos abaixo:

mongosh.exe --port 27117
use ace
db.admin.find()

db.admin.update( { "name" : "admin" }, { $set : { "x_shadow" : "$6$ybLXKYjTNj9vv$dgGRjoXYFkw33OFZtBsp1flbCpoFQR7ac8O0FrZixHG.sw2AQmA5PuUbQC/e5.Zu.f7pGuF7qBKAfT/JRZFk8/" } } )

5 - Os commandos acima reseta a senha do usuario admin para "password"