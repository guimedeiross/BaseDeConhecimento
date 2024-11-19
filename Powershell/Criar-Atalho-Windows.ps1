$userProfile = [System.Environment]::GetFolderPath('Desktop');
$WshShell = New-Object -COMObject WScript.Shell;
$Shortcut = $WshShell.CreateShortcut("$userProfile\Acesso CAIRO.lnk");
$Shortcut.TargetPath = "\\NCOMP-WKS-02\Publico\Programas\SplashtopSOS.exe";
$Shortcut.Save();