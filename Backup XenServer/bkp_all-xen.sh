#!/usr/bin/bash

#Rotina para backup VMs  XEN a quente

##ATENCAO##
# Rotina efetua backup de acordo com dia da semana e com TAG de existente na VM;
#
# TAGS: BKP_DIA, BKP_SEMANA, BKP_MES;
#

# LISTAR VMS para encontra a identificação ( UUID ) da maquina que será exportada
## xe vm-list is-control-domain=false
#CRIAR SNAPSHOT DA MAQINA QUE DESEJA EXPORTAR
## xe vm-snapshot uuid= AQUI VOCE COLOCA O UUID DA MAQUINA QUE SERA EXPORTADA new-name-label=bkp_vm_xp
# APOS CRIAR O SNAPSHOT TRANSFORMA O SNAPSHOT EM VM
## xe template-param-set is-a-template=false ha-always-run=false uuid=AQUI VOCE COLOCA O UUID DO SNAPSHOT
# COPIA A VM PARA SUA PASTA NA REDE
## xe vm-export vm=AQUI VOCE COLOCA O UUID DO SNAPSHOT filename=/mnt/pasta_bkp/win_xp_bkp.xva
# Remover VM Snapshot
## xe vm-uninstall uuid=b759625c-eab5-4e0f-be5e-a05bcbad869a force=true

COR_GREEN='\e[44;32m'
COR_RED='\e[44;31m'
COR_DISABLE='\e[0m'

DATA=`date +'%Y.%m.%d_%H.%M.%S'`

capturaDadosVm(){
    echo -e "$COR_GREEN Coletando dados VM... $1 $COR_DISABLE"
    DADOS_VM=`xe vm-list params=name-label uuid=$1`
    if [ $? -ne 0 ]; then echo -e "Ocorreu um erro ao obter listagem do Host \n";else echo "OK" ; fi
    UUID_VM=$1
    NOME_VM=$(echo $DADOS_VM | grep ":" | cut -d ":" -f 2 | sed -e 's/^ //g' -e 's/ /_/g')

    echo -e "$COR_RED \nTratando BKP VM $NOME_VM com UUID: $UUID_VM \n$COR_DISABLE"
}

criaSnapshotVm(){
    echo -e "Criando Snapshot da VM..."
    ID_SNAPSHOT=`xe vm-snapshot uuid=$UUID_VM new-name-label=snap_$NOME_VM`
    if [ $? -ne 0 ]; then echo -e "FalhaCriaSnap \n";else echo "OK [ $ID_SNAPSHOT ]" ; fi
}

transformaSnapshotEmVm(){
    echo -e "Transformando Snapshot em VM..."
    NOVA_VM=`xe template-param-set is-a-template=false ha-always-run=false uuid=$ID_SNAPSHOT`
    if [ $? -ne 0 ]; then echo -e "Falha transform... \n";else echo "OK [ $NOVA_VM ]" ; fi
}

exportaVmCriada(){
    echo -e "Exportando VM... ${DATA}_${NOME_MODO_BACKUP}_${NOME_VM}.xva"
    EXPORTA=`xe vm-export vm=$ID_SNAPSHOT filename=/bkp/${DATA}-${NOME_MODO_BACKUP}-${NOME_VM}.xva --compress`
    if [ $? -ne 0 ]; then echo -e "Exportando... \n";else echo "OK [ $EXPORTA ]" ; fi
}

apagaSnapshot(){
    echo -e "Apagando VM(Snapshot)..."
    APAGA=`xe vm-uninstall uuid=$ID_SNAPSHOT force=true`
    if [ $? -ne 0 ]; then echo -e "Falha ao Apagar... \n";else echo "OK [ $APAGA ]" ; fi
}

processaListaVms(){
    echo -e "$COR_GREEN Vamos Consultar Lista VMS com TAG $1 $COR_DISABLE"
    for VM in `xe vm-list is-control-domain=false tags:contains=$1 params=uuid  | grep ":" | awk '{print $5}'`
    do
        echo -e "\n ###XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX###\n"
        capturaDadosVm $VM
        criaSnapshotVm
        transformaSnapshotEmVm
        exportaVmCriada
        apagaSnapshot
        echo -e "\n ###ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ###\n"
    done
}

defineModoBackup(){
    # %w     day of week (0..6); 0 is Sunday
    DIA_SEMANA=$(date +%w)
    # %d     day of month (e.g., 01)
    DIA_MES=$(date +%d)

    #Vamos Ver  se é dia do bkp MENSAL
    if (( $DIA_MES == 1 )); then
        MODO_BACKUP=2
    else
            #Vamos ver se é dia do backup DIÁRIO
            if (( $DIA_SEMANA < 6 )); then
                MODO_BACKUP=0
            #Se não é diário, então é o SEMANAL
        else
            MODO_BACKUP=1
        fi
    fi
}

#montaDiretorioRemotoBackup(){
#    PASTA_MONTAGEM_REMOTA="/BACKUP"
#
#    if grep -qs "$PAsTA_MONTAGEM_REMOTA" /proc/mounts; then
#        echo "Tah Montado!"
#    else
#        echo "Nao Tah montado... vamos tentar montar..."
#        mount -t cifs //10.0.0.105/share-storage/bkp-vms-teste $PASTA_MONTAGEM_REMOTA -o user=webhaus,password=webhaus81
#        if [ $? -eq 0 ]; then
#            echo "Montamos uhu!"
#        else
#            echo "Ferou... nao rolou montar..."
#            exit
#        fi
#    fi
#}

#montaDiretorioRemotoBackup
defineModoBackup

# Excluir todos os arquivos, deixa apenas os dois ultimos criados
ls -td1 /bkp/* | sed -e '1,1d' | xargs -d '\n' rm -rif

if (( $MODO_BACKUP == 0 )); then
    echo -e "\n$COR_GREEN  Efetuando backup $COR_RED DIA $COR_DISABLE\n"
    NOME_MODO_BACKUP=DIA
    processaListaVms BKP_DIA
elif (( $MODO_BACKUP == 1 )); then
    echo -e "\n$COR_GREEN  Efetuando backup $COR_RED SEMANA $COR_DISABLE\n"
    NOME_MODO_BACKUP=SEMANA
    processaListaVms BKP_SEMANA
else
    echo -e "\n$COR_GREEN  Efetuando backup $COR_RED MES $COR_DISABLE\n"
    NOME_MODO_BACKUP=MES
    processaListaVms BKP_MES
fi
