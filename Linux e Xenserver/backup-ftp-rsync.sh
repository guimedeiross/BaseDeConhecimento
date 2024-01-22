#!/bin/bash


montaDiretorioRemotoBackup(){

if grep -qs "mountpoint" /proc/mounts; then
    echo "Tah Montado!"
    else
		echo "Nao Tah montado... vamos tentar montar..."
		curlftpfs user:password@hostFTP:port/pathFTP mountpoint ##pathFTP is optionally
		#example: curlftpfs anakin:darthvader@estreladamorte.com:21/bkp-luke /mnt
        if [ $? -eq 0 ]; then
            echo "Montamos uhu!"
        else
            echo "Ferrou... nao rolou montar..."
            exit
        fi
    fi
}

montaDiretorioRemotoBackup

rsync -aAXv / --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/bkp-ftp/*"} /mountpoint

umount /mountpoint

sync
