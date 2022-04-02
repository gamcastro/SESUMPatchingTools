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

function Set-SESUMDesabilitarVerificacaoCertificado {
    [CmdletBinding()]
    <#
            HELP Aqui
    #>
    param (
        
    )
    BEGIN {
        $RegisterPath = 'HKLM:\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings'
        $paramsTest = @{'Path' = $RegisterPath
            'Value'            = 'CertificateRevocation'
        }
        $paramsSet = @{'Path' = $RegisterPath
            'Name'            = 'CertificateRevocation'
            'Value'           = 0    
        }

        $paramsNew = @{'Path' = $RegisterPath
        'Name' = 'CertificateRevocation'
        'PropertyType' = 'DWord'
        'Value' = 0
        'Force' = $True}

        $paramsCheckValue = @{'Path' = $RegisterPath
        'Name'            = 'CertificateRevocation'
        }
    }
        PROCESS {
           
                if (Test-RegistryValue @paramsTest) {
                    if ((Get-ItemPropertyValue @paramsCheckValue) -ne 0){
                        try{
                            Set-ItemProperty @paramsSet -ErrorAction Stop
                            $props = @{'Success' = $True
                                        'Status' = 'Changed'  
                            }
                            
                        } catch {
                            Write-Warning "FAILED to write to registry"
                            $props = @{'Success' = $false
                                        'Status' = 'Failure Change'}
                        } finally {
                            $obj = New-Object -TypeName psobject -Property $props
                            Write-Output $obj
                        }
                    } else {
                        $props = @{'Success' = $True
                                    'Status' = 'Unchanged'}
                                $obj = New-Object -TypeName psobject -Property $props
                                Write-Output $obj       
                    } 
                    
                }
                else {
                    try {
                        New-ItemProperty @paramsNew -ErrorAction Stop | Out-Null
                        $props = @{'Success' = $True
                                        'Status' = 'Created'  
                            }
                    } catch {
                        Write-Warning "FAILED to write to registry"
                        $props = @{'Success' = $false
                        'Status' = 'Failure Create'}
                    }
                    finally {
                        $obj = New-Object -TypeName psobject -Property $props
                        Write-Output $obj
                    }
                    
                }
            
        }
      END {}
    }

    function Test-RegistryValue {

        param (
    
            [parameter(Mandatory = $true)]
            [ValidateNotNullOrEmpty()]$Path,
    
            [parameter(Mandatory = $true)]
            [ValidateNotNullOrEmpty()]$Value
        )
    
        try {
    
            Get-ItemProperty -Path $Path | Select-Object -ExpandProperty $Value -ErrorAction Stop | Out-Null
            return $true
        }
    
        catch {
    
            return $false
    
        }
    
    }
    