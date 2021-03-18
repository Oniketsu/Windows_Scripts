if (!(Test-Path "C:\windows\perfc"))
{
	New-Item -path C:\Windows -name perfc -type "file" -value "petya vac"
   
	$file = Get-Item "C:\windows\perfc"

	if ($file.IsReadOnly -eq $false)  
	{  
	  $file.IsReadOnly = $true   
	}  
}

if (!(Test-Path "C:\windows\perfc.dll"))
{
   New-Item -path C:\Windows -name perfc.dll -type "file" -value "petya vac"
   
   	$file = Get-Item "C:\windows\perfc.dll"

	if ($file.IsReadOnly -eq $false)  
	{  
	  $file.IsReadOnly = $true   
	}  
}

if (!(Test-Path "C:\windows\perfc.dat"))
{
   New-Item -path C:\Windows -name perfc.dat -type "file" -value "petya vac"
   
   	$file = Get-Item "C:\windows\perfc.dat"

	if ($file.IsReadOnly -eq $false)  
	{  
	  $file.IsReadOnly = $true   
	}  
}

