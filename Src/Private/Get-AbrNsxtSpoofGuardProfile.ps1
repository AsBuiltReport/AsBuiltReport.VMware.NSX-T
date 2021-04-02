function Get-AbrNsxtSpoofGuardProfiles {
    <#
    .SYNOPSIS
    Used by As Built Report to retrieve VMware NSXT Spoof Guard Profile Information
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
        Write-PscriboMessage "Collecting Spoof Guard Profile information."
    }

    process {
        $SpoofGuardProfiles = get-abrNsxtApi -uri "/policy/api/v1/infra/spoofguard-profiles"
        if($SpoofGuardProfiles.result_count -ge 1){
            $SpoofGuardProfileInfo = foreach ($SpoofGuardProfile in $SpoofGuardProfiles.results){
                Write-PscriboMessage $SpoofGuardProfile.display_name
                [PSCustomObject]@{
                    'Address Binding Whitelist' = $SpoofGuardProfile.address_binding_whitelist                                          
                    'Type' = $SpoofGuardProfile.resource_type
                    'ID' = $SpoofGuardProfile.id
                    'Display Name' = $SpoofGuardProfile.display_name
                    'Description' = $SpoofGuardProfile.description
                    'Path' = $SpoofGuardProfile.path
                    'Relative Path' = $SpoofGuardProfile.relative_path
                    'Create User' = $SpoofGuardProfile._create_user
                    'Create Time' = $SpoofGuardProfile._create_time
                    'Last Modified User' = $SpoofGuardProfile._last_modified_user
                    'Last Modified Time' = $SpoofGuardProfile._last_modified_time
                    'System Owned' = $SpoofGuardProfile._system_owned
                    'Protection' = $SpoofGuardProfile._protection
                    'Revision' = $SpoofGuardProfile._revision
                }
            }
            $TableParamsSummary= @{
                Name = "Spoof Guard Profiles - $($system)"
                Headers = 'Name'        , 'Address Binding Whitelist'
                Columns = 'Display Name', 'Address Binding Whitelist'
                #ColumnWidths = 29,7,16,16,16,16
            }
            if ($Report.ShowTableCaptions) {
                $TableParamsSummary['Caption'] = "- $($TableParamsSummary.Name)"
            }
            Section -Style Heading4 "Spoof Guard Profiles" {
                if ($InfoLevel.SegmentProfiles.Security -gt 0) {
                    $SpoofGuardProfileInfo | Table @TableParamsSummary
                }
            }
        }else{
            Section -Style Heading4 "Spoof Guard Profiles" {
                Paragraph 'No Spoof Guard Profiles Configured'
            }
        }

    }
    
    end {
    }
}

