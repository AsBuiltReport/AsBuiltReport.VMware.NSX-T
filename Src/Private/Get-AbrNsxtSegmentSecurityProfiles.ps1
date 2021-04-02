function Get-AbrNsxtSegmentSecurityProfiles {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve VMware NSXT Segment Security Profile Information
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
        Write-PscriboMessage "Collecting Segment Security Profile information."
    }

    process {
        $SegmentSecurityProfiles = get-abrNsxtApi -uri "/policy/api/v1/infra/segment-security-profiles"
        if($SegmentSecurityProfiles.result_count -ge 1){
            $SegmentSecurityProfileInfo = foreach ($SegmentSecurityProfile in $SegmentSecurityProfiles.results){
                Write-PscriboMessage $SegmentSecurityProfile.display_name
                [PSCustomObject]@{
                    'BPDU Filter' = switch($SegmentSecurityProfile.bpdu_filter_enable){
                        $true {"Enabled"}
                        $false {"Disabled"}
                        default {"Not Set"}   
                    }
                    'BPDU Filter Allowed MACs' = $SegmentSecurityProfile.bpdu_filter_allow
                    'DHCPv4 Server Block' = switch($SegmentSecurityProfile.dhcp_server_block_enabled){
                        $true {"Enabled"}
                        $false {"Disabled"}
                        default {"Not Set"}
                    } 
                    'DHCPv4 Client Block' = switch($SegmentSecurityProfile.dhcp_client_block_enabled){
                        $true {"Enabled"}
                        $false {"Disabled"}
                        default {"Not Set"}
                    }   
                    'Non IP Traffic Block' = switch($SegmentSecurityProfile.non_ip_traffic_block_enabled){
                        $true {"Enabled"}
                        $false {"Disabled"}
                        default {"Not Set"}
                    }
                    'DHCPv6 Server Block' = switch($SegmentSecurityProfile.dhcp_server_block_v6_enabled){
                        $true {"Enabled"}
                        $false {"Disabled"}
                        default {"Not Set"}
                    } 
                    'DHCPv6 Client Block' = switch($SegmentSecurityProfile.dhcp_client_block_v6_enabled){
                        $true {"Enabled"}
                        $false {"Disabled"}
                        default {"Not Set"}
                    }    
                    'RA Guard' = switch($SegmentSecurityProfile.ra_guard_enabled){
                        $true {"Enabled"}
                        $false {"Disabled"}
                        default {"Not Set"}
                    } 
                    'Rate Limits' = switch($SegmentSecurityProfile.rate_limits_enabled){
                        $true {"Enabled"}
                        $false {"Disabled"}
                        default {"Not Set"}
                    } 
                    'RX Broadcast' = $SegmentSecurityProfile.rate_limits.rx_broadcast
                    'TX Broadcast' = $SegmentSecurityProfile.rate_limits.tx_broadcast
                    'RX Multicast' = $SegmentSecurityProfile.rate_limits.rx_multicast
                    'TX Multicast' = $SegmentSecurityProfile.rate_limits.tx_multicast                                             
                    'Type' = $SegmentSecurityProfile.resource_type
                    'ID' = $SegmentSecurityProfile.id
                    'Display Name' = $SegmentSecurityProfile.display_name
                    'Description' = $SegmentSecurityProfile.description
                    'Path' = $SegmentSecurityProfile.path
                    'Relative Path' = $SegmentSecurityProfile.relative_path
                    'Create User' = $SegmentSecurityProfile._create_user
                    'Create Time' = $SegmentSecurityProfile._create_time
                    'Last Modified User' = $SegmentSecurityProfile._last_modified_user
                    'Last Modified Time' = $SegmentSecurityProfile._last_modified_time
                    'System Owned' = $SegmentSecurityProfile._system_owned
                    'Protection' = $SegmentSecurityProfile._protection
                    'Revision' = $SegmentSecurityProfile._revision
                }
            }
            $TableParamsSummary= @{
                Name = "Segment Security Profiles - $($system)"
                Headers = 'Name'        , 'BPDU Filter', 'BPDU Filter Allowed MACs', 'DHCPv4 Server Block', 'DHCPv4 Client Block', 'Non IP Traffic Block', 'DHCPv6 Server Block', 'RA Guard', 'Rate Limits'
                Columns = 'Display Name', 'BPDU Filter', 'BPDU Filter Allowed MACs', 'DHCPv4 Server Block', 'DHCPv4 Client Block', 'Non IP Traffic Block', 'DHCPv6 Client Block', 'RA Guard', 'Rate Limits'
                #ColumnWidths = 29,7,16,16,16,16
            }
            if ($Report.ShowTableCaptions) {
                $TableParamsSummary['Caption'] = "- $($TableParamsSummary.Name)"
            }
            Section -Style Heading4 "Segment Security Profiles" {
                if ($InfoLevel.SegmentProfiles.Security -gt 0) {
                    $SegmentSecurityProfileInfo | Table @TableParamsSummary
                }
            }
        }else{
            Section -Style Heading4 "Segment Security Profiles" {
                Paragraph 'No Segment Security Profiles Configured'
            }
        }

    }
    
    end {
    }
}

