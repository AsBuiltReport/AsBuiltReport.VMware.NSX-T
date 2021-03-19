function Get-AbrNsxtSegments {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve VMware NSXT Segment Information
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
        Write-PscriboMessage "Collecting Segment information."
    }

    process {
        $Segments= (get-abrNsxtApi -uri "/policy/api/v1/infra/segments").results
        
        $SegmentInfo = foreach ($Segment in $Segments){
            Write-PscriboMessage $Segment.display_name
            If($null -ne $segment.vlan_ids){
                $SegmentVlanId = $segment.vlan_ids
            }else{
                $SegmentVlanId = "Not Set"
            }

            If($null -ne $Segment.connectivity_path){
                $SegmentConnectedGatewayID = $Segment.connectivity_path.Split('/')[-1]
                $SegmentConnectedGatewayTier = $Segment.connectivity_path.Split('/')[-2]
                $SegmentConnectedGatewayName = (get-abrNsxtApi -uri "/policy/api/v1/infra/$($SegmentConnectedGatewayTier)/$($SegmentConnectedGatewayID)").display_name                
            }else {
                $SegmentConnectedGatewayName = "Not Set"    
            }


            [PSCustomObject]@{
                'Network Type' = $Segment.type
                'VLANs' = $SegmentVlanId
                'Gateway' = $Segment.subnets.gateway_address
                'Network' = $Segment.subnets.Network
                'Transport Zone Path' = $Segment.transport_zone_path
                'Transport Zone Name' = Switch($Segment.transport_zone_path.Split('/')[-1]){
                    $null {"Not Set"}
                    default {(get-abrNsxtApi -uri "/api/v1/transport-zones/$($_)").display_name}
                }
                'Connected Gateway' = $SegmentConnectedGatewayName
                #'advanced_config' = $Segment.advanced_config
                'Admin State' = $Segment.admin_state
                'Replication Mode' = $Segment.replication_mode   
                'Type' = $Segment.resource_type
                'ID' = $Segment.id
                'Display Name' = $Segment.display_name
                'Path' = $Segment.path
                'Relative Path' = $Segment.relative_path
                'Parent Path' = $Segment.parent_path
                'Unique ID' = $Segment.unique_id
                'Marked for Delete' = $Segment.marked_for_delete
                'Overridden' = $Segment.overridden
                'Create User' = $Segment._create_user
                'Create Time' = $Segment._create_time
                'Last Modified User' = $Segment._last_modified_user
                'Last Modified Time' = $Segment._last_modified_time
                'System Owned' = $Segment._system_owned
                'Protection' = $Segment._protection
                'Revision' = $Segment._revision
            }
            #advanced_config     : @{address_pool_paths=System.Object[]; hybrid=False; inter_router=False; local_egress=False;
            #                      urpf_mode=STRICT; connectivity=ON}
        }
        $TableParams = @{
            Name = "All Segments - $($system)"
            Headers = 'Name', 'VLANs', 'Network', 'Gateway', 'Transport Zone Name', 'Connected Gateway'
            Columns = 'Display Name', 'VLANs', 'Network', 'Gateway', 'Transport Zone Name', 'Connected Gateway'
            ColumnWidths = 10,10,10,10,10,50
            # 29,7,16,16,16,16
        }
        if ($Report.ShowTableCaptions) {
            $TableParams['Caption'] = "- $($TableParams.Name)"
        }
        $SegmentInfo | Table @TableParams
    }
    end {
    }

}

