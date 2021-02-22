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
   

    begin {
        Write-PscriboMessage "Collecting MAC Discovery Profile information."
    }

    process {
        $MacDiscoveryProfiles= (get-abrNsxtApi -uri "/policy/api/v1/global-infra/mac-discovery-profiles").results
        
        $MacDiscoveryProfileInfo = foreach ($MacDiscoveryProfile in $MacDiscoveryProfiles){
            Write-PscriboMessage $MacDiscoveryProfile.display_name
            #ARP Snooping
            If($MacDiscoveryProfile.ip_v4_discovery_options.arp_snooping_config.arp_snooping_enabled -eq "true"){
                $MacDiscoveryProfileArpSnoopingEnabled = "Enabled"
            }else {
                $MacDiscoveryProfileArpSnoopingEnabled = "Disabled"
            }
            #IPv4 DHCP Snooping
            If($MacDiscoveryProfile.ip_v4_discovery_options.dhcp_snooping_enabled -eq "true"){
                $MacDiscoveryProfileIpv4DhcpSnoopingEnabled = "Enabled"
            }else {
                $MacDiscoveryProfileIpv4DhcpSnoopingEnabled = "Disabled"
            }
            #IPv4 VMWare Tools
            If($MacDiscoveryProfile.ip_v4_discovery_options.vmwaretools_enabled -eq "true"){
                $MacDiscoveryProfileIpv4VmwareToolsEnabled = "Enabled"
            }else {
                $MacDiscoveryProfileIpv4VmwareToolsEnabled = "Disabled"
            }
            #IPv6 Neighbour Discovery Snooping
            If($MacDiscoveryProfile.ip_v6_discovery_options.nd_snooping_config.nd_snooping_enabled -eq "true"){
                $MacDiscoveryProfileIpv6NdSnoopingEnabled = "Enabled"
            }else {
                $MacDiscoveryProfileIpv6NdSnoopingEnabled = "Disabled"
            }
            #IPv6 DHCP Snooping
            If($MacDiscoveryProfile.ip_v6_discovery_options.dhcp_snooping_v6_enabled -eq "true"){
                $MacDiscoveryProfileIpv6DhcpSnoopingEnabled = "Enabled"
            }else {
                $MacDiscoveryProfileIpv6DhcpSnoopingEnabled = "Disabled"
            }
            #IPv6 VMWare Tools
            If($MacDiscoveryProfile.ip_v6_discovery_options.vmwaretools_v6_enabled -eq "true"){
                $MacDiscoveryProfileIpv6VmwareToolsEnabled = "Enabled"
            }else {
                $MacDiscoveryProfileIpv6VmwareToolsEnabled = "Disabled"
            }
            #Trust on First Use
            If($MacDiscoveryProfile.tofu_enabled -eq "true"){
                $MacDiscoveryProfileTofuEnabled = "Enabled"
            }else {
                $MacDiscoveryProfileTofuEnabled = "Disabled"
            }
            #Duplicate IP Detection
            If($MacDiscoveryProfile.duplicate_ip_detection.duplicate_ip_detection_enabled -eq "true"){
                $MacDiscoveryProfileDuplicateIpDetectionEnabled = "Enabled"
            }else {
                $MacDiscoveryProfileDuplicateIpDetectionEnabled = "Disabled"
            }
            [PSCustomObject]@{
                'Type' = $MacDiscoveryProfile.resource_type
                'ID' = $MacDiscoveryProfile.id
                'Display Name' = $MacDiscoveryProfile.display_name
                'Description' = $MacDiscoveryProfile.description
                'Path' = $MacDiscoveryProfile.path
                'Relative Path' = $MacDiscoveryProfile.relative_path
                'IPv4 ARP Snooping' = switch($MacDiscoveryProfile.ip_v4_discovery_options.arp_snooping_config.arp_snooping_enabled){
                    $true {"Enabled"}
                    $false {"Disabled"}
                    default {"Not Set"}
                }
                
                
                $MacDiscoveryProfileArpSnoopingEnabled
                'IPv4 ARP Bind Limit' = $MacDiscoveryProfile.ip_v4_discovery_options.arp_snooping_config.arp_binding_limit
                'IPv4 DHCP Snooping' = $MacDiscoveryProfileIpv4DhcpSnoopingEnabled
                'IPv4 VMware Tools' = $MacDiscoveryProfileIpv4VmwareToolsEnabled
                'IPv6 Neighbour Discovery Snooping' = $MacDiscoveryProfileIpv6NdSnoopingEnabled
                'IPv6 Neighbour Discovery Snooping Limit' = $MacDiscoveryProfile.ip_v6_discovery_options.nd_snooping_config.nd_snooping_limit
                'IPv6 DHCP Snooping' = $MacDiscoveryProfileIpv6DhcpSnoopingEnabled
                'IPv6 VMware Tools' = $MacDiscoveryProfileIpv6VmwareToolsEnabled
                'Trust on first use' = $MacDiscoveryProfileTofuEnabled
                'ARP ND Binding Limit Timeout' = $MacDiscoveryProfile.arp_nd_binding_timeout
                'Duplicate IP Detection' = $MacDiscoveryProfileDuplicateIpDetectionEnabled
                'Create User' = $MacDiscoveryProfile._create_user
                'Create Time' = $MacDiscoveryProfile._create_time
                'Last Modified User' = $MacDiscoveryProfile._last_modified_user
                'Last Modified Time' = $MacDiscoveryProfile._last_modified_time
                'System Owned' = $MacDiscoveryProfile._system_owned
                'Protection' = $MacDiscoveryProfile._protection
                'Revision' = $MacDiscoveryProfile._revision
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
            $MacDiscoveryProfileInfo | Table @TableParamsSummary
            $MacDiscoveryProfileInfo | Table @TableParamsSummaryIPv4
            $MacDiscoveryProfileInfo | Table @TableParamsSummaryIPv6
        }

    }
    end {
    }
 #>
}

