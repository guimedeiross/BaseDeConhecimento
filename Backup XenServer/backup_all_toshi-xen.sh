#!/bin/bash
#
# GLOBALMIND SERVICOS EM TECNOLOGIA DA INFORMACAO LTDA
#
# File..................: xenserver/backup_all.sh
# Description...........: Backup all virtual machines of cloud server.
# Created by............: Toshiaki Ezaki
# Creation Date.........: 26-DEZ-2012
#

# List of virtual machines that will be backed up.
export VMS="$(xe vm-list | grep "name-label" | grep -v "Control domain" | tr -s " " | cut -d " " -f 5)"

# Directory where the backups will be made. Can be via NFS...
export BACKUP_DIR=/backup

# Begin the backup.
for VM in $(echo $VMS); do
    # Create a variable with the timestamp of the backup.
    export TIME=$(date --date "now" +%d_%m_%y_%H-%M)

    # Snapshot name of the virtual machine.
    export SNAPSHOT_NAME=$VM-$TIME

    # Backup name of the virtual machine.
    export BACKUP_NAME=$SNAPSHOT_NAME.bak

    # Here the snapshot is created. It's necessary to avoid stopping the virtual machine.
    export ID=$(xe vm-snapshot vm=$VM new-name-label=$SNAPSHOT_NAME &&
        {
            logger -t "XenBackup" -s "$VM - OK Passo 1"
        }||{
            logger -t "XenBackup" -s "$VM - ERR Passo 1"
            exit 1
        })

    # Using the ID obtained in the previous step, defines the virtual machine as not a template.
    xe template-param-set is-a-template=false uuid=$ID &&
        {
            logger -t "XenBackup" -s "$VM - OK Passo 2"
        }||{
            logger -t "XenBackup" -s "$VM - ERR Passo 2"
            exit 2
        }

    # Export the snapshot virtual machine.
    xe vm-export vm=$SNAPSHOT_NAME filename=$BACKUP_DIR/$BACKUP_NAME
        {
            logger -t "XenBackup" -s "$VM - OK Passo 3"
        }||{
            logger -t "XenBackup" -s "$VM - ERR Passo 3"
            exit 3
        }

    # Uninstall the created virtual machine.
    xe vm-uninstall vm=$SNAPSHOT_NAME force=true
        {
            logger -t "XenBackup" -s "$VM - OK Passo 4"
        }||{
            logger -t "XenBackup" -s "$VM - ERR Passo 4"
            exit 4
        }

    # Remove old backups.
    for BACKUP_FILE in `ls $BACKUP_DIR/$VM* | grep -v $BACKUP_NAME`; do
        rm -f $BACKUP_FILE
    done

    # Compress the virtual machine.
    if [ "$1" = "compress" ]; then
        gzip $BACKUP_DIR/$BACKUP_NAME
            {
                logger -t "XenBackup" -s "$VM - OK Passo 5"
            }||{
                logger -t "XenBackup" -s "$VM - ERR Passo 5"
                exit 5
            }
    fi
done

exit 0
