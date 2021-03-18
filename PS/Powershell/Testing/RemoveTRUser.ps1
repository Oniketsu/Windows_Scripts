$UserName = "techrunnerit"

If (Get-LocalUser -Name "$UserName" -ErrorAction SilentlyContinue){
    Try
    {
        Write-Host "Removing $UserName user..."
        $compName = $env:COMPUTERNAME
        $cn = [ADSI]"WinNT://$compName"
        $user = $cn.Delete("User", $userName)
        Write-Host "Removed $UserName user successfully." -ForegroundColor Green
    }
    Catch
    {
        Write-Host "Couldn't remove user $UserName." -ForegroundColor Red
    }
}
Else
{
    Write-Host "User $UserName doesn't exist." -ForegroundColor Red
}