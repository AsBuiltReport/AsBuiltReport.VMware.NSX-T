function Get-AbrNsxtMacDiscoveryProfiles {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve VMware NSXT MAC Discovery Profile Information
    .DESCRIPTION
    .NOTES
        Version:        0.1.0
        Author:         Richard Gray
        Twitter:        @goodgigs
        Github:         richard-gray
    .EXAMPLE
    .LINK
    #>

    begin {
        Write-PscriboMessage "Collecting MAC Discovery Profile information."
    }

    process {
        $IpDiscoveryProfiles= (get-abrNsxtApi -uri "/policy/api/v1/global-infra/mac-discovery-profiles").results
        
        $IpDiscoveryProfileInfo = foreach ($IpDiscoveryProfile in $IpDiscoveryProfiles){
            Write-PscriboMessage $IpDiscoveryProfile.display_name
            #ARP Snooping
            If($IpDiscoveryProfile.ip_v4_discovery_options.arp_snooping_config.arp_snooping_enabled -eq "true"){
                $IpDiscoveryProfileArpSnoopingEnabled = "Enabled"
            }else {
                $IpDiscoveryProfileArpSnoopingEnabled = "Disabled"
            }
            #IPv4 DHCP Snooping
            If($IpDiscoveryProfile.ip_v4_discovery_options.dhcp_snooping_enabled -eq "true"){
                $IpDiscoveryProfileIpv4DhcpSnoopingEnabled = "Enabled"
            }else {
                $IpDiscoveryProfileIpv4DhcpSnoopingEnabled = "Disabled"
            }
            #IPv4 VMWare Tools
            If($IpDiscoveryProfile.ip_v4_discovery_options.vmwaretools_enabled -eq "true"){
                $IpDiscoveryProfileIpv4VmwareToolsEnabled = "Enabled"
            }else {
                $IpDiscoveryProfileIpv4VmwareToolsEnabled = "Disabled"
            }
            #IPv6 Neighbour Discovery Snooping
            If($IpDiscoveryProfile.ip_v6_discovery_options.nd_snooping_config.nd_snooping_enabled -eq "true"){
                $IpDiscoveryProfileIpv6NdSnoopingEnabled = "Enabled"
            }else {
                $IpDiscoveryProfileIpv6NdSnoopingEnabled = "Disabled"
            }
            #IPv6 DHCP Snooping
            If($IpDiscoveryProfile.ip_v6_discovery_options.dhcp_snooping_v6_enabled -eq "true"){
                $IpDiscoveryProfileIpv6DhcpSnoopingEnabled = "Enabled"
            }else {
                $IpDiscoveryProfileIpv6DhcpSnoopingEnabled = "Disabled"
            }
            #IPv6 VMWare Tools
            If($IpDiscoveryProfile.ip_v6_discovery_options.vmwaretools_v6_enabled -eq "true"){
                $IpDiscoveryProfileIpv6VmwareToolsEnabled = "Enabled"
            }else {
                $IpDiscoveryProfileIpv6VmwareToolsEnabled = "Disabled"
            }
            #Trust on First Use
            If($IpDiscoveryProfile.tofu_enabled -eq "true"){
                $IpDiscoveryProfileTofuEnabled = "Enabled"
            }else {
                $IpDiscoveryProfileTofuEnabled = "Disabled"
            }
            #Duplicate IP Detection
            If($IpDiscoveryProfile.duplicate_ip_detection.duplicate_ip_detection_enabled -eq "true"){
                $IpDiscoveryProfileDuplicateIpDetectionEnabled = "Enabled"
            }else {
                $IpDiscoveryProfileDuplicateIpDetectionEnabled = "Disabled"
            }
            [PSCustomObject]@{
                'Type' = $IpDiscoveryProfile.resource_type
                'ID' = $IpDiscoveryProfile.id
                'Display Name' = $IpDiscoveryProfile.display_name
                'Description' = $IpDiscoveryProfile.description
                'Path' = $IpDiscoveryProfile.path
                'Relative Path' = $IpDiscoveryProfile.relative_path
                'IPv4 ARP Snooping' =  $IpDiscoveryProfileArpSnoopingEnabled
                'IPv4 ARP Bind Limit' = $IpDiscoveryProfile.ip_v4_discovery_options.arp_snooping_config.arp_binding_limit
                'IPv4 DHCP Snooping' = $IpDiscoveryProfileIpv4DhcpSnoopingEnabled
                'IPv4 VMware Tools' = $IpDiscoveryProfileIpv4VmwareToolsEnabled
                'IPv6 Neighbour Discovery Snooping' = $IpDiscoveryProfileIpv6NdSnoopingEnabled
                'IPv6 Neighbour Discovery Snooping Limit' = $IpDiscoveryProfile.ip_v6_discovery_options.nd_snooping_config.nd_snooping_limit
                'IPv6 DHCP Snooping' = $IpDiscoveryProfileIpv6DhcpSnoopingEnabled
                'IPv6 VMware Tools' = $IpDiscoveryProfileIpv6VmwareToolsEnabled
                'Trust on first use' = $IpDiscoveryProfileTofuEnabled
                'ARP ND Binding Limit Timeout' = $IpDiscoveryProfile.arp_nd_binding_timeout
                'Duplicate IP Detection' = $IpDiscoveryProfileDuplicateIpDetectionEnabled
                'Create User' = $IpDiscoveryProfile._create_user
                'Create Time' = $IpDiscoveryProfile._create_time
                'Last Modified User' = $IpDiscoveryProfile._last_modified_user
                'Last Modified Time' = $IpDiscoveryProfile._last_modified_time
                'System Owned' = $IpDiscoveryProfile._system_owned
                'Protection' = $IpDiscoveryProfile._protection
                'Revision' = $IpDiscoveryProfile._revision
            }
        }
        $TableParamsSummary= @{
            Name = "MAC Discovery Profile - General Settings - $($system)"
            Headers = 'Name', 'Description', 'Trust on first use', 'ARP ND Binding Limit Timeout', 'Duplicate IP Detection'
            Columns = 'Display Name', 'Description', 'Trust on first use', 'ARP ND Binding Limit Timeout', 'Duplicate IP Detection'
            #ColumnWidths = 29,7,16,16,16,16
        }
        if ($Report.ShowTableCaptions) {
            $TableParamsSummary['Caption'] = "- $($TableParamsSummary.Name)"
        }
        $TableParamsSummaryIPv4 = @{
            Name = "MAC Discovery Profile - IPv4 Settings - $($system)"
            Headers = 'Name', 'IPv4 ARP Snooping', 'IPv4 ARP Bind Limit', 'IPv4 DHCP Snooping', 'IPv4 VMware Tools'
            Columns = 'Display Name', 'IPv4 ARP Snooping', 'IPv4 ARP Bind Limit', 'IPv4 DHCP Snooping', 'IPv4 VMware Tools'
            #ColumnWidths = 29,7,16,16,16,16
        }
        if ($Report.ShowTableCaptions) {
            $TableParamsSummaryIPv4['Caption'] = "- $($TableParamsSummaryIPv4.Name)"
        }
        $TableParamsSummaryIPv6 = @{
            Name = "MAC Discovery Profile - IPv6 Settings - $($system)"
            Headers = 'Name', 'IPv6 Neighbour Discovery Snooping', 'IPv6 Neighbour Discovery Snooping Limit', 'IPv6 DHCP Snooping', 'IPv6 VMware Tools'
            Columns = 'Display Name', 'IPv6 Neighbour Discovery Snooping', 'IPv6 Neighbour Discovery Snooping Limit', 'IPv6 DHCP Snooping', 'IPv6 VMware Tools'
            #ColumnWidths = 29,7,16,16,16,16
        }
        if ($Report.ShowTableCaptions) {
            $TableParamsSummaryIPv6['Caption'] = "- $($TableParamsSummaryIPv6.Name)"
        }
        Section -Style Heading4 "MAC Discovery Profiles" {
            $IpDiscoveryProfileInfo | Table @TableParamsSummary
            $IpDiscoveryProfileInfo | Table @TableParamsSummaryIPv4
            $IpDiscoveryProfileInfo | Table @TableParamsSummaryIPv6
        }

    }
    end {
    }

}

