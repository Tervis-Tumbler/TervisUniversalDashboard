$MicorosftOAuthApplicationID = Get-PasswordstatePassword -ID 5415
$MicrosoftUDAuthenticationMethod = New-UDAuthenticationMethod -AppId $MicorosftOAuthApplicationID.UserName -AppSecret $MicorosftOAuthApplicationID.Password -Provider Microsoft
$LoginPage = New-UDLoginPage -AuthenticationMethod $MicrosoftUDAuthenticationMethod

$WebToPrintImageByOrderPageInput = New-UDPage -Name "Web to print image" -Content {
    New-UDInput -Title "Web to print image by order number" -Endpoint {
        param (
            [Parameter(HelpMessage="ERP Order Number",Mandatory)]
            $ERPOrderNumber
        )
        New-UDInputAction -RedirectUrl /order/$ERPOrderNumber
    }
}

$WebToPrintImageByOrderPage = New-UDPage -Url "/order/:ERPOrderNumber" -Endpoint {
    param (
        [Parameter(HelpMessage="Order Number")]
        $ERPOrderNumber
    )
    Set-CustomyzerModuleEnvironment -Name Production
    New-UDTable -Title "Customyzer Approval Order Header" -Headers OrderID, ERPOrderNumber, WebOrderNumber, CustomerEmail, StatusID, CreatedDateUTC -Endpoint {
        Get-CustomyzerApprovalOrder -ERPOrderNumber $ERPOrderNumber |
        Out-UDTableData -Property OrderID, ERPOrderNumber, WebOrderNumber, CustomerEmail, StatusID, CreatedDateUTC
    }

    New-UDTable -Title "Customyzer Approval Order Header" -Headers OrderID, ERPOrderNumber, WebOrderNumber, CustomerEmail, StatusID, CreatedDateUTC -Endpoint {
        Get-CustomyzerApprovalOrder -ERPOrderNumber $ERPOrderNumber |
        Out-UDTableData -Property OrderID, ERPOrderNumber, WebOrderNumber, CustomerEmail, StatusID, CreatedDateUTC
    }
}



$Dashboard = New-UDDashboard -Title Test -Pages @($WebToPrintImageByOrderPageInput, $WebToPrintImageByOrderPage) -LoginPage $LoginPage
Start-UDDashboard -AutoReload -Dashboard $Dashboard -AllowHttpForLogin