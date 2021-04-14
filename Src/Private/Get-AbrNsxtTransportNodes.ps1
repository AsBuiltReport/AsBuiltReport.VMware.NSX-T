function Get-AbrNsxtTransportNodes {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve VMware NSXT Transport Node Information
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
        Write-PscriboMessage "Collecting Transport Node information."
    }

    process {
        $TransportNodes = get-abrNsxtApi -uri "/api/v1/transport-nodes"
        if($TransportNodes.result_count -ge 1){
            #ESXi Nodes
            $TransportNodeInfo = foreach ($TransportNode in $TransportNodes.results | Where-Object {$_.resource_type -eq "TransportNode"} | Where-object {$_.node_deployment_info.os_type -eq 'ESXI'}){
                Write-PscriboMessage $TransportNode.display_name
                [PSCustomObject]@{
                    'OS' = $TransportNode.node_deployment_info.os_type    
                    'OS Version' = $TransportNode.node_deployment_info.os_version
                    'vCenter IP' = $TransportNode.node_deployment_info.managed_by_server
                    'IP Address' = $TransportNode.node_deployment_info.ip_addresses
                    'FQDN' = $TransportNode.node_deployment_info.fqdn
                    'Discoverd IP Addresse(s)' = $TransportNode.node_deployment_info.discovered_ip_addresses
                    'Type' = $TransportNode.resource_type
                    'ID' = $TransportNode.id
                    'Tags' = $TransportNode.tags
                    'Display Name' = $TransportNode.display_name
                    'Description' = $TransportNode.description
                    'Path' = $TransportNode.path
                    'Relative Path' = $TransportNode.relative_path
                    'Create User' = $TransportNode._create_user
                    'Create Time' = $TransportNode._create_time
                    'Last Modified User' = $TransportNode._last_modified_user
                    'Last Modified Time' = $TransportNode._last_modified_time
                    'System Owned' = $TransportNode._system_owned
                    'Protection' = $TransportNode._protection
                    'Revision' = $TransportNode._revision
                }
            }
            $TableParamsSummary= @{
                Name = "ESXi Host Transport Nodes - $($system)"
                Headers = 'Name'        , 'OS', 'OS Version', 'vCenter IP', 'IP Address', 'Discoverd IP Addresse(s)', 'FQDN'
                Columns = 'Display Name', 'OS', 'OS Version', 'vCenter IP', 'IP Address', 'Discoverd IP Addresse(s)', 'FQDN'
                #ColumnWidths = 29,7,16,16,16,16
            }
            if ($Report.ShowTableCaptions) {
                $TableParamsSummary['Caption'] = "- $($TableParamsSummary.Name)"
            }
            Section -Style Heading2 "ESXi Host Transport Nodes" {
                $TransportNodeInfo | Table @TableParamsSummary
            }
####EDGE NODEs
            $TransportNodeInfo = foreach ($TransportNode in $TransportNodes.results | Where-object {$_.node_deployment_info.resource_type -eq 'EdgeNode'}){
                Write-PscriboMessage $TransportNode.display_name
                [PSCustomObject]@{
                    'Maintenance Mode' = $TransportNode.maintenance_mode    
                    'vCenter ID' = $TransportNode.node_deployment_info.deployment_config.vm_deployment_config
                    'vCenter Name' = (get-abrNsxtApi -uri ("/api/v1/fabric/compute-managers/" + $TransportNode.node_deployment_info.deployment_config.vm_deployment_config.vc_id)).display_name
                    'Cluster ID' = $TransportNode.node_deployment_info.deployment_config.vm_deployment_config.compute_id
                    'Cluster Name' = ((get-abrNsxtApi -uri "/api/v1/fabric/compute-collections/").results | where-object { $_.cm_local_id -eq $TransportNode.node_deployment_info.deployment_config.vm_deployment_config.compute_id}).results.display_name
                    'Datastore ID' = $TransportNode.node_deployment_info.deployment_config.vm_deployment_config.storage_id
                    'Datastore Name' = ((get-abrNsxtApi -uri "/api/v1/fabric/compute-collections/").results | where-object { $_.cm_local_id -eq $TransportNode.node_deployment_info.deployment_config.vm_deployment_config.storage_id}).results.display_name
                    'Host ID' = $TransportNode.node_deployment_info.deployment_config.vm_deployment_config.host_id
                    'IP Address' = $TransportNode.node_deployment_info.ip_addresses
                    'FQDN' = $TransportNode.node_deployment_info.fqdn
                    'Discoverd IP Addresse(s)' = $TransportNode.node_deployment_info.discovered_ip_addresses
                    'Type' = $TransportNode.resource_type
                    'ID' = $TransportNode.id
                    'Tags' = $TransportNode.tags
                    'Display Name' = $TransportNode.display_name
                    'Description' = $TransportNode.description
                    'Path' = $TransportNode.path
                    'Relative Path' = $TransportNode.relative_path
                    'Create User' = $TransportNode._create_user
                    'Create Time' = $TransportNode._create_time
                    'Last Modified User' = $TransportNode._last_modified_user
                    'Last Modified Time' = $TransportNode._last_modified_time
                    'System Owned' = $TransportNode._system_owned
                    'Protection' = $TransportNode._protection
                    'Revision' = $TransportNode._revision
                }
            }
            $TableParamsSummary= @{
                Name = "ESXi Host Transport Nodes - $($system)"
                Headers = 'Name'        , 'OS', 'OS Version', 'vCenter IP', 'IP Address', 'Discoverd IP Addresse(s)', 'FQDN'
                Columns = 'Display Name', 'OS', 'OS Version', 'vCenter IP', 'IP Address', 'Discoverd IP Addresse(s)', 'FQDN'
                #ColumnWidths = 29,7,16,16,16,16
            }
            if ($Report.ShowTableCaptions) {
                $TableParamsSummary['Caption'] = "- $($TableParamsSummary.Name)"
            }
            Section -Style Heading2 "ESXi Host Transport Nodes" {
                $TransportNodeInfo | Table @TableParamsSummary
            }


        }else{
            Section -Style Heading4 "Transport Nodes" {
                Paragraph 'No Transport Nodes Configured'
            }
        }

    }
    
    end {
    }
}

