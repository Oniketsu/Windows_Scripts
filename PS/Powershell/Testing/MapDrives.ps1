#--SETUP--
$DriveS = "\\172.30.0.10\Office"
$DriveT = "\\172.30.0.10\Scans"
$CommandS = ("net use S: " + $DriveS + " /persistent:yes")
$CommandT = ("net use T: " + $DriveT + " /persistent:yes")

#--MAP DRIVES--
Invoke-Expression -Command $CommandS | Out-Null
Invoke-Expression -Command $CommandT | Out-Null
Invoke-Expression -Command "net use Z: /del" | Out-Null