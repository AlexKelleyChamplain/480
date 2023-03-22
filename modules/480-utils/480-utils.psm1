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
    try{
        $vms = Get-VM -Location $folder
        if ($vms.Count -eq 0) {
            Write-Host "No VMs found in folder: $folder" -ForegroundColor Yellow
            return $null
        }
        $menuOptions = @{}
        $index = 1
        foreach ($vm in $vms) {
            $menuOptions.Add($index.ToString(), $vm.Name)
            $index++
        }
        $choice = Read-Host -Prompt "Choose a VM:"
        if ($menuOptions.ContainsKey($choice)) {
            $selectedVM = $vms[$choice - 1]
            Write-Host "Selected VM: $($selectedVM.Name)" -ForegroundColor Green
            return $selectedVM
        }
        else {
            Write-Host "Invalid choice: $choice" -ForegroundColor Red
            return $null
        }
    }
    catch {
        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
        return $null
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
        $vmhost = Get-VMHost -Name "192.168.7.33"
        $ds = Get-DataStore -Name "datastore1-super1"
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

function NewVirtualSwitch($Switchname, $PortGroup){
    try {
        Write-Host $Switchname
        Write-Host $PortGroup

        New-Switch -VMHost '192.168.7.33' -Name $Switchname
        Get-VMHost '192.168.7.33' | Get-Switch -name $Switchname | New-PortGroup -Name $PortGroup
        }
    catch {
        <#Do this if a terminating exception happens#>
        Write-Host "ERROR"
        exit
    }
}

function Get-IP($VCenter,$Name){
    $vm = Get-VM -Name $Name
    Get-VM -name $vm | Select-Object Name, @{N="IP Address";E={@($_.Guest.IPAdress[0])}}
    Get-NetworkAdapter -Server $VCenter -VM $vm.Name
}




fuction LinkedCloner($ToClone, $Base, $NewVM){
    Write-Host $ToCloned 
    Write-Host $Base
    Write-Host $NewVM 

    $vm = Get-Vm -Name $ToCLone
    $Snapshot = Get-Snapshot -VM $vm -Name $Base
    $vmhost = Get-VMHost -Name "192.168.7.33"
    $ds = Get-DataStore - Name "datastore1-super1"
    $LinkedClone = $newVM
    $LinkedVM = New-VM -LinkedClone -VM $vm -Snapshot $snapshot -VMHost $vmhost -Datastore $ds
}

FIX BELOW
function CurrentStatus([string] $vmToCheck){
    Get-VM -Name $vmToCheck
}
function StartVM([string] $vmToStart){
    try{
        Get-VM -Name $vmToStart
        Start-VM -VM $vmToStart -Confirm
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
























function 480Banner()
{
      Write-host "Hello SYS480-Devops"
}
