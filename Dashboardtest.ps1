$MicorosftOAuthApplicationID = Get-PasswordstatePassword -ID 5415
$MicrosoftUDAuthenticationMethod = New-UDAuthenticationMethod -AppId $MicorosftOAuthApplicationID.UserName -AppSecret $MicorosftOAuthApplicationID.Password -Provider Microsoft
$LoginPage = New-UDLoginPage -AuthenticationMethod $MicrosoftUDAuthenticationMethod

$WebToPrintImageByOrderPage = New-UDPage -Name "Web to print image" -Content {
    New-UDInput -Title "Web to print image by order number" -Endpoint {
        param (
            [Parameter(HelpMessage="Order Number")]
            $OrderNumber
        )
        New-UDInputAction -Content {
            New-udinput -Title test2 -Endpoint {
                param (
                    [Parameter(HelpMessage="Testing help message")]
                    $Test3
                )
                New-UDInputAction -Toast "Test3"
            }
        }
    }
}

$Dashboard = New-UDDashboard -Title Test -Pages @($WebToPrintImageByOrderPage) -LoginPage $LoginPage
Start-UDDashboard -AutoReload -Dashboard $Dashboard -AllowHttpForLogin