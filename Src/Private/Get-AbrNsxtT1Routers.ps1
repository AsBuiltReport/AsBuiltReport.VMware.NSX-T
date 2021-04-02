
function Get-AbrNsxtT1Routers {
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
        Write-PscriboMessage "Collecting T0 Router information."
    }

    process {
        $T1Routers = get-abrNsxtApi -uri "/policy/api/v1/infra/tier-1s"
        if($T1Routers.result_count -ge 1){
            $T1RouterInfo = foreach ($T1Router in $T1Routers.results){
                [PSCustomObject]@{
                    'Firewall' = switch($T1Router.disable_firewall){
                        $true {"Disabled"}
                        $false {"Enabled"}
                        default {"Enabled"}   
                    }
                    'Standby Relocation' = switch($T1Router.enable_standby_relocation){
                        $true {"Enabled"}
                        $false {"Disabled"}
                        default {"Disabled"}   
                    }
                    'Failover Mode' = switch($T1Router.failover_mode){
                        "PREEMPTIVE" {"Preemptive"}
                        "NON_PREEMPTIVE" {"Non Preemptive"}
                        default {"Non Preemptive"}   
                    }
                    'Pool Allocation' = switch($T1Router.failover_mode){
                        'ROUTING' {"Routing"}
                        'LB_SMALL' {"Small"}
                        'LB_MEDIUM' {"Medium"}
                        'LB_LARGE' {"Large"}
                        'LB_XLARGE' {"Extra Large"}
                        default {"Routing"}  
                    }
                    'Gateway QoS Profile' = switch($T1Router.qos_profile){
                        $null {"Not Set"}
                        default {$_}
                    }
                    'Route Advertisement Rules' = $T1Router.route_advertisement_rules #more work required not sure how to display? new table or rules?
                    'Route Advertisement Types' = $T1Router.route_advertisement_types
                    'Tags' = $T1Router.tags
                    'tier0_path' = $T1Router.tier0_path
                    'Connected T0' = (get-abrNsxtApi -uri ("/policy/api/v1"+$T1Router.tier0_path)).display_name
                    #'IPv6 Profile Paths   ' = $T1Router.ipv6_profile_paths   
                    'Force Whitelisting' = $T1Router.force_whitelisting
                    'Default Rule Logging' = $T1Router.default_rule_logging
                    'Type' = $T1Router.resource_type
                    'ID' = $T1Router.id
                    'Display Name' = $T1Router.display_name
                    'Path' = $T1Router.path
                    'Relative Path' = $T1Router.relative_path
                    'Parent Path' = $T1Router.parent_path
                    'Unique ID' = $T1Router.unique_id
                    'Marked for Delete' = $T1Router.marked_for_delete
                    'Overridden' = $T1Router.overridden
                    'Create User' = $T1Router._create_user
                    'Create Time' = $T1Router._create_time
                    'Last Modified User' = $T1Router._last_modified_user
                    'Last Modified Time' = $T1Router._last_modified_time
                    'System Owned' = $T1Router._system_owned
                    'Protection' = $T1Router._protection
                    'Revision' = $T1Router._revision
                }
            }
            $TableParams = @{
                Name = "T1 Routers - $($system)"
                Headers = 'Name',         'Firewall', 'Standby Relocation', 'Failover Mode', 'Pool Allocation', 'Gateway QoS Profile', 'Route Advertisement Rules', 'Route Advertisement Types', 'Connected T0'
                Columns = 'Display Name', 'Firewall', 'Standby Relocation', 'Failover Mode', 'Pool Allocation', 'Gateway QoS Profile', 'Route Advertisement Rules', 'Route Advertisement Types', 'Connected T0'
                #ColumnWidths = 20,10,20,20,30
            }
            if ($Report.ShowTableCaptions) {
                $TableParams['Caption'] = "- $($TableParams.Name)"
            }
            $T1RouterInfo | Table @TableParams

            
            <#f ($SegmentJson) {
                Section -Style Heading4 "Segments" {
                    $T1RouterInfo = foreach ($T1Router in $T1Routers) {
                        [PSCustomObject]@{
                            'Enclosure' = $T1Router.Enclosure
                            'internal_transit_subnets' = $T1Router.internal_transit_subnets
                            'Slot' = $T1Router.Slot
                            'Serial Number' = $T1Router.sn
                            'Manufacturer' = $T1Router.manufacturer
                            'Model' = $T1Router.model
                            'Firmware' = $T1Router.firmware_revision
                            'Disk Type' = $T1Router.disk_type
                            'Capacity' = $T1Router.capacity
                            'Speed' = $T1Router.max_capable_speed
                            'Status' = $T1Router.disk_state
                        }
                    }
                    if ($Healthcheck.Appliance.DiskStatus) {
                        $T1RouterInfo | Where-Object { $_.'Status' -ne 'OK' } | Set-Style -Style Critical -Property 'Status'
                    }
                    if ($InfoLevel.Appliance -ge 2) {
                        foreach ($T1Router in $T1RouterInfo) {
                            Section -Style Heading5 "Enclosure $($T1Router.Enclosure) internal_transit_subnets $($T1Router.internal_transit_subnets) Disk $($T1Router.Slot)" {
                                $TableParams = @{
                                    Name = "Enclosure $($T1Router.Enclosure) internal_transit_subnets $($T1Router.internal_transit_subnets) Disk $($T1Router.Slot) Specifications - $($VxrHost.hostname)"
                                    List = $true
                                    ColumnWidths = 50, 50
                                }
                                if ($Report.ShowTableCaptions) {
                                    $TableParams['Caption'] = "- $($TableParams.Name)"
                                }
                                $T1Router | Table @TableParams
                            }
                        }
                    } else {
                        $TableParams = @{
                            Name = "Disk Specifications - $($VxrHost.hostname)"
                            Headers = 'Encl', 'internal_transit_subnets', 'Slot', 'Serial Number', 'Type', 'Capacity', 'Speed', 'Status', 'Firmware'
                            Columns = 'Enclosure', 'internal_transit_subnets', 'Slot', 'Serial Number', 'Disk Type', 'Capacity', 'Speed', 'Status', 'Firmware'
                            ColumnWidths = 8, 8, 8, 20, 10, 13, 11, 11, 11
                        }
                        if ($Report.ShowTableCaptions) {
                            $TableParams['Caption'] = "- $($TableParams.Name)"
                        }
                        $T1RouterInfo | Table @TableParams
                    }
                }
            }#>
        }else{
            Paragraph 'No Tier 0 Routers Configured'
        }
    }

    end {
    }

}

