Import-module ActiveDirectory  
Get-ADUser -Filter * -SearchBase "OU=Zara Realty,DC=domain, DC=zara2005, DC=com" | Set-ADUser -Clear scriptPath 