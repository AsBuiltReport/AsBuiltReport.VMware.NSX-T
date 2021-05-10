
function Get-AbrNsxtT0Routers {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve VMware NSXT T0 Routers Information
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
    }

    process {
        $T0Routers = get-abrNsxtApi -uri "/policy/api/v1/infra/tier-0s"
        if($T0Routers.result_count -ge 1){
            $T0RouterInfo = foreach ($T0Router in $T0Routers.results){
                [PSCustomObject]@{
                    'Transit Subnets' = $T0Router.transit_subnets
                    'Internal Transit Subnets' = $T0Router.internal_transit_subnets
                    'Firewall' = switch($T0Router.disable_firewall){
                        $true {"Disabled"}
                        $false {"Enabled"}
                        default {"Enabled"}   
                    }
                    'Failover Mode' = switch($T0Router.failover_mode){
                        "PREEMPTIVE" {"Preemptive"}
                        "NON_PREEMPTIVE" {"Non Preemptive"}
                        default {"Non Preemptive"}   
                    }
                    'HA Mode' = switch($T0Router.ha_mode){
                        "ACTIVE_ACTIVE" {"Active/Active"}
                        "ACTIVE_STANDBY" {"Active/Standby"}
                        default {"Unkown"}
                    }
                    #'IPv6 Profile Paths   ' = $T0Router.ipv6_profile_paths   
                    'Force Whitelisting' = $T0Router.force_whitelisting
                    'Default Rule Logging' = $T0Router.default_rule_logging
                    'Type' = $T0Router.resource_type
                    'ID' = $T0Router.id
                    'Display Name' = $T0Router.display_name
                    'Path' = $T0Router.path
                    'Relative Path' = $T0Router.relative_path
                    'Parent Path' = $T0Router.parent_path
                    'Unique ID' = $T0Router.unique_id
                    'Marked for Delete' = $T0Router.marked_for_delete
                    'Overridden' = $T0Router.overridden
                    'Create User' = $T0Router._create_user
                    'Create Time' = $T0Router._create_time
                    'Last Modified User' = $T0Router._last_modified_user
                    'Last Modified Time' = $T0Router._last_modified_time
                    'System Owned' = $T0Router._system_owned
                    'Protection' = $T0Router._protection
                    'Revision' = $T0Router._revision
                }
            }
            $TableParams = @{
                Name = "T0 Routers - $($system)"
                Headers = 'Name',         'Firewall', 'HA Mode', 'Failover Mode', 'ID',        'Transit Subnets'
                Columns = 'Display Name', 'Firewall', 'HA Mode', 'Failover Mode', 'Unique ID', 'Transit Subnets'
                #ColumnWidths = 20,10,20,20,30
            }
            if ($Report.ShowTableCaptions) {
                $TableParams['Caption'] = "- $($TableParams.Name)"
            }
            $T0RouterInfo | Table @TableParams
        }else{
            Paragraph 'No Tier 0 Routers Configured'
        }
    }

    end {
    }

}

