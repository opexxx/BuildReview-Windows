Param($ComputerName='.', $Credential,[switch]$FirewallRules)

#(ls 'HKLM:\SYSTEM\CurrentControlSet\services\SharedAccess\Parameters\FirewallPolicy\' |
#{ $_.Name -like '*profile*'}) |
#select -expand name |
#%{ $i = $_; Get-ItemProperty $_.replace('HKEY_LOCAL_MACHINE','HKLM:') |
#select @{n='Profile';e={$i.split('\')[7]} }, EnableFirewall, DisableNotifications }


$hklm = 2147483650
$key = "SYSTEM\CurrentControlSet\services\SharedAccess\Parameters\FirewallPolicy"
$value = "EnableFirewall"

foreach($profile IN @('DomainProfile','PublicProfile','StandardProfile')){

 #$wmi =  # -computername $_ -credential $credential
if($Credential){
    get-wmiobject -ComputerName $ComputerName -Credential $Credential -list "StdRegProv" -namespace root\default | select __server, @{n='ProfileName';e={$profile}}, @{n='EnableFirewall';e={$_.GetDWORDValue($hklm,$key + '\' + $profile,$value).uValue}}
}else{
    get-wmiobject -ComputerName $ComputerName -list "StdRegProv" -namespace root\default | select __server, @{n='ProfileName';e={$profile}}, @{n='EnableFirewall';e={$_.GetDWORDValue($hklm,$key + '\' + $profile,$value).uValue}}
}

#($wmi.GetDWORDValue($hklm,$key,$value)).uvalue

}