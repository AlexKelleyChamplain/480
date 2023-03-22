Import-Module '480-utils' -Force
#Call the banner function
480Banner
#$conf = Get-480Config -config_path "/home/alex/Documents/GitHub/480/modules/480-utils/480.json"
#480Connect -server $conf.vcenter_server
#Write-Host "Selecting your VM./"
#Select-VM -folder "BASE"
#cloner -config_path "/home/alex/Documents/GitHub/480/modules/480-utils/480.json
#Get-IP -vmname "480-fw" -vcenter_server "vcenter.alex.local"
$vmname = Read-Host -Prompt "name of vm"
Get-IP -vCenterServer "vcenter.alex.local" -vmName $vmname



#virtuall switch
#Write-Host "creating a new Switch"
#$SwitchName = Read-Host -Prompt "enter switch name"
#$PortGroup = Read-Host -Prompt "enter port name"
#NewVirtualSwitch -Switchaname $SwitchName -PortGroup $PortGroup
#Get-VirtualSwitch






