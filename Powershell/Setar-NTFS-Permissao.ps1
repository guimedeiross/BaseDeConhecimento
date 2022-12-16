$identity = 'PMA\cairo';$rights = 'FullControl';$inheritance = 'ContainerInherit, ObjectInherit';$propagation = 'None';$type = 'Allow';$ACE = New-Object System.Security.AccessControl.FileSystemAccessRule($identity,$rights,$inheritance,$propagation, $type)


foreach($i in $t) { $acl = Get-Acl $i.fullName;$acl.AddAccessRule($ACE);Set-Acl -Path $i.fullName -AclObject $acl }
