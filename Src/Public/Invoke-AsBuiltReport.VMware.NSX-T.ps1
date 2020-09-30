function Invoke-AsBuiltReport.VMware.NSX-T {
    <#
    .SYNOPSIS
        PowerShell script to document the configuration of VMware NSX-T infrastucture in Word/HTML/Text formats
    .DESCRIPTION
        Documents the configuration of VMware NSX-T infrastucture in Word/HTML/Text formats using PScribo.
    .NOTES
        Version:        0.1.0
        Author:         Tim Carman
        Twitter:        @tpcarman
        Github:         tpcarman
        Credits:        Iain Brighton (@iainbrighton) - PScribo module
    .LINK
        https://github.com/AsBuiltReport/AsBuiltReport.VMware.NSX-T
    #>

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

    #region Script Body
    #---------------------------------------------------------------------------------------------#
    #                                         SCRIPT BODY                                         #
    #---------------------------------------------------------------------------------------------#
    # Connect to NSX-T Manager using supplied credentials
    foreach ($NsxManager in $Target) {
        Connect-NsxtServer -Server $nsxManager -credential $Credential -Verbose

        Section -Style Heading2 'Compute Managers' {
            Paragraph 'The following section provides a summary of the configured Compute Managers.'
            BlankLine
            Get-NSXTComputeManager | Table -Name 'Compute Managers' -List
        }

        Section -Style Heading2 'NSX-T Controllers' {
            Paragraph 'The following section provides a summary of the configured Compute Managers.'
            BlankLine
            Get-NSXTController  | Table -Name 'NSX-T Controllers' -List
        }

        Disconnect-NsxtServer -Confirm:$false
    } # End of Foreach $NsxManager
    #endregion Script Body
} # End Invoke-AsBuiltReport.VMware.NSX-T function