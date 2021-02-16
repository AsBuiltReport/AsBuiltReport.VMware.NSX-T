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
        Get-AbrNsxtSegments
		Get-AbrNsxtT0Routers
		
	}
	#endregion foreach loop
}
