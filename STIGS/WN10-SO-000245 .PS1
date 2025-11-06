<#
.SYNOPSIS
    This PowerShell script ensures that the User Account Control approval mode for the built-in Administrator must be enabled.

.NOTES
    Author          : Vaughn Veal
    LinkedIn        : https://www.linkedin.com/in/vlryn-veal-050420306/
    GitHub          : github.com/vveal1
    Date Created    : 2025-11-5
    Last Modified   : 2025-11-5
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-SO-000245

.TESTED ON
    Date(s) Tested  : 
    Tested By       : Vaughn Veal
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    If this runs 1 then the policy is configured correctly(Enabled)
    (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System").FilterAdministratorToken

#>
PowerShell Command:
 # Enables Admin Approval Mode for the Built-in Administrator account
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" `
  -Name "FilterAdministratorToken" -Value 1 -Type DWord
