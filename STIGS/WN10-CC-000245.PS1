<#
.SYNOPSIS
    This PowerShell script ensures that The password manager function in the Edge browser is disabled.

.NOTES
    Author          : Vaughn Veal
    LinkedIn        : https://www.linkedin.com/in/vlryn-veal-050420306/
    GitHub          : github.com/vveal1
    Date Created    : 2025-10-5
    Last Modified   : 2025-10-5
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000245

.TESTED ON
    Date(s) Tested  : 
    Tested By       : Vaughn Veal
    Systems Tested  : Win-10
    PowerShell Ver. : Admin



 registry path and value information
Powershell Script will disable password manager function
<#
.SYNOPSIS
  Create / update HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main\ "FormSuggest Passwords"

.DESCRIPTION
  Creates the registry key if missing and creates/updates the value "FormSuggest Passwords".
  Default property type is DWord and default value is 0. You can pass a different value and type.

.PARAMETER Value
  The value to write. Default: 0

.PARAMETER PropertyType
  Registry property type. Typical choices: DWord, String, QWord, Binary, MultiString.
  Default: DWord

.EXAMPLE
  # Disable (0)
  .\Set-EdgeFormSuggestPasswords.ps1 -Value 0

  # Enable (1)
  .\Set-EdgeFormSuggestPasswords.ps1 -Value 1

  # Write as string
  .\Set-EdgeFormSuggestPasswords.ps1 -Value "Disabled" -PropertyType String
#>

param(
    [Parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [object]$Value = 0,

    [Parameter(Mandatory=$false)]
    [ValidateSet("String","DWord","QWord","Binary","MultiString")]
    [string]$PropertyType = "DWord"
)

function Ensure-Admin {
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
    if (-not $isAdmin) {
        Write-Error "This script must be run as Administrator. Right-click PowerShell and choose 'Run as administrator'."
        exit 1
    }
}

Ensure-Admin

$basePath = 'HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge'
$mainPath = Join-Path $basePath 'Main'
$valueName = 'FormSuggest Passwords'

# Create base key(s) if missing
if (-not (Test-Path $basePath)) {
    New-Item -Path $basePath -Force | Out-Null
    Write-Verbose "Created key: $basePath"
}
if (-not (Test-Path $mainPath)) {
    New-Item -Path $mainPath -Force | Out-Null
    Write-Verbose "Created key: $mainPath"
}

# Convert value to appropriate CLR type when using DWord/QWord
switch ($PropertyType) {
    "DWord" {
        # Accept booleans and common numeric strings
        if ($Value -is [System.Boolean]) { $conv = [int]$Value }
        else { $conv = [int]$Value }
        $writeValue = $conv
    }
    "QWord" {
        $writeValue = [long]$Value
    }
    "MultiString" {
        if ($Value -isnot [System.Array]) { $writeValue = @($Value) } else { $writeValue = $Value }
    }
    "Binary" {
        # If user provided hex-like string, attempt to convert, otherwise try to accept byte[] already provided
        if ($Value -is [string]) {
            # remove 0x and commas/spaces
            $hex = $Value -replace '0x','' -replace '[,\s]',''
            $bytes = for ($i=0; $i -lt $hex.Length; $i+=2) { [byte]::Parse($hex.Substring($i,2), 'HexNumber') }
            $writeValue = ,$bytes
        } else { $writeValue = $Value }
    }
    default {
        $writeValue = $Value
    }
}

# Write the value (New-ItemProperty -Force will create or update)
try {
    New-ItemProperty -Path $mainPath -Name $valueName -Value $writeValue -PropertyType $PropertyType -Force | Out-Null
    Write-Host "Successfully set '$valueName' at '$mainPath' to '$writeValue' (Type: $PropertyType)."
} catch {
    Write-Error "Failed to set registry value: $_"
    exit 1
}

# Verify
try {
    $result = Get-ItemProperty -Path $mainPath -Name $valueName -ErrorAction Stop
    Write-Host "Verification:"
    $result | Select-Object -Property PSPath, $valueName
} catch {
    Write-Warning "Could not read back the registry value for verification: $_"
}
