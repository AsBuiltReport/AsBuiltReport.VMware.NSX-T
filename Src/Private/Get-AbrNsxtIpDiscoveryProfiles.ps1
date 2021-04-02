function Get-AbrNsxtIpDiscoveryProfiles {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve VMware NSXT IP Discovery Profile Information
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
        Write-PscriboMessage "Collecting IP Discovery Profile information."
    }

    process {
        $IpDiscoveryProfiles= (get-abrNsxtApi -uri "/policy/api/v1/infra/ip-discovery-profiles").results
        
        $IpDiscoveryProfileInfo = foreach ($IpDiscoveryProfile in $IpDiscoveryProfiles){
            Write-PscriboMessage $IpDiscoveryProfile.display_name
            [PSCustomObject]@{
                'IPv4 ARP Snooping' = switch($IpDiscoveryProfile.ip_v4_discovery_options.arp_snooping_config.arp_snooping_enabled){ 
                    $true {"Enabled"}
                    $false {"Disabled"}
                    default {"Not Set"}
                }
                'IPv4 ARP Bind Limit' = $IpDiscoveryProfile.ip_v4_discovery_options.arp_snooping_config.arp_binding_limit
                'IPv4 DHCP Snooping' = switch($IpDiscoveryProfile.ip_v4_discovery_options.dhcp_snooping_enabled){
                    $true {"Enabled"}
                    $false {"Disabled"}
                    default {"Not Set"}
                }
                'IPv4 VMware Tools' = switch($IpDiscoveryProfile.ip_v4_discovery_options.vmwaretools_enabled){
                    $true {"Enabled"}
                    $false {"Disabled"}
                    default {"Not Set"}
                }
                'IPv6 Neighbour Discovery Snooping' = switch($IpDiscoveryProfile.ip_v6_discovery_options.nd_snooping_config.nd_snooping_enabled){
                    $true {"Enabled"}
                    $false {"Disabled"}
                    default {"Not Set"}
                }
                'IPv6 Neighbour Discovery Snooping Limit' = $IpDiscoveryProfile.ip_v6_discovery_options.nd_snooping_config.nd_snooping_limit
                'IPv6 DHCP Snooping' = switch($IpDiscoveryProfile.ip_v6_discovery_options.dhcp_snooping_v6_enabled){
                    $true {"Enabled"}
                    $false {"Disabled"}
                    default {"Not Set"}
                }
                'IPv6 VMware Tools' = switch($IpDiscoveryProfile.ip_v6_discovery_options.vmwaretools_v6_enabled){
                    $true {"Enabled"}
                    $false {"Disabled"}
                    default {"Not Set"}
                }
                'Trust on first use' = switch($IpDiscoveryProfile.tofu_enabled){
                    $true {"Enabled"}
                    $false {"Disabled"}
                    default {"Not Set"}
                }
                'ARP ND Binding Limit Timeout' = $IpDiscoveryProfile.arp_nd_binding_timeout
                'Duplicate IP Detection' = switch($IpDiscoveryProfile.duplicate_ip_detection.duplicate_ip_detection_enabled){
                    $true {"Enabled"}
                    $false {"Disabled"}
                    default {"Not Set"}
                }
                'Type' = $IpDiscoveryProfile.resource_type
                'ID' = $IpDiscoveryProfile.id
                'Display Name' = $IpDiscoveryProfile.display_name
                'Description' = $IpDiscoveryProfile.description
                'Path' = $IpDiscoveryProfile.path
                'Relative Path' = $IpDiscoveryProfile.relative_path
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
            Name = "IP Discovery Profile - General Settings - $($system)"
            Headers = 'Name', 'Description', 'Trust on first use', 'ARP ND Binding Limit Timeout', 'Duplicate IP Detection'
            Columns = 'Display Name', 'Description', 'Trust on first use', 'ARP ND Binding Limit Timeout', 'Duplicate IP Detection'
            #ColumnWidths = 29,7,16,16,16,16
        }
        if ($Report.ShowTableCaptions) {
            $TableParamsSummary['Caption'] = "- $($TableParamsSummary.Name)"
        }
        $TableParamsSummaryIPv4 = @{
            Name = "IP Discovery Profile - IPv4 Settings - $($system)"
            Headers = 'Name', 'IPv4 ARP Snooping', 'IPv4 ARP Bind Limit', 'IPv4 DHCP Snooping', 'IPv4 VMware Tools'
            Columns = 'Display Name', 'IPv4 ARP Snooping', 'IPv4 ARP Bind Limit', 'IPv4 DHCP Snooping', 'IPv4 VMware Tools'
            #ColumnWidths = 29,7,16,16,16,16
        }
        if ($Report.ShowTableCaptions) {
            $TableParamsSummaryIPv4['Caption'] = "- $($TableParamsSummaryIPv4.Name)"
        }
        $TableParamsSummaryIPv6 = @{
            Name = "IP Discovery Profile - IPv6 Settings - $($system)"
            Headers = 'Name', 'IPv6 Neighbour Discovery Snooping', 'IPv6 Neighbour Discovery Snooping Limit', 'IPv6 DHCP Snooping', 'IPv6 VMware Tools'
            Columns = 'Display Name', 'IPv6 Neighbour Discovery Snooping', 'IPv6 Neighbour Discovery Snooping Limit', 'IPv6 DHCP Snooping', 'IPv6 VMware Tools'
            #ColumnWidths = 29,7,16,16,16,16
        }
        if ($Report.ShowTableCaptions) {
            $TableParamsSummaryIPv6['Caption'] = "- $($TableParamsSummaryIPv6.Name)"
        }
        Section -Style Heading4 "IP Discovery Profiles" {
            $IpDiscoveryProfileInfo | Table @TableParamsSummary
            if ($InfoLevel.SegmentProfiles.IPDiscoveryIPv4 -gt 0) {
                $IpDiscoveryProfileInfo | Table @TableParamsSummaryIPv4
            }
            if ($InfoLevel.SegmentProfiles.IPDiscoveryIPv6 -gt 0) {
                $IpDiscoveryProfileInfo | Table @TableParamsSummaryIPv6
            }
        }

    }
    end {
    }

}

