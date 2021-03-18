$Folders = get-mailbox "jmckeon@useinc.com" | select-object alias | foreach-object {get-mailboxfolderstatistics -Identity $_.alias | where {$_.Identity -like '*Contacts*'} | select-object Identity, ItemsInFolder, FolderSize}

Foreach ($Folder in $Folders) {
    New-MailboxImportRequest -Mailbox $Mailbox.Name -FilePath ($ImportPath + "\" + $Mailbox.Name + ".pst") -IncludeFolders $Folder.Identity
}