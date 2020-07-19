 <#
 
.SYNOPSIS
  This script will unhide PowerShell which is started with the parameter "-windowstyle hidden".
 
.DESCRIPTION
 
  This script will unhide PowerShell which is started with the parameter "-windowstyle hidden".
 
.PARAMETER
 
  None
 
.INPUTS
 
  An input file is used for the e-mail addresses
 
.OUTPUTS
 
  Output will be shown in the console
 
.NOTES
 
  Version:        0.1
  Author:         R. Roethof
  Creation Date:  11/12/2019
  Purpose/Change: Initial script development
 
.EXAMPLE
 
  .\Invoke-unhidePowerShell.ps1
 
#>
 
#------------------------------------------[Initialisations]---------------------------------------
 
# Set Error Action to Silently Continue
$ErrorActionPreference = "SilentlyContinue"
 
#-------------------------------------------[Declarations]-----------------------------------------
 
# Script Name and Version
$scriptName = $MyInvocation.MyCommand.Name
$scriptVersion = "0.1"
 
# Variables that need to be set
 
#--------------------------------------------[Functions]-------------------------------------------
 
Function RR-unhidePowerShell {
    Param()
 
    Begin {
        Write-Host "  Start unhide PowerShell..."
    }
 
    Process {
      $code = @"

      [DllImport("user32.dll", SetLastError=true)]
      public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint lpdwProcessId);

      [DllImport("user32.dll")]
      public static extern IntPtr GetTopWindow(IntPtr hWnd);

      [DllImport("user32.dll", SetLastError = true)]
      public static extern IntPtr GetWindow(IntPtr hWnd, uint uCmd);

      [DllImport("user32.dll", CharSet = CharSet.Unicode)]
      public static extern IntPtr FindWindow(IntPtr sClassName, String sAppName);

      [DllImport("user32.dll")] 
      public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);

"@

      if (-not ([System.Management.Automation.PSTypeName]'ThalpiusClassName').Type) {
        Add-Type -MemberDefinition $code -Namespace Thalpius -Name Class -Language CSharp
      }

      try {
        $getProccesses = Get-Process PowerShell -ErrorAction Stop | %{$_.ID}
      }
      catch {
        Write-Host "No PowerShell processes found!"
      }

      $i = 0
      $topWindow = [Thalpius.Class]::GetTopWindow(0)

      while ($topWindow -ne 0) {
        [Thalpius.Class]::GetWindowThreadProcessId($topWindow, [ref]$i) | Out-Null
        if ($getProccesses -contains $i) {
          [Thalpius.Class]::ShowWindowAsync($topWindow, 5) | Out-Null
        }
        $topWindow = [Thalpius.Class]::GetWindow($topWindow, 2)
      }
    }
 
    End {
        If ($?) {
            Write-host "  Unhide PowerShell completed successfully..."
        }
    }
}
 
#--------------------------------------------[Execution]-------------------------------------------
 
Write-Host "$scriptName version $scriptVersion started at $(Get-Date)"
  RR-unhidePowerShell
Write-host "$scriptName version $scriptVersion ended at $(Get-Date)" 
