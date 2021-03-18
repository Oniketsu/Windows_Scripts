$adminUPN="replace_with_username"

$orgName="needtechinc"

$usercredential = Get-Credential -username $adminUPN -Message "type password"

Connect-SPOService -Url https://$orgName-admin.sharepoint.com -Credential $userCredential