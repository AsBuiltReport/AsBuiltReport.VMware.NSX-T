
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
        Write-PscriboMessage "Collecting T0 Router information."
    }

    process {
        $T0Routers = (get-abrNsxtApi -uri "/policy/api/v1/infra/tier-0s").results
        $T0RouterInfo = foreach ($T0Router in $T0Routers){
            [PSCustomObject]@{
                'Transit Subnets' = $T0Router.transit_subnets
                'Internal Transit Subnets' = $T0Router.internal_transit_subnets
                'HA Mode' = $T0Router.ha_mode
                'Failover Mode' = $T0Router.failover_mode
                #'IPv6 Profile Paths   ' = $T0Router.ipv6_profile_paths   
                'Force Whitelisting' = $T0Router.force_whitelisting
                'Default Rule Logging' = $T0Router.default_rule_logging
                'resource_type' = $T0Router.resource_type
                'ID' = $T0Router.resource_type
                'Display Name' = $T0Router.display_name
                'Path' = $T0Router.path
                'Relative Path' = $T0Router.relative_path
                'Parent Path' = $T0Router.parent_path
                'unique_id' = $T0Router.unique_id
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
            Headers = 'Name',         'HA Mode', 'Failover Mode', 'ID'
            Columns = 'Display Name', 'HA Mode', 'Failover Mode', 'ID'
            ColumnWidths = 30,20,20,30
        }
        if ($Report.ShowTableCaptions) {
            $TableParams['Caption'] = "- $($TableParams.Name)"
        }
        $T0RouterInfo | Table @TableParams

         
        <#f ($SegmentJson) {
            Section -Style Heading4 "Segments" {
                $T0RouterInfo = foreach ($T0Router in $T0Routers) {
                    [PSCustomObject]@{
                        'Enclosure' = $T0Router.Enclosure
                        'internal_transit_subnets' = $T0Router.internal_transit_subnets
                        'Slot' = $T0Router.Slot
                        'Serial Number' = $T0Router.sn
                        'Manufacturer' = $T0Router.manufacturer
                        'Model' = $T0Router.model
                        'Firmware' = $T0Router.firmware_revision
                        'Disk Type' = $T0Router.disk_type
                        'Capacity' = $T0Router.capacity
                        'Speed' = $T0Router.max_capable_speed
                        'Status' = $T0Router.disk_state
                    }
                }
                if ($Healthcheck.Appliance.DiskStatus) {
                    $T0RouterInfo | Where-Object { $_.'Status' -ne 'OK' } | Set-Style -Style Critical -Property 'Status'
                }
                if ($InfoLevel.Appliance -ge 2) {
                    foreach ($T0Router in $T0RouterInfo) {
                        Section -Style Heading5 "Enclosure $($T0Router.Enclosure) internal_transit_subnets $($T0Router.internal_transit_subnets) Disk $($T0Router.Slot)" {
                            $TableParams = @{
                                Name = "Enclosure $($T0Router.Enclosure) internal_transit_subnets $($T0Router.internal_transit_subnets) Disk $($T0Router.Slot) Specifications - $($VxrHost.hostname)"
                                List = $true
                                ColumnWidths = 50, 50
                            }
                            if ($Report.ShowTableCaptions) {
                                $TableParams['Caption'] = "- $($TableParams.Name)"
                            }
                            $T0Router | Table @TableParams
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
                    $T0RouterInfo | Table @TableParams
                }
            }
        }#>
    }

    end {
    }

}

