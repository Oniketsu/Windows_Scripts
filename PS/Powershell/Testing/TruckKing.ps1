#############################################################################
#If Powershell is running the 32-bit version on a 64-bit machine, we 
#need to force powershell to run in 64-bit mode .
#############################################################################
if ($env:PROCESSOR_ARCHITEW6432 -eq "AMD64") {
    write-warning "Y'arg Matey, we're off to 64-bit land....."
    if ($myInvocation.Line) {
        &"$env:WINDIR\sysnative\windowspowershell\v1.0\powershell.exe" -NonInteractive -NoProfile $myInvocation.Line
    }else{
        &"$env:WINDIR\sysnative\windowspowershell\v1.0\powershell.exe" -NonInteractive -NoProfile -file "$($myInvocation.InvocationName)" $args
    }
exit $lastexitcode
}

#--SETUP--;
$RegPath = "HKCU:SOFTWARE\Policies\Microsoft\Internet Explorer\BrowserEmulation\PolicyList\";
#$RegPath = "HKCU:Software\Microsoft\Internet Explorer\BrowserEmulation\ClearableListData\UserFilter";
$Sites = "internationaldelivers.com", "navistar.com", "fusonet.com";
$Directory = "C:\techrunnerit"
$Identifiers = ".htm", ".html", ".pdf", ".url", ".website", "http", "https", "mailto"
$ProgIds = "htmlfile", "htmlfile", "AcroExch.Document.DC", "IE.AssocFile.URL", "IE.AssocFile.WEBSITE", "IE.HTTP", "IE.HTTPS", "Outlook.URL.mailto.15"
$ApplicationNames = "Internet Explorer", "Internet Explorer", "Adobe Acrobat Reader DC", "Internet Browser", "Internet Explorer", "Internet Explorer", "Internet Explorer", "Outlook 2016"

#--WRITE XML FILE--;
Write-Host "Preparing .XML file..." -ForegroundColor Cyan;

Try {
$XMLPath = "$Directory\Defaults.xml"

$Encoding = New-Object System.Text.UTF8Encoding ($true)
$xmlWriter = New-Object System.Xml.XmlTextWriter($XMLPath,$Encoding)
$xmlWriter.Formatting = 'Indented'
$xmlWriter.Indentation = 1
$xmlWriter.IndentChar = "`t"
$xmlWriter.WriteStartDocument()
$xmlWriter.WriteStartElement('DefaultAssociations')
$xmlWriter.WriteEndElement()
$xmlWriter.WriteEndDocument()
$xmlWriter.Flush()
$xmlWriter.Close()

$xmlDoc = [System.Xml.XmlDocument](Get-Content $XMLPath)
$AssociationNode = $xmlDoc.CreateElement("Association")
For ($i = 0; $i -lt $Identifiers.Length; $i++) {
    $xmlDoc = [System.Xml.XmlDocument](Get-Content $XMLPath)
    $AssociationNode = $xmlDoc.CreateElement("Association")
    $xmlDoc.SelectSingleNode("//DefaultAssociations").AppendChild($AssociationNode)
    $AssociationNode.SetAttribute("Identifier", $Identifiers[$i])
    $AssociationNode.SetAttribute("ProgId", $ProgIds[$i])
    $AssociationNode.SetAttribute("ApplicationName", $ApplicationNames[$i])
    If (($i -eq 0) -or ($i -eq 1)){
        $Overwrite = "AppX4hxtad77fbk3jkkeerkrm0ze94wjf3s9"
        $AssociationNode.SetAttribute("ApplyOnUpgrade", "true")
        $AssociationNode.SetAttribute("OverwriteIfProgIdIs", $Overwrite)
    }
    Elseif ($i -eq 2){
        $Overwrite = "AppXd4nrz8ff68srnhf9t5a8sbjyar1cr723"
        $AssociationNode.SetAttribute("ApplyOnUpgrade", "true")
        $AssociationNode.SetAttribute("OverwriteIfProgIdIs", $Overwrite)
    }
    Elseif ($i -eq 5){
        $Overwrite = "AppXq0fevzme2pys62n3e0fbqa7peapykr8v"
        $AssociationNode.SetAttribute("ApplyOnUpgrade", "true")
        $AssociationNode.SetAttribute("OverwriteIfProgIdIs", $Overwrite)
    }
    Elseif ($i -eq 6){
        $Overwrite = "AppX90nv6nhay5n6a98fnetv7tpk64pp35es"
        $AssociationNode.SetAttribute("ApplyOnUpgrade", "true")
        $AssociationNode.SetAttribute("OverwriteIfProgIdIs", $Overwrite)
    }
    $xmlDoc.Save($XMLPath)

}

Write-Host ".XML file created." -ForegroundColor Green
}
Catch {
    Write-Warning "Couldn't create .XML file."
}

#--IMPORT XML FILE--
$cmd = 'dism /online /Import-DefaultAppAssociations:"' + $XMLPath + '"'

Write-Host "Importing defaults from .XML file..." -ForegroundColor Cyan

Try {
    Invoke-Expression -Command $cmd
}
Catch {
    Write-Warning "Couldn't import defaults."
}

#--APPLY IE COMPATIBILITY SETTINGS--;
Foreach ($Site in $Sites) {
    Try {
        Write-Host "Adding $Site to IE compatibility list..." -ForegroundColor Cyan;
        New-Item -Path $RegPath -Name $Site -Value $Site -Force;
        Write-Host "Added $Site to IE compatibility list." -ForegroundColor Green;
    }
    Catch {
        Write-Warning "Couldn't add $Site to IE compatibility list.";
    }
}