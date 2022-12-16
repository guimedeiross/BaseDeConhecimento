$SourceFile = "C:\2"
$DestinationFile = "C:\Users\User\Documents\pdfs"
$extensao = "*.txt" #,"*.docx"
$j = 0
$values = gci -Path $SourceFile -Recurse -Filter $extensao | ?{ $_.PSIsContainer -eq $false } | Select-Object Directory,Fullname

foreach($i in $values) {
    $j++;
    If(!(Test-Path -Path ($DestinationFile + "\" + $i.Directory.Name))){
            
            mkdir ($DestinationFile + "\" + $i.Directory.Name)
            Move-Item $i.Fullname ($DestinationFile + "\" + $i.Directory.Name) -Force
    } Else {
            $newNameFile = ($i.Fullname.Split(".")[0]).Split("\\")[-1]
            Move-Item $i.FullName ($DestinationFile + "\" + $i.Directory.Name + "\" + $newNameFile + "_" + $j.ToString() + "." + ($i.Fullname.Split(".")[1])) -Force
    }
}
