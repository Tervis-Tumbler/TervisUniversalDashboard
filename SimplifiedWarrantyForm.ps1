Get-UDDashboard | where port -eq 10003 | Stop-UDDashboard
$Dashboard = New-UDDashboard -Title "Input Quantity" -Content {
    New-UDRow -Columns {
        New-UDInput -Title Test -Content {
            New-UDInputField -Name Text -Type textbox
            New-UDInputField -Name Test -Type textbox
            New-UDInputField -Name State -Values FL,GA -Type select
            New-UDInputField -Name State -Values FL,GA -Type select
            New-UDInputField -Name State -Values FL,GA -Type select
            New-UDInputField -Name Test2 -Type textbox
            New-UDInputField -Name Test3 -Type textbox
        } -Endpoint {
            param (
                $Text
            )
        }
    }
}
Start-UDDashboard -Port 10003 -Dashboard $Dashboard