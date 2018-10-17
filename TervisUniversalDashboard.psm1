function New-TervisUDPreloader {
    [CmdletBinding(DefaultParameterSetName = "indeterminate")]
    param(
        [Parameter(ParameterSetName = "determinate")]
        [ValidateRange(0, 100)]
        $PercentComplete,
        [Parameter(ParameterSetName = "determinate")]
        [Parameter(ParameterSetName = "indeterminate")]
        [PowerShellProTools.UniversalDashboard.Models.DashboardColor]$BackgroundColor,
        [Parameter(ParameterSetName = "determinate")]
        [Parameter(ParameterSetName = "indeterminate")]
        [PowerShellProTools.UniversalDashboard.Models.DashboardColor]$ProgressColor,
        [Parameter(ParameterSetName = 'circular')]
        [Switch]$Circular,
        [Parameter(ParameterSetName = 'circular')]
        [ValidateSet('blue', 'red', 'green')]
        [string]$Color,
        [Parameter(ParameterSetName = 'circular')]
        [ValidateSet('small', 'medium', 'large')]
        [string]$Size
        )

    if ($PSCmdlet.ParameterSetName -eq 'circular') {
        $sizeClass = ''
        switch ($Size) {
            "small" { $sizeClass = 'small' }
            "large" { $sizeClass = 'big' }
        }

        New-UDElement -Tag 'div' -Id preloader -Attributes @{className = "preloader-wrapper $sizeClass active"} -Content {
            New-UDElement -Tag 'div' -Attributes @{ className = "spinner-layer spinner-$color-only"} -Content {
                New-UDElement -Tag 'div' -Attributes @{ className = 'circle-clipper left'} -Content {
                    New-UDElement -Tag 'div' -Attributes @{ className ='circle' } 
                }
                New-UDElement -Tag 'div' -Attributes @{ className = 'gap-patch'} -Content {
                    New-UDElement -Tag 'div' -Attributes @{ className ='circle' } 
                }
                New-UDElement -Tag 'div' -Attributes @{ className = 'circle-clipper right'} -Content {
                    New-UDElement -Tag 'div' -Attributes @{ className ='circle' } 
                }
            }
        }
    }
    else 
    {
        $OutsideAttributes = @{
            className = "progress"
        }
    
        if ($PSBoundParameters.ContainsKey("BackgroundColor")) {
            $OutsideAttributes.style = @{
                backgroundColor = $BackgroundColor.HtmlColor
            }
        }
        
        New-UDElement -Tag "div" -Attributes $OutsideAttributes -Content {
            $Attributes = @{
                className = $PSCmdlet.ParameterSetName
            }
    
            if ($PSBoundParameters.ContainsKey("ProgressColor")) {
                $Attributes.style = @{
                    backgroundColor = $ProgressColor.HtmlColor
                }
            }
    
            if ($PSCmdlet.ParameterSetName -eq "determinate") {
                $Attributes["style"] = @{
                    width = "$($PercentComplete)%"
                }
            }
    
            New-UDElement -Tag "div" -Id preloader -Attributes $Attributes
        }
    }
}

function Debug-UniersalDashboardService {
    param (
        $Port
    )
    $ProcessID = Get-NetTCPConnection -LocalPort $Port -RemotePort 0 | select -ExpandProperty OwningProcess
    Enter-PSHostProcess -Id $ProcessID
}

function Start-TervisUDDashboard {
    param (
        $Dashboard,
        $Port
    )
    $CertificateFilePassword = Get-TervisPasswordstatePassword -GUID "49d35824-dcce-4fc1-98ff-ebb7ecc971de" -AsCredential |
    Select-Object -ExpandProperty Password
    
    $File = Get-item -Path .\certificate.pfx
    Start-UDDashboard -Dashboard $Dashboard -Port $Port -CertificateFile $CertificateFile -CertificateFilePassword $CertificateFilePassword -Wait 
}

function New-TervisUDButtonLink {
    param (
        $Download,
        $Href,
        $Content
    )
    New-UDElement -Tag "a" -Attributes @{
        className = "btn"
        download = $Download
        href = $Href
    } -Content {
        $Content
    }
}