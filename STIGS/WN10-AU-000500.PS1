<#
.SYNOPSIS
    This PowerShell script ensures that the maximum size of the Windows Application event log is at least 32768 KB (32 MB).

.NOTES
    Author          : Vaughn Veal
    LinkedIn        : https://www.linkedin.com/in/vlryn-veal-050420306/
    GitHub          : github.com/vveal1
    Date Created    : 2025-8-15
    Last Modified   : 2025-08-15
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AU-000500

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\__remediation_template(STIG-ID-WN10-AU-000500).ps1 
#>

# Define registry path and value information
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application"
$valueName = "MaxSize"
$desiredValue = 32768  # 32 MB in KB

# Ensure the registry path exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Get current value (if it exists)
$currentValue = (Get-ItemProperty -Path $regPath -Name $valueName -ErrorAction SilentlyContinue).$valueName

# If the value doesn't exist or is smaller than desired, set or update it
if (-not $currentValue -or $currentValue -lt $desiredValue) {
    New-ItemProperty -Path $regPath -Name $valueName -Value $desiredValue -PropertyType DWord -Force | Out-Null
    Write-Host "Registry value '$valueName' set to $desiredValue (KB) under $regPath"
} else {
    Write-Host "Registry value '$valueName' already exists and is >= $desiredValue (KB). No change needed."
}
