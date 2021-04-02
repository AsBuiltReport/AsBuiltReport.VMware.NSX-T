function Get-AbrNsxtMacDiscoveryProfiles {
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
        $MacDiscoveryProfiles= (get-abrNsxtApi -uri "/policy/api/v1/infra/mac-discovery-profiles").results
        
        $MacDiscoveryProfileInfo = foreach ($MacDiscoveryProfile in $MacDiscoveryProfiles){
            Write-PscriboMessage $MacDiscoveryProfile.display_name
            [PSCustomObject]@{
                'MAC Change' = switch($MacDiscoveryProfile.mac_change_enabled){
                    $true {"Enabled"}
                    $false {"Disabled"}
                    default {"Not Set"}
                }
                'MAC Learning' = switch($MacDiscoveryProfile.mac_learning_enabled){
                    $true {"Enabled"}
                    $false {"Disabled"}
                    default {"Not Set"}
                }               
                'MAC Learning Aging Time' = $MacDiscoveryProfile.mac_learning_aging_time
                'Unknown Unicast Flooding' = switch($MacDiscoveryProfile.unknown_unicast_flooding_enabled){
                    $true {"Enabled"}
                    $false {"Disabled"}
                    default {"Not Set"}
                }       
                'MAC Limit' = $MacDiscoveryProfile.mac_limit
                'MAC Limit Policy' = $MacDiscoveryProfile.mac_limit_policy
                'Remove Overlay MAC Limit' = $MacDiscoveryProfile.remote_overlay_mac_limit 
                'Type' = $MacDiscoveryProfile.resource_type
                'ID' = $MacDiscoveryProfile.id
                'Display Name' = $MacDiscoveryProfile.display_name
                'Description' = $MacDiscoveryProfile.description
                'Path' = $MacDiscoveryProfile.path
                'Relative Path' = $MacDiscoveryProfile.relative_path
                'Marked for Delete' = switch($MacDiscoveryProfile.marked_for_delete){
                    $true {"Enabled"}
                    $false {"Disabled"}
                    default {"Not Set"}
                }
                'Overridden' = switch($MacDiscoveryProfile.overridden){
                    $true {"Enabled"}
                    $false {"Disabled"}
                    default {"Not Set"}
                }  
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
            Name = "MAC Discovery Profiles - $($system)"
            Headers = 'Name', 'MAC Change', 'MAC Learning', 'MAC Learning Aging Time', 'Unknown Unicast Flooding', 'MAC Limit', 'MAC Limit Policy'
            Columns = 'Display Name', 'MAC Change', 'MAC Learning', 'MAC Learning Aging Time', 'Unknown Unicast Flooding', 'MAC Limit', 'MAC Limit Policy'
            #ColumnWidths = 29,7,16,16,16,16
        }
        if ($Report.ShowTableCaptions) {
            $TableParamsSummary['Caption'] = "- $($TableParamsSummary.Name)"
        }
        Section -Style Heading4 "MAC Discovery Profiles" {
            if ($InfoLevel.SegmentProfiles.MacDiscovery -gt 0) {
                $MacDiscoveryProfileInfo | Table @TableParamsSummary
            }
        }

    }
    end {
    }
}

