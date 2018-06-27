$Dashboard = New-UDDashboard -Title "test" -Content {
    New-UDInput -Title "New Warranty Child" -Endpoint {
        param (
            $DesignName,
            [ValidateSet(
                "10oz (5 1/2)",
                "12oz (4 1/4)",
                "wavy (5 1/2)",
                "wine glass (8 1/2)",
                "My First Tervis Sippy Cup (5 1/5)",
                "16oz (6)",
                "mug (5)",
                "stemless wine glass (4 4/5)",
                "24oz (7 7/8)",
                "water bottle (10.4)",
                "8oz (4)",
                "goblet (7 7/8)",
                "collectible (2 3/4)",
                "tall (6 1/4)",
                "stout (3 1/2)",
                "20oz Stainless Steel (6 3/4)",
                "30oz Stainless Steel (8)"
            )]
            [String]$Size,
            [ValidateSet(1,2,3,4,5,6,7,8,9,10)][String]$Quantity,
            [ValidateSet(
                "Before 2004",2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016,2017,2018,"NA"
            )][String]$ManufactureYear,
            [ValidateSet("cracked","decoration fail","film","heat distortion","stainless defect","seal failure")][String]$ReturnReason
        )
    }
}
Start-UDDashboard -Port 10000 -Dashboard $Dashboard

Get-UDDashboard | where port -eq 10000 | Stop-UDDashboard
$Dashboard = New-UDDashboard -Title "Input form validation failure after clearing input" -Content {
    New-UDInput -Title "Input form with validation" -Endpoint {
        param (
            [ValidateSet("1","2","3","4","5","6","7","8","9","10")][String]$Quantity
        )
        New-UDInputAction -ClearInput -Toast "Quantity $Quantity"
    }
}
Start-UDDashboard -Port 10000 -Dashboard $Dashboard

Get-UDDashboard | where port -eq 10000 | Stop-UDDashboard
$Dashboard = New-UDDashboard -Title "Input ID not set" -Content {
    New-UDInput -Title "Input that should have ID" -Id "TestInput" -Endpoint {
        param (
            $Quantity
        )
    }
    New-UDCard -Title "TestCard" -ID "TestCard" -Content {"Test card content"}
    New-UDElement -Tag "a" -Attributes @{
        className = "btn"
        onClick = {
            Remove-UDElement -Id "TestInput"
            Remove-UDElement -Id "TestCard"
        }
    } -Content {
        "Remove" 
    } 
}
Start-UDDashboard -Port 10000 -Dashboard $Dashboard


Get-UDDashboard | where port -eq 10000 | Stop-UDDashboard
$Dashboard = New-UDDashboard -Title "Input Quantity" -Content {
    New-UDInput -Title "Input that should have ID" -Id "TestInput" -Endpoint {
        param (
            $Quantity
        )
        Wait-Debugger
        $Var = $Quantity
    }
}
Start-UDDashboard -Port 10000 -Dashboard $Dashboard


Get-UDDashboard | where port -eq 10000 | Stop-UDDashboard
$Dashboard = New-UDDashboard -Title "Input Quantity" -Content {
    New-UDInput -Title "Input that should have ID" -Id "TestInput" -Endpoint {
        param (
            $ItemNumber,
            $Quantity
        )
        if (-not $Session:LineItems) {
            $Session:LineItems = New-Object System.Collections.ArrayList
        }
        $Session:LineItems += [PSCustomObject] {
            ItemNumber = $ItemNumber
            Quantity = $Quantity
        }
    }
    New-UDTable
}
Start-UDDashboard -Port 10000 -Dashboard $Dashboard


$CSVPath = $env:TMP
New-Item -ItemType File -Path $CSVPath -Name Test1.csv
New-Item -ItemType File -Path $CSVPath -Name Test2.csv

Get-UDDashboard | where port -eq 10000 | Stop-UDDashboard
$Dashboard = New-UDDashboard -Title "File selector" -Content {
    New-UDColumn -Size 2 -Endpoint {
        New-UDInput -Title "Simple Form" -Id "Form" -Content {
            $Files = (Get-ChildItem -Path $CSVPath).Name
            $NewFiles =@()
            foreach($a in $files){
        
                $NewFiles += $a.trimend(".csv")
        
            }                
            New-UDInputField -Type select -Name 'MigrationChooser' -Placeholder "Which Migration would you like to look at ?" -Values $NewFiles
        
        } -EndPoint {
            param(
                $MigrationChooser
            )
                                                    
            New-UDInputAction -Toast  "Test $MigrationChooser" 
        }
    } -AutoRefresh -RefreshInterval 30
}
Start-UDDashboard -Port 10000 -Dashboard $Dashboard



Get-UDDashboard | where port -eq 10003 | Stop-UDDashboard
$Dashboard = New-UDDashboard -Title "Input Quantity" -Content {
    New-UDInput -Title "Input that should have ID" -Id "TestInput" -Endpoint {
        [cmdletbinding()]
        param (
            $Quantity
        )
        dynamicparam {
            New-DynamicParameter -Name Test -Type String
        }
        process {
            New-UDInputAction -Toast "$Test $Quantity"
        }        
    }
}
Start-UDDashboard -Port 10003 -Dashboard $Dashboard