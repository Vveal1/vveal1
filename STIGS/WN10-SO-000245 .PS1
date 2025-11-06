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
# Define the registry path and value details
$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$ValueName = "FilterAdministratorToken"
$ValueType = "DWORD"
$ValueData = 1  # Common STIG-compliant setting (Enabled)

# Check if the registry path exists, if not create it
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Create or update the registry value
New-ItemProperty -Path $RegPath -Name $ValueName -PropertyType $ValueType -Value $ValueData -Force

# Confirm the change
Write-Host "Registry value '$ValueName' set to $ValueData at $RegPath"

