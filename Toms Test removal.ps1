<# 
Script stolen from different sources, patched together by Tom - ask if you dont understand stuff, let me know if it can be written better.
Apps removed:
 - OneNote for Windows 10
 - Wallet
 - Mail and Calendar
 - Solitaire
 - People
 - Messaging
/#>

#The below is so that i can elevate the powershell script to admin level and set to bypass#

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine

Read-Host -Prompt "press any key to continue"


#Creating the AppxPackageName array for app names to be removed CHECK THESE BEFORE ADDING INTO THIS SCRIPT#

$AppxPackageNames = @(  
                    'Microsoft.windowscommunicationapps'
                    'Microsoft.Office.OneNote'
                    'Microsoft.MicrosoftSolitaireCollection'
                    'Microsoft.People'
                    'Microsoft.Messaging'
                    'Microsoft.Wallet'
                        )

#Creating the foreach loop syntax "foreach { <variable> in <collection>}"

foreach ( $AppxPackage in $AppxPackageNames)
{
    Write-Output "Removing $AppxPackage"
    if(Get-AppxPackage $AppxPackage | Remove-AppxPackage)
        {
        Get-AppxPackage $AppxPackage | Remove-AppxPackage -AllUsers -Verbose -ErrorAction Continue
        }

    else
        {
        Write-Output "$AppxPackage Is not installed for any User"

        }

    if(Get-ProvisionedAppxPackage -Online | Where-Object {$_.DisplayName -Match $AppxPackage})
        {
        Get-ProvisionedAppxPackage -Online | Where-Object {$_.DisplayName -match $AppxPackage} | Remove-AppxProvisionedPackage -Online -Allusers -Verbose _errorAction Contine
        }

    else
        {
        Write-Output "$AppxPackage is not installed for the system"
        }
}

#Setting execution policy to the correct default for the machine after removing apps#

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy RemoteSigned -File `"$PSCommandPath`"" -Verb RunAs; exit }

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine

Write-Host "Thanks for using the script, if you did not get any errors, all of the applications should now be removed. Press Enter to continue or CTRL + C to quit"