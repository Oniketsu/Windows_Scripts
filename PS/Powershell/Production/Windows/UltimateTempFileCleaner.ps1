# Get users
$users = Get-ChildItem -Path "C:\Users"


# Loop through users and delete temp files
ForEach ($user in $users){

    $name=$user.fullname
    ri -Path "$name\AppData\Local\Temp\*" -Recurse -Force
    ri -Path "$name\AppData\Local\Microsoft\Windows\Temporary Internet Files\*" -Recurse -Force
    ri -Path "$name\Appdata\Local\Microsoft\Windows\INetCache\IE\*" -Recurse -Force
    ri -Path "$name\AppData\Roaming\Microsoft\Windows\Recent Items\*" -Recurse -Force
    ri -Path "$name\AppData\LocalLow\Sun\Java\Deployment\cache\6.0\*" -Recurse -Force
    ri -Path "$name\AppData\LocalLow\Sun\Java\Deployment\cache\7.0\*" -Recurse -Force
    ri -Path "$name\AppData\LocalLow\Sun\Java\Deployment\cache\8.0\*" -Recurse -Force
    ri -Path "$name\AppData\Adobe\Flash Player\*" -Recurse -Force
    ri -Path "$name\AppData\Adobe\Macromedia\Flash Player\*" -Force
}

ri -Path "c:\windows\temp\" -Recurse -Force
ri -Path "c:\windows\tmp\" -Recurse -Force
ri -Path "c:\windows\prefetch\" -Recurse -Force
ri -Path "c:\windows\softwaredistribution\download\" -Recurse -Force
ri -Path "c:\ProgramData\NinjaRMMAgent\Download\" -Recurse -Force
Get-ChildItem -Path C:\Windows\Logs\CBS -Recurse | Where-Object {($_.Name -like "*CbsPersist*.*") -and ($_.LastWriteTime -lt ((Get-Date).AddDays(-7)))} | ri -Force