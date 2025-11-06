<#
.SYNOPSIS
    This PowerShell script ensures that user can sign in using a convenience PIN to prevent enabling (Password Stuffer).

.NOTES
    Author          : Vaughn Veal
    LinkedIn        : https://www.linkedin.com/in/vlryn-veal-050420306/
    GitHub          : github.com/vveal1
    Date Created    : 2025-10-4
    Last Modified   : 2025-10-5
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000370 

.TESTED ON
    Date(s) Tested  : 
    Tested By       : Vaughn Veal
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Example syntax:
    PS C:\> .\__remediation_template(STIG-ID-WN10-CC-000370).ps1 
#>

 registry path and value information
# Disable "Turn on convenience PIN sign-in" (STIG ID: WN10-CC-000370)
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Force | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "AllowDomainPINLogon" -PropertyType DWord -Value 0 -Force | Out-Null

Write-Host "Convenience PIN sign-in has been disabled per STIG WN10-CC-000370." -ForegroundColor Green
