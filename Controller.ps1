function Invoke-Menu {
    [CmdletBinding()]
    param()
    Clear-Host
    
    $menu = @"

    Menu
------------------
1. Desabilitar UAC
2. Desabilitar Verificação de Certificado no servidor
9. Sair

"@

[int]$choice = Read-Host $menu


    if((1..9) -notcontains $choice){
        Write-Warning "$choice nao e uma opcao valida"
        pause
        Invoke-Menu
    }

    switch ($choice) {
        1 { Disable-UAC }
        2 {Set-SESUMDesabilitarVerificacaoCertificado}
        9 {
            Clear-Host
            Write-Host "Obrigado" -ForegroundColor Green
            Start-Sleep -Seconds 3
            Return
        }
        Default {
            "$choice nao é uma opção válida"
        }
    }

    Write-Host ""
    pause

    &$MyInvocation.MyCommand
}

Invoke-Menu

