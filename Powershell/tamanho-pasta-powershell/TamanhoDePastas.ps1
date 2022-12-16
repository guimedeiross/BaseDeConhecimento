##para executar no powersehll navegue até a pasta onde está o script e execute da seguinte forma . .\TamanhoDePastas.ps1
##e após isso chame a função Get-FolderSize -Folders Folder1,Folder2,Folder3


Function Get-FolderSize {
    param(
    [Parameter(Mandatory=$true)][string[]]$Folders
    )
    
    Begin{
        Foreach($Folder in $Folders){
            if(!(Get-item $Folder)){
                Throw "Erro, $FOLDER não existe ou você não possui permissão nessa pasta. Favor especificar o caminho completo da pasta." 
            }
        }
    }
    Process{
        Foreach($Folder in $Folders){
            $Size = 0
            Get-ChildItem $Folder -Recurse -Attributes "Hidden,!Directory" -ErrorAction silentlycontinue | %{$Size+=$_.Length} 
            [pscustomobject]@{Folder=$Folder;Size="{0:N2}" -f($SIZE/1GB)+" GB"}    
        }
    }
    End{
        
    }
}