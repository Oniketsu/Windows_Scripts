$InstalledApps = Get-AppxPackage -AllUsers | Select Name #, PackageFullName
$AppList = @(
    # default Windows 10 apps
    "Microsoft.3DBuilder"
    "*alarms*"
    "Microsoft.Appconnector"
    "Microsoft.BingFinance"
    "Microsoft.BingNews"
    "Microsoft.BingSports"
    "Microsoft.BingWeather"
    #"*calculator*"
    "*camera*"
    #"*communications*"
    "Microsoft.Getstarted"
    "Microsoft.MicrosoftOfficeHub"
    #"Microsoft.MicrosoftSolitaireCollection"
    "Microsoft.Office.OneNote"
    "Microsoft.People"
    "Microsoft.SkypeApp"
    "Microsoft.WindowsMaps"
    "Microsoft.WindowsPhone"
    "Microsoft.WindowsSoundRecorder"
    "Microsoft.WindowsStore"
    "Microsoft.XboxApp"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"
    "microsoft.windowscommunicationsapps"
    "Microsoft.CommsPhone"
    "Microsoft.ConnectivityStore"
    #"Microsoft.Messaging"
    "Microsoft.Office.Sway"
    "*Microsoft.WindowsFeedback*"
    "*skypeapp*"
    "*maps*"
    #"*WindowsScan*"
    #"soundrecorder"
    "*windowsalarms*"
    "*windowsstore*"    

   #Candy Crush
   "*CandyCrushSodaSaga*"
   "*CandyCrush*"
   "*CandyCrushSaga*" 

   #Minecraft
   "Microsoft.MinecraftUWP"

  #XBox
  "*xbox*"
  "*xboxapp*"
  "*XboxOneSmartGlass*"
  "Microsoft.XboxIdentityProvider"           
  "Microsoft.XboxApp"
  "Microsoft.XboxGameCallableUI"         

  # non-Microsoft
  "*Twitter*"
  "9E2F88E3.Twitter"
  "Flipboard.Flipboard"
  "ShazamEntertainmentLtd.Shazam"    
  "ClearChannelRadioDigital.iHeartRadio"

  # apps which cannot be removed using Remove-AppxPackage
  #"Microsoft.BioEnrollment"
  #"Microsoft.MicrosoftEdge"
  #"Microsoft.Windows.Cortana"
  #"Microsoft.WindowsFeedback"
  #"Microsoft.XboxGameCallableUI"
  #"Microsoft.XboxIdentityProvider"
  #"Windows.ContactSupport"
 )

Write-Host"Starting app scan..."

foreach($appfound in $InstalledApps){
    foreach($possibleapp in $AppList){
        if ($appfound -like "*$possibleapp*"){
             Write-Host "$appfound was spotted and removed"

             Get-AppxPackage -Name $possibleapp -AllUsers | Remove-AppxPackage

             Get-AppXProvisionedPackage -Online |
             where DisplayName -EQ $possibleapp |
             Remove-AppxProvisionedPackage -Online
        }
    }
}