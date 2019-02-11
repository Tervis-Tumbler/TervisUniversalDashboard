Get-UDDashboard | Stop-UDDashboard

$Page1 = New-UDPage -Name Homepage -DefaultHomePage -Content {New-UDCard -Content {"Homepage"}}
$Page2 = New-UDPage -Url "/TicketInformation/:ParentTicketID" -Endpoint {
    param (
        $ParentTicketID
    )
    New-UDCard -Text $ParentTicketID
}
$DashBoard = New-UDDashboard -Pages @($Page1, $Page2)
Start-UDDashboard -Dashboard $DashBoard


Get-UDDashboard | Stop-UDDashboard
$Dynamic = New-UDPage -Url "/dynamic/:name" -Endpoint {
    param($name)

    $ScriptColors = @{
        BackgroundColor = "#5A5A5A"
        FontColor = "#FFFFFF"
    }

    New-UDCard @ScriptColors -Title "Welcome to a dynamic page, $name!" -Text "This is a dynamic page. The content of the page is determined by the URL."
}

$DashBoard = New-UDDashboard -Pages $Dynamic
Start-UDDashboard -Dashboard $DashBoard