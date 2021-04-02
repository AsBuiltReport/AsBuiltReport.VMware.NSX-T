function Get-AbrNsxtQosProfiles {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve VMware NSXT QoS Profile Information
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
        Write-PscriboMessage "Collecting QoS Profile information."
    }

    process {
        $QosProfiles= (get-abrNsxtApi -uri "/policy/api/v1/infra/qos-profiles").results
        $QosProfileInfo = foreach ($QosProfile in $QosProfiles){
            Write-PscriboMessage $QosProfile.display_name
            [PSCustomObject]@{
                'DSCP Mode' = $QosProfile.dscp.mode
                'DSCP Priority' = $QosProfile.dscp.priority
                'Ingress Rate Limiter' = switch(($QosProfile.shaper_configurations | where-object {$_.resource_type -eq "IngressRateLimiter"}).Enabled){
                    $true {"Enabled"}
                    $false {"Disabled"}
                    default {"Not Set"}
                }  
                'Ingress Rate Limiter Average Bandwidth' = ($QosProfile.shaper_configurations | where-object {$_.resource_type -eq "IngressRateLimiter"}).average_bandwidth         
                'Ingress Rate Limiter Peak Bandwidth' = ($QosProfile.shaper_configurations | where-object {$_.resource_type -eq "IngressRateLimiter"}).peak_bandwidth         
                'Ingress Rate Limiter Burst Size' = ($QosProfile.shaper_configurations | where-object {$_.resource_type -eq "IngressRateLimiter"}).burst_size         
                'Ingress Broadcast Rate Limiter' = switch(($QosProfile.shaper_configurations | where-object {$_.resource_type -eq "IngressBroadcastRateLimiter"}).Enabled){
                    $true {"Enabled"}
                    $false {"Disabled"}
                    default {"Not Set"}
                }  
                'Ingress Broadcast Rate Limiter Average Bandwidth' = ($QosProfile.shaper_configurations | where-object {$_.resource_type -eq "IngressBroadcastRateLimiter"}).average_bandwidth         
                'Ingress Broadcast Rate Limiter Peak Bandwidth' = ($QosProfile.shaper_configurations | where-object {$_.resource_type -eq "IngressBroadcastRateLimiter"}).peak_bandwidth         
                'Ingress Broadcast Rate Limiter Burst Size' = ($QosProfile.shaper_configurations | where-object {$_.resource_type -eq "IngressBroadcastRateLimiter"}).burst_size         
                'Egress Rate Limiter' = switch(($QosProfile.shaper_configurations | where-object {$_.resource_type -eq "EgressRateLimiter"}).Enabled){
                    $true {"Enabled"}
                    $false {"Disabled"}
                    default {"Not Set"}
                }  
                'Egress Rate Limiter Average Bandwidth' = ($QosProfile.shaper_configurations | where-object {$_.resource_type -eq "EgressRateLimiter"}).average_bandwidth         
                'Egress Rate Limiter Peak Bandwidth' = ($QosProfile.shaper_configurations | where-object {$_.resource_type -eq "EgressRateLimiter"}).peak_bandwidth         
                'Egress Rate Limiter Burst Size' = ($QosProfile.shaper_configurations | where-object {$_.resource_type -eq "EgressRateLimiter"}).burst_size         
                'Class of Service' = $QosProfile.class_of_service                                                   
                'Type' = $QosProfile.resource_type
                'ID' = $QosProfile.id
                'Display Name' = $QosProfile.display_name
                'Description' = $QosProfile.description
                'Path' = $QosProfile.path
                'Relative Path' = $QosProfile.relative_path
                'Create User' = $QosProfile._create_user
                'Create Time' = $QosProfile._create_time
                'Last Modified User' = $QosProfile._last_modified_user
                'Last Modified Time' = $QosProfile._last_modified_time
                'System Owned' = $QosProfile._system_owned
                'Protection' = $QosProfile._protection
                'Revision' = $QosProfile._revision
            }
        }
        $TableParamsSummary= @{
            Name = "QoS Profiles - $($system)"
            Headers = 'Name', 'DSCP Mode', 'DSCP Priority', 'Class of Service'
            Columns = 'Display Name', 'DSCP Mode', 'DSCP Priority', 'Class of Service'
            #ColumnWidths = 29,7,16,16,16,16
        }
        if ($Report.ShowTableCaptions) {
            $TableParamsSummary['Caption'] = "- $($TableParamsSummary.Name)"
        }
        Section -Style Heading4 "QoS Profiles" {
            if ($InfoLevel.SegmentProfiles.MacDiscovery -gt 0) {
                $QosProfileInfo | Table @TableParamsSummary
            }
        }

    }
    
    end {
    }
}

