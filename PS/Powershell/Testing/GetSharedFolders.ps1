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

#--SETUP--
$Path = "C:\techrunnerit"
$FileName = "SharedFolderRecon.csv"
$FilePath = $Path + "\" + $FileName
$Output = [System.Collections.ArrayList]@()

If (!(Test-Path $Path)) {
    New-Object -ItemType Directory -Path $Path
}

#--GET SHARES--
Write-Host "Working..." -ForegroundColor Cyan
$Shares = get-WmiObject -class Win32_Share | Where-Object {$_.Name -NotLike '*IPC*'} | Select -Property Name, Path
#--GET PERMISSIONS--
Foreach ($Share in $Shares) {
    $Permissions = Get-Acl -Path $Share.Path -ErrorAction SilentlyContinue
    Foreach ($Permission in $Permissions) {
        Foreach ($Property in $Permission.Access) {
            $Row = $Share.PSObject.Copy()
            $Row | Add-Member -Type NoteProperty -Name "User" -Value $Property.IdentityReference
            $Row | Add-Member -Type NoteProperty -Name "Permissions" -Value $Property.FileSystemRights

            #Write-Host $Property.IdentityReference -ForegroundColor Green
            #Write-Host $Property.FileSystemRights -ForegroundColor Cyan

            $Output.add($Row) | Out-Null
        }
    }
}

Try {
    $Output | Export-Csv $FilePath
    Write-Host ("Wrote report to " + $FilePath + ".") -ForegroundColor Green
} Catch {
    Write-Warning "Couldn't output file."
}