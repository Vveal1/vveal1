<#
.SYNOPSIS
    This PowerShell script ensures that Powershell Transcription must be enabled on Windows 10 to run

.NOTES
    Author          : Vaughn Veal
    LinkedIn        : https://www.linkedin.com/in/vlryn-veal-050420306/
    GitHub          : github.com/vveal1
    Date Created    : 2025-10-5
    Last Modified   : 2025-10-5
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000327

.TESTED ON
    Date(s) Tested  : 
    Tested By       : Vaughn Veal
    Systems Tested  : Win-10
    PowerShell Ver. : Regular



 registry path and value information
Powershell Script that will enable transcription

# Define the registry path
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription"

# Create the registry key if it doesn't exist
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the EnableTranscripting value to 1 (DWORD)
Set-ItemProperty -Path $regPath -Name "EnableTranscripting" -Value 1 -Type DWord

# Verify the change
Get-ItemProperty -Path $regPath
