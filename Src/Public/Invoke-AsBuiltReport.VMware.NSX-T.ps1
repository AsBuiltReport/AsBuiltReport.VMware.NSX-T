function Invoke-AsBuiltReport.VMware.NSX-T {
    <#
    .SYNOPSIS  
        PowerShell script to document the configuration of VMware NSX-T infrastucture in Word/HTML/Text formats
    .DESCRIPTION
        Documents the configuration of VMware NSX-T infrastucture in Word/HTML/Text formats using PScribo.
    .NOTES
        Version:        0.1.0
        Author:         Tim Carman
        Twitter:        @tpcarman
        Github:         tpcarman
        Credits:        Iain Brighton (@iainbrighton) - PScribo module
    .LINK
        https://github.com/AsBuiltReport/AsBuiltReport.VMware.NSX-T
    #>

    param (
        [String[]] $Target,
        [PSCredential] $Credential
    )

    # Check if VMware PowerCLI 10.0 or higher is installed
    $RequiredModules = Get-Module -ListAvailable -Name 'VMware.PowerCLI' | Sort-Object -Property Version -Descending | Select-Object -First 1
    if ($RequiredModules.Version.Major -lt 10) {
        Write-Warning -Message "VMware PowerCLI 10.0 or higher is required to run the VMware vSphere As Built Report. Run 'Install-Module -Name VMware.PowerCLI -MinimumVersion 10.0' to install the required modules."
        break
    }

    # Import Report Configuration
    $Report = $ReportConfig.Report
    $InfoLevel = $ReportConfig.InfoLevel
    $Options = $ReportConfig.Options
    # Used to set values to TitleCase where required
    $TextInfo = (Get-Culture).TextInfo

    #region Script Body
    #---------------------------------------------------------------------------------------------#
    #                                         SCRIPT BODY                                         #
    #---------------------------------------------------------------------------------------------#
    # Connect to NsxManager Server using supplied credentials
    foreach ($NsxManager in $Target) { 
        try {
            Write-PScriboMessage "Connecting to NsxT Manager '$NsxManager'."
            $NsxManager = Connect-NsxtServer $NsxManager -Credential $Credential -ErrorAction Stop
        } catch {
            Write-Error $_
        }

        #region Generate NsxManager report
        if ($NsxManager) {
            # Create a lookup hashtable to quickly link VM MoRefs to Names
            # TODO Not sure of what yet

            # TODO Get NsxManager Name for Variable
            # $NsxManagerServerName = ??

            #region NsxManager Server Heading1 Section
            Section -Style Heading1 $NsxManager.name {
                #region NsxManager Server Section
                # TODO Confirm Nsx Manager info level settings
                # $InfoLevel.NsxManager = ??
                Write-PScriboMessage "NsxManager InfoLevel set at $($InfoLevel.NsxManager)."
                if ($InfoLevel.NsxManager -ge 1) {
                    Section -Style Heading2 'NsxManager Server' { 
                        Paragraph "The following sections detail the configuration of NsxManager Server $NsxManagerServerName."
                        BlankLine
                        # Gather basic NsxManager Server Information
                        $vCenterServerInfo = [PSCustomObject]@{
                            'NsxManager Server' = $NsxManagerServerName
                            'IP Address' = ($NsxManagerAdvSettings | Where-Object { $_.name -like 'VirtualCenter.AutoManagedIPV4' }).Value
                            'Version' = $NsxManager.Version
                            'Build' = $NsxManager.Build
                            'OS Type' = $NsxManager.ExtensionData.Content.About.OsType
                        }
                        #region vCenter Server Summary & Advanced Summary
                        if ($InfoLevel.vCenter -le 2) {           
                            $TableParams = @{
                                Name = "vCenter Server Summary - $vCenterServerName"
                                ColumnWidths = 20, 20, 20, 20, 20 
                            }
                            if ($Report.ShowTableCaptions) {
                                $TableParams['Caption'] = "- $($TableParams.Name)"
                            }        
                            $vCenterServerInfo | Table @TableParams
                        }
                        #endregion vCenter Server Summary & Advanced Summary

                        #region vCenter Server Detailed Information
                        if ($InfoLevel.vCenter -ge 3) {
                            #region vCenter Server Detail

                            $TableParams = @{
                                Name = "vCenter Server Configuration - $vCenterServerName"
                                List = $true
                                ColumnWidths = 50, 50
                            }
                            if ($Report.ShowTableCaptions) {
                                $TableParams['Caption'] = "- $($TableParams.Name)"
                            }
                            $vCenterServerInfo | Table @TableParams
                            #endregion vCenter Server Detail

                            #region vCenter Server Database Settings
                            Section -Style Heading3 'Database Settings' {
                                # $vCenterDbInfo = [PSCustomObject]@{
                                #     'Database Type' = $TextInfo.ToTitleCase(($vCenterAdvSettings | Where-Object { $_.name -eq 'config.vpxd.odbc.dbtype' }).Value)
                                #     'Data Source Name' = ($vCenterAdvSettings | Where-Object { $_.name -eq 'config.vpxd.odbc.dsn' }).Value
                                #     'Maximum Database Connection' = ($vCenterAdvSettings | Where-Object { $_.name -eq 'VirtualCenter.MaxDBConnection' }).Value
                                # }
                                # $TableParams = @{
                                #     Name = "Database Settings - $vCenterServerName"
                                #     List = $true
                                #     ColumnWidths = 50, 50 
                                # }
                                # if ($Report.ShowTableCaptions) {
                                #     $TableParams['Caption'] = "- $($TableParams.Name)"
                                # } 
                                # $vCenterDbInfo | Table @TableParams
                            }
                            #endregion vCenter Server Database Settings
                    
                            #region vCenter Server Licensing
                            Section -Style Heading3 'Licensing' {
                                $Licenses = Get-License -Licenses | Select-Object Product, @{L = 'License Key'; E = { ($_.LicenseKey) } }, Total, Used, @{L = 'Available'; E = { ($_.total) - ($_.Used) } }, Expiration -Unique
                                if ($Healthcheck.vCenter.Licensing) {
                                    $Licenses | Where-Object { $_.Product -eq 'Product Evaluation' } | Set-Style -Style Warning
                                    $Licenses | Where-Object { $_.Expiration -eq 'Expired' } | Set-Style -Style Critical 
                                }
                                $TableParams = @{
                                    Name = "Licensing - $vCenterServerName"
                                    ColumnWidths = 25, 25, 12, 12, 12, 14
                                }
                                if ($Report.ShowTableCaptions) {
                                    $TableParams['Caption'] = "- $($TableParams.Name)"
                                }
                                $Licenses | Sort-Object 'Product', 'License Key' | Table @TableParams
                            }
                            #endregion vCenter Server Licensing

                        }
                        #endregion vCenter Server Detailed Information
                    
                        #region vCenter Server Advanced Detail Information
                        if ($InfoLevel.vCenter -ge 4) {
                        }
                        #endregion vCenter Server Advanced Detail Information

                        #region vCenter Server Comprehensive Information
                        if ($InfoLevel.vCenter -ge 5) {
                        }
                        #endregion vCenter Server Comprehensive Information
                    }
                }
            }
        }
    } # End of Foreach $NsxManager
    #endregion Script Body
} # End Invoke-AsBuiltReport.VMware.NSX-T function