#!/bin/bash
# Script de backup das VM's Xen-Server (VM's RODANDO)
####################################
# Criado por: Acioly                                #
# Fone:(85)9 9792-7303                           #
# E-mail:acioly.aalf@hotmail.com            #
####################################


#################  CLOUD  ##################


#Captura data e hora corrente e joga para a variavel dhvm.
dhvm=`date +%d-%m-%Y_%H:%M:%S`


#Inserir nome do GUEST,UUID DO STORAGE E CAMINHO DE BACKUP
guest=CLOUD
storage=618d3f78-82e9-b610-7a5a-bfe399974f4d
caminho=/backup/cloud


#Cria um snapshot da maquina rodando.
idvm=`xe vm-snapshot vm=$guest new-name-label=$guest_snapshot`


#Converte o snapshot criado em template.
xe template-param-set is-a-template=false uuid=$idvm


#Converte o template em VM e indica onde vai ficar esta VM.
cvvm=`xe vm-copy vm=$guest_snapshot sr-uuid=$storage new-name-label=$guest`


#Exporta a VM para um diretorio.
xe vm-export vm=$cvvm filename=$caminho/$guest-$dhvm.xva


#Dar permissao para qualquer um importar novamente este Guest
chmod 777 -R $caminho


#Deleta o snapshot criado.
xe vm-uninstall --force uuid=$idvm


#Deleta a VM criada e seu VDI.
xe vm-uninstall vm=$cvvm force=true


# Excluir todos os arquivos, deixa apenas os dois ultimos criados
ls -td1 $caminho/* | sed -e '1,2d' | xargs -d '\n' rm -rif
#################################################################################################################