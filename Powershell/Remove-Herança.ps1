$array = gci -path 'C:\Dados' -Directory -Exclude !*;

foreach ($pasta in $array) {

$acl = Get-ACl $pasta.FullName;

$acl.SetAccessRuleProtection($True, $True);

Set-Acl -Path $pasta.FullName -AclObject $acl;
};