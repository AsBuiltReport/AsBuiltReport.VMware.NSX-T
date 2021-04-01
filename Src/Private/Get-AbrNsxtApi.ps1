function Get-AbrNsxtApi {
    <#
    .SYNOPSIS
    Used by As Built Report to process VMware NSXT API requests
    .DESCRIPTION
    .NOTES
        Version:        0.1.0
        Author:         Richard Gray
        Twitter:        @goodgigs
        Github:         richard-gray
    .EXAMPLE
    .LINK
    #>
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $false
        )]
        [ValidateSet("GET")]
        [string] $Method = "GET",
        [Parameter(
            Mandatory = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String] $Uri
    )

    Begin {
    #region Workaround for SelfSigned Cert an force TLS 1.2
        if (-not ([System.Management.Automation.PSTypeName]'ServerCertificateValidationCallback').Type) {
            Write-PscriboMessage "Setting policy to ignore self signed certificate warnings"
            $certCallback = @"
            using System;
            using System.Net;
            using System.Net.Security;
            using System.Security.Cryptography.X509Certificates;
            public class ServerCertificateValidationCallback
            {
                public static void Ignore()
                {
                    if(ServicePointManager.ServerCertificateValidationCallback ==null)
                    {
                        ServicePointManager.ServerCertificateValidationCallback +=
                            delegate
                            (
                                Object obj,
                                X509Certificate certificate,
                                X509Chain chain,
                                SslPolicyErrors errors
                            )
                            {
                                return true;
                            };
                    }
                }
            }
"@
            Add-Type $certCallback
        }
        [ServerCertificateValidationCallback]::Ignore()
        [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
        #endregion Workaround for SelfSigned Cert an force TLS 1.2 

        #Convert username and password into basic auth header
        $username = $Credential.UserName
        $password = $Credential.GetNetworkCredential().Password
        $auth = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($username + ":" + $password ))
        $headers = @{
            'Authorization' = "Basic $auth"
        }
        #Setup base API URLs
        $systemUrl = "https://" + $System + "/"
    }

    Process {
        #clean up uri to remove leading "/"
        $uri = $uri.TrimStart("/")    
        $url = $systemUrl + $uri 
        Try {
            Invoke-Restmethod -Method $method -uri $url -Headers $headers -UseBasicParsing
        } Catch {
            Write-PscriboMessage -Message "Error with API reference call to $(($URI).TrimStart('/'))"
            Write-PscriboMessage -Message $_
        }
    }
    End {}
}