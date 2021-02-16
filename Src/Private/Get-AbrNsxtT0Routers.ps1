
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
        $T0RouterJson = get-abrNsxtApi -version 1 -uri "/policy/api/v1/infra/tier-0s"
        Write-host $T0RouterJson
        Write-host "Hello World"
        <#f ($SegmentJson) {
            Section -Style Heading4 "Segments" {
                $VxrHostDiskInfo = foreach ($VxrHostDisk in $VxrHostDisks) {
                    [PSCustomObject]@{
                        'Enclosure' = $VxrHostDisk.Enclosure
                        'Bay' = $VxrHostDisk.Bay
                        'Slot' = $VxrHostDisk.Slot
                        'Serial Number' = $VxrHostDisk.sn
                        'Manufacturer' = $VxrHostDisk.manufacturer
                        'Model' = $VxrHostDisk.model
                        'Firmware' = $VxrHostDisk.firmware_revision
                        'Disk Type' = $VxrHostDisk.disk_type
                        'Capacity' = $VxrHostDisk.capacity
                        'Speed' = $VxrHostDisk.max_capable_speed
                        'Status' = $VxrHostDisk.disk_state
                    }
                }
                if ($Healthcheck.Appliance.DiskStatus) {
                    $VxrHostDiskInfo | Where-Object { $_.'Status' -ne 'OK' } | Set-Style -Style Critical -Property 'Status'
                }
                if ($InfoLevel.Appliance -ge 2) {
                    foreach ($VxrHostDisk in $VxrHostDiskInfo) {
                        Section -Style Heading5 "Enclosure $($VxrHostDisk.Enclosure) Bay $($VxrHostDisk.Bay) Disk $($VxrHostDisk.Slot)" {
                            $TableParams = @{
                                Name = "Enclosure $($VxrHostDisk.Enclosure) Bay $($VxrHostDisk.Bay) Disk $($VxrHostDisk.Slot) Specifications - $($VxrHost.hostname)"
                                List = $true
                                ColumnWidths = 50, 50
                            }
                            if ($Report.ShowTableCaptions) {
                                $TableParams['Caption'] = "- $($TableParams.Name)"
                            }
                            $VxrHostDisk | Table @TableParams
                        }
                    }
                } else {
                    $TableParams = @{
                        Name = "Disk Specifications - $($VxrHost.hostname)"
                        Headers = 'Encl', 'Bay', 'Slot', 'Serial Number', 'Type', 'Capacity', 'Speed', 'Status', 'Firmware'
                        Columns = 'Enclosure', 'Bay', 'Slot', 'Serial Number', 'Disk Type', 'Capacity', 'Speed', 'Status', 'Firmware'
                        ColumnWidths = 8, 8, 8, 20, 10, 13, 11, 11, 11
                    }
                    if ($Report.ShowTableCaptions) {
                        $TableParams['Caption'] = "- $($TableParams.Name)"
                    }
                    $VxrHostDiskInfo | Table @TableParams
                }
            }
        }#>
    }

    end {
    }

}

