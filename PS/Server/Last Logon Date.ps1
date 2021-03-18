$ask = Read-Host -Prompt 'Input Hostname'
Get-ADComputer -Identity $ask -Properties CN, Lastlogondate