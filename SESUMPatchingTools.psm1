function Disable-UAC{
<#
.SYNOPSIS
Ferramenta para desabilitar o UAC (User Account Control) nos sistemas operacionais Windows
#>    
[CmdletBinding()]
param()

BEGIN{}
PROCESS{
    try{
        $params = @{'Path' = 'HKLM:Software\Microsoft\Windows\CurrentVersion\policies\system'
                    'Name' = 'EnableLUA'
                    'PropertyType' = 'DWord'
                    'Value' = 0
                    'Force' = $True}
        New-ItemProperty @params | Out-Null
        $props = @{'Result' = 0}
        $obj = New-Object -TypeName psobject -Property $props
        Write-Output $obj
    }
    Catch{
        Write-Warning "FAILED to write in registry"
        $props = @{'Result' = -1}
        $obj = New-Object -TypeName psobject -Property $props
        Write-Output $obj
    }
        
}
END{}
}