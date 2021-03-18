Function Get-BasicADObject 
{ 
<# 
    .SYNOPSIS  
        Function allow to get AD object info without AD Module. 
 
    .DESCRIPTION  
        Use Get-OwnADObject to get information about Active Directory object's. 
 
    .PARAMETER Filter  
        Filter objects, default search information about users. 
 
    .PARAMETER $Ldap 
        LDAP Path to object. 
         
    .EXAMPLE  
        Get-OwnADObject -SearchRoot 'dc=domain,dc=com'| Export-Csv C:\ADObj.csv -NoTypeInformation 
 
    .NOTES  
        Author: Michal Gajda  
#> 
    [CmdletBinding( 
        SupportsShouldProcess=$True, 
        ConfirmImpact="Low" 
    )] 
    param 
    ( 
        [String]$Ldap = "dc="+$env:USERDNSDOMAIN.replace(".",",dc="),         
        [String]$Filter = "(&(objectCategory=person)(objectClass=user))" 
    ) 
 
    Begin{} 
 
    Process 
    { 
        if ($pscmdlet.ShouldProcess($Ldap,"Get information about AD Object")) 
        { 
            $searcher=[adsisearcher]$Filter 
             
            $Ldap = $Ldap.replace("LDAP://","") 
            $searcher.SearchRoot="LDAP://$Ldap" 
            $results=$searcher.FindAll() 
     
            $ADObjects = @() 
            foreach($result in $results) 
            { 
                [Array]$propertiesList = $result.Properties.PropertyNames 
                $obj = New-Object PSObject 
                foreach($property in $propertiesList) 
                {  
                    $obj | add-member -membertype noteproperty -name $property -value ([string]$result.Properties.Item($property)) 
                } 
                $ADObjects += $obj 
            } 
       
            Return $ADObjects 
        } 
    } 
     
    End{} 
} 

Get-BasicADObject -SearchRoot 'dc=domain,dc=com'| Export-Csv C:\ADObj.csv -NoTypeInformation