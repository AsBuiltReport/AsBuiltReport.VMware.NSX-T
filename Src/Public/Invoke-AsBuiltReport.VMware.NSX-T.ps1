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
    # Connect to vCenter Server using supplied credentials
    foreach ($NsxManager in $Target) {

    } # End of Foreach $NsxManager
    #endregion Script Body
} # End Invoke-AsBuiltReport.VMware.NSX-T function