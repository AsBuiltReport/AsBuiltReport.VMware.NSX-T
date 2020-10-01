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
        try {
            Write-PScriboMessage "Connecting to NSX-T Manager '$NsxManager'."
            Connect-NsxtServer -Server $nsxManager -Credential $Credential -ErrorAction Stop
        } catch {
            Write-Error "Unable to connect to NSX-T Manager '$NsxManager'"
            Write-Error $_
            Continue
        }

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

        # Section -Style Heading2 'BGP Neighbours' {
        #     Paragraph 'The following section provides a summary of the configured Compute Managers.'
        #     BlankLine
        #     Get-NSXTBGPNeighbors  | Table -Name 'BGP Neighbours' -List
        # }

        Section -Style Heading2 'Cluster Mode' {
            Paragraph 'The following section provides a summary of the configured Compute Managers.'
            BlankLine
            Get-NSXTClusterNode  | Table -Name 'Cluster Mode' -List
        }

        Section -Style Heading2 'NSX-T Controllers' {
            Paragraph 'The following section provides a summary of the configured Compute Managers.'
            BlankLine
            Get-NSXTController  | Table -Name 'NSX-T Controllers' -List
        }

        $EdgeClusters = Get-NSXTEdgeCluster
        if ($EdgeClusters) {
            Section -Style Heading2 'NSX-T Edge Clusters' {
                BlankLine
                $EdgeClusters  | Table -Name 'NSX-T Edge Clusters' -List
            }
        }

        # Causes error - Unable to get field 'resource_type', no field of that name found
        # Section -Style Heading2 'NSX-T Fabric Nodes' {
        #     Paragraph 'The following section provides a summary of the configured Compute Managers.'
        #     BlankLine
        #     Get-NSXTFabricNode  | Table -Name 'NSX-T Fabric Nodes' -List
        # }

        Section -Style Heading2 'NSX-T Fabric VMs' {
            Paragraph 'The following section provides a summary of the configured Compute Managers.'
            BlankLine
            Get-NSXTFabricVM  | Table -Name 'NSX-T Fabric VMs' -List
        }

        Section -Style Heading2 'NSX-T Distributed Firewall Rules' {
            Paragraph 'The following section provides a summary of the configured Compute Managers.'
            BlankLine
            Get-NSXTFirewallRule  | Table -Name 'NSX-T Distributed Firewall Rules' -List
        }

        # Section -Style Heading2 'NSX-T Forwarding Table' {
        #     Paragraph 'The following section provides a summary of the configured Compute Managers.'
        #     BlankLine
        #     Get-NSXTForwardingTable  | Table -Name 'NSX-T Forwarding Table' -List
        # }

        $IPAMBlock = Get-NSXTIPAMIPBlock
        if ($IPAMBlock) {
            Section -Style Heading2 'NSX-T IPAM Block' {
                Paragraph 'The following section provides a summary of the configured Compute Managers.'
                BlankLine
                $IPAMBlock | Table -Name 'NSX-T IPAM Block' -List
            }
        }

        Section -Style Heading2 'NSX-T IP Pool' {
            Paragraph 'The following section provides a summary of the configured Compute Managers.'
            BlankLine
            Get-NSXTIPPool  | Table -Name 'NSX-T IP Pool' -List
        }

        $LR = Get-NSXTLogicalRouter
        if ($LR) {
            Section -Style Heading2 'NSX-T Logical Routers' {
                Paragraph 'The following section provides a summary of the configured Compute Managers.'
                BlankLine
                $LR | Table -Name 'NSX-T Logical Routers' -List
            }
        }

        Section -Style Heading2 'NSX-T ' {
            Paragraph 'The following section provides a summary of the configured Compute Managers.'
            BlankLine
            Get-NSXTLogicalRouterPorts  | Table -Name 'NSX-T ' -List
        }

        Section -Style Heading2 'NSX-T ' {
            Paragraph 'The following section provides a summary of the configured Compute Managers.'
            BlankLine
            Get-NSXTLogicalSwitch  | Table -Name 'NSX-T ' -List
        }

        Section -Style Heading2 'NSX-T ' {
            Paragraph 'The following section provides a summary of the configured Compute Managers.'
            BlankLine
            Get-NSXTManager | Table -Name 'NSX-T ' -List
        }

        Section -Style Heading2 'NSX-T ' {
            Paragraph 'The following section provides a summary of the configured Compute Managers.'
            BlankLine
            Get-NSXTNetworkRoutes  | Table -Name 'NSX-T ' -List
        }

        Section -Style Heading2 'NSX-T ' {
            Paragraph 'The following section provides a summary of the configured Compute Managers.'
            BlankLine
            Get-NSXTTraceFlow  | Table -Name 'NSX-T ' -List
        }

        Section -Style Heading2 'NSX-T ' {
            Paragraph 'The following section provides a summary of the configured Compute Managers.'
            BlankLine
            Get-NSXTTransportNode | Table -Name 'NSX-T ' -List
        }

        Section -Style Heading2 'NSX-T ' {
            Paragraph 'The following section provides a summary of the configured Compute Managers.'
            BlankLine
            Get-NSXTTransportZone  | Table -Name 'NSX-T ' -List
        }
        <#
        Section -Style Heading2 'NSX-T ' {
            Paragraph 'The following section provides a summary of the configured Compute Managers.'
            BlankLine
              | Table -Name 'NSX-T ' -List
        }

        #Get-NSXTRoutingTable

        #Get-NSXTTraceFlowObservations


        #>

        Disconnect-NsxtServer -Confirm:$false
    } # End of Foreach $NsxManager
    #endregion Script Body
} # End Invoke-AsBuiltReport.VMware.NSX-T function