function 480Connect([string] $server){
    $conn = $global:DefaultVIServer
    #are we already connected
    if ($conn){
        $msg = 'Already Connected to: {0}' -f $conn

        Write-Host -ForegroundColor Green $msg
    }
    else{
        $conn = Connect-VIServer -Server $server
        #if this fails, let Connect-VIServer handle the encryption
    }
}


function Get-480Config([string] $config_path){
    $conf = $null
    if (Test-Path $config_path){
        $conf = (Get-Content -Raw -Path $config_path | ConvertFrom-Json)
        $msg = "Using configuration at {0}" -f $config_path
        Write-Host -ForegroundColor Green $msg
    } 
    else{
        Write-Host -ForegroundColor "Yellow" "No Configurtion"
    }
    return $conf
}

function Select-VM([string] $folder){
        $selected_vm=$null
        try{
            $vms = Get-VM -Location $folder
            $index = 1
            foreach($vm in $vms){
            Write-Host [$index] $vm.name
            $index+=1
        }
        $pick_index = Read-Host "Which index number [x] do you wish to pick?"
        if($pick_index -ge $index){
            return "Error, you selected a VM that does not exist" 
        }
        $selected_vm = $vms[$pick_index -1]
        Write-Host "You picked " $selected_vm.name
        #note this is a full on vm object that we can interact with
        return $selected_vm
    }
    catch{
        Write-Host "Invalid Folder: $folder" -ForegroundColor "Red"
    }

}

function cloner($CloneTarget, $base, $newVM) {
#comand structure " cloner -CloneTarget "(nameofvm)" -base "(Base)" -newVM "(newvmname)"



    try {
        Write-Host $CloneTarget
        Write-Host $base
        Write-Host $newVM

        $vm = Get-VM -Name $CloneTarget
        $snapshot = Get-Snapshot -VM $vm -Name $base
        $vmhost = Get-VMHost -Name $conf.esxi_host_name
        $ds = Get-DataStore -Name $conf.datastore
        $linkedClone = "{0}.linked" -f $vm.name
        $linkedVM = New-VM -LinkedClone -Name $linkedClone -VM $vm -ReferenceSnapshot $snapshot -VMHost $vmhost -Datastore $ds
        $newvm = New-VM -Name "$newVM" -VM $linkedVM -VMHost $vmhost -Datastore $ds
        $newvm | New-Snapshot -Name "Base"
        $linkedvm | Remove-VM
    } 
    catch {
        Write-Host "ERROR"
        exit
    }
}

#milesone 6 switch

function NewVirtualSwitch($Switchname, $esxihost){
    try {
        Write-Host $Switchname
        Write-Host $PortGroup

        $vswitch= New-VirtualSwitch -VMHost $esxihost -Name $Switchname
        $vpg = New-VirtualPortGroup -VirtualSwitch $vswitch -Name $Switchname
        }
    catch {
        <#Do this if a terminating exception happens#>
        Write-Host "ERROR", $_
        exit
    }
}

function Get-IP($VCenter,$Name){
    $vm = Get-VM -Name $Name
    Get-VM -name $vm | Select-Object Name, @{N="IP Address";E={@($_.Guest.IPAdress[0])}}
    Get-NetworkAdapter -Server $VCenter -VM $vm.Name
}




function LinkedCloner($ToClone, $Base, $NewVM){
    Write-Host $ToCloned 
    Write-Host $Base
    Write-Host $NewVM 

    $vm = Get-Vm -Name $ToCLone
    $Snapshot = Get-Snapshot -VM $vm -Name $Base
    $vmhost = Get-VMHost -Name $conf.esxi_host_name
    $ds = Get-DataStore - Name $conf.datastore
    $LinkedClone = $newVM
    $LinkedVM = New-VM -LinkedClone -VM $vm -Snapshot $snapshot -VMHost $vmhost -Datastore $ds
}

function CurrentStatus([string] $vmToCheck){
    Get-VM -Name $vmToCheck
}
function StartVM([string] $name){
    try{
        $vm=Get-VM -Name $name
        Start-VM -VM $vm -Confirm
    } 
    catch {
        Write-Host "Vm is already started"
    }
}
function SopVM([string] $vmToStop){
    try{
        Get-VM -Name $vmToStop
        Stop-VM -VM $vmToStop -Confirm
    }
    catch {
        Write-Host "VM is off"
    }
}


#milestone 6.4
function Set-Network([string] $Name, [string] $networkname, [string] $esxihost, [string] $vcenter){
    $vm = Get-VM -Name $Name
    Write-host $vm, $networkname
    Get-NetworkAdapter -vm $vm | Set-NetworkAdapter -NetworkName $networkname -force
}

#Copying devins code hints for new linked cloner
function New-linkedClone( $ToClone, $newVM, $IP, $data){
    Write-Host $toClone
    Write-Host $newVM

    $vm = Get-VM -Name $ToClone
    $snapshot = Get-Snapshot -VM $vm -Name "Base"
    $vmhost = Get-VMHost -Name $IP
    $ds = Get-DataStore -Name $data
    $linkedClone = $newVM
    $linkedVM = New-VM -LinkedClone -Name $linkedClone -VM $vm -ReferenceSnapshot $snapshot -VMHost $vmhost -Datastore $ds
    }






















function 480Banner()
{
      Write-host "Hello SYS480-Devops"
}
