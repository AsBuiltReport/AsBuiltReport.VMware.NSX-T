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
        $NSXTConnect = Connect-NSXT $nsxManager -credential $Credential -SkipCertificate

        $NSXTnode = Invoke-NSXTRestMethod "api/v1/node"
        $NSXTipset = Invoke-NSXTRestMethod "api/v1/ip-sets"
        $NSXTSegment = Get-NSXTPolicyInfraSegments
        $NSXTTz = Get-NSXTTransportZones

        Section -Style Heading2 'NSX-T' {
            Paragraph 'The following section provides a summary of the VMware NSX-T configuration.'
            BlankLine
            #Provide a summary of the NSX-T Environment
            $NSXTSummary = [PSCustomObject] @{
                'NSX-T Manager Address' = $NSXTConnect.Server
                'NSX-T Manager Hostname' = $NSXTnode.hostname
                'NSX-T Manager Node Version' = $NSXTnode.node_version
                'NSX-T Manager Product Version' = $NSXTnode.product_version
                'NSX-T Manager Kernel Version' = $NSXTnode.kernel_version
                'NSX-T Segment ID Count' = $NSXTSegment.count
                'NSX-T Transport Zone Count' = $NSXTTz.count
                'NSX-T IP Set Count' = $NSXTipset.count
                }
            $NSXTSummary | Table -Name 'NSX-T Information' -List
        }
        Disconnect-NSXT -confirm:$false
    } # End of Foreach $NsxManager
    #endregion Script Body
} # End Invoke-AsBuiltReport.VMware.NSX-T function