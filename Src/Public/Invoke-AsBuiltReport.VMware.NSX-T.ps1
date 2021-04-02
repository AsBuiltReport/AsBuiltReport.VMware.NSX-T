function Invoke-AsBuiltReport.VMware.NSX-T {
    <#
    .SYNOPSIS
        PowerShell script to document the configuration of VMware NSX-T in Word/HTML/Text formats
    .DESCRIPTION
        Documents the configuration of VMware NSX-T in Word/HTML/Text formats using PScribo.
    .NOTES
        Version:        0.1.0
        Author:         Richard Gray
        Twitter:        
        Github:         
        Credits:        Iain Brighton (@iainbrighton) - PScribo module

    .LINK
        https://github.com/AsBuiltReport/AsBuiltReport.VMware.NSX-T
    #>
	
	# Do not remove or add to these parameters
    param (
        [String[]] $Target,
        [PSCredential] $Credential
    )

    # Import Report Configuration
    $Report = $ReportConfig.Report
    $InfoLevel = $ReportConfig.InfoLevel
    $Options = $ReportConfig.Options

    # Used to set values to TitleCase where required
    $TextInfo = (Get-Culture).TextInfo

	# Update/rename the $System variable and build out your code within the ForEach loop. The ForEach loop enables AsBuiltReport to generate an as built configuration against multiple defined targets.
	
    #region foreach loop
    foreach ($System in $Target) {
        Write-PScriboMessage "Segment InfoLevel set at $($InfoLevel.Segment)."
        if ($InfoLevel.Segments -gt 0) {
            Section -Style Heading2 "Segments" {
                Get-AbrNsxtSegments 
                if ($InfoLevel.Segments -gt 3) {
                    Section -Style Heading3 "Profiles" {
                        Get-AbrNsxtIpDiscoveryProfiles
                    }
                }
            }
        }    
        Write-PscriboMessage [string]$($InfoLevel.T0Routers)
        if ($null -eq $InfoLevel.T0Routers) {
            Write-PscriboMessage "Null"
        }else{
            Write-PscriboMessage "Not Null"
        }

        if ($InfoLevel.T0Routers -gt 0) {
            Section -Style Heading2 "Tier 0 Routers" {
                Get-AbrNsxtT0Routers
            }
        }
		
		
	}
	#endregion foreach loop
}
