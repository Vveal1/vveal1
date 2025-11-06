<#
.SYNOPSIS
    This PowerShell script ensures that the Camera access from the lock screen must be disabled.

.NOTES
    Author          : Vaughn Veal
    LinkedIn        : https://www.linkedin.com/in/vlryn-veal-050420306/
    GitHub          : github.com/vveal1
    Date Created    : 2025-10-5
    Last Modified   : 2025-10-5
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000005 

.TESTED ON
    Date(s) Tested  : 
    Tested By       : Vaughn Veal
    Systems Tested  : Win/10
    PowerShell Ver. : Admin

.USAGE
    PS C:\> .\__remediation_template(STIG-ID-WN10-CC-000005).ps1 
#>

 registry path and value information
PowerShell:
# Define registry path and value
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
$valueName = "NoLockScreenCamera"
$valueData = 1  # 1 disables the lock screen camera

# Create the registry key if it does not exist
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Create or update the DWORD value
New-ItemProperty -Path $regPath -Name $valueName -Value $valueData -PropertyType DWord -Force

# Confirm the registry value
$check = Get-ItemProperty -Path $regPath -Name $valueName
Write-Host "Registry value '$valueName' is now set to $($check.$valueName) at $regPath"
