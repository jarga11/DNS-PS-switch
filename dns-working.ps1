# Flush DNS resolver cache
ipconfig /flushdns

# Define color codes
$red = "Red"
$yellow = "Yellow"
$reset = "White"
$blue = "Blue"

# Get a list of network interfaces and their IP addresses
$interfaces = Get-NetAdapter | Where-Object {$_.Status -eq "Up"} | Select-Object Name, InterfaceIndex, Status, MacAddress, LinkSpeed, ifIndex, DriverInformation, @{Name="IPv4 Address"; Expression={$_.IPv4Address.IPAddress}}

# Print list of interfaces and assign numbers to them
Write-Host -ForegroundColor $yellow "Available Interfaces:"
$i = 1
$interfaces | ForEach-Object {
    Write-Host -ForegroundColor $yellow "$i. $($_.Name) - $($_.'IPv4 Address')"
    $i++
}

# Prompt user to select an interface and capture input

Write-Host -ForegroundColor $blue "Enter the number of the interface to configure DNS"
$interfaceIndex = Read-Host
#$interfaceIndex = Read-Host -ForegroundColor $yellow "Enter the number of the interface to configure DNS"
# Select the interface by index
$interfaceName = $interfaces[($interfaceIndex-1)].Name

# Display current DNS addresses for the selected interface
$currentDNSServers = Get-DnsClientServerAddress -InterfaceAlias $interfaceName | Where-Object {$_.ServerAddresses -ne "127.0.0.1"}
if ($currentDNSServers) {
    Write-Host -ForegroundColor $yellow "Current DNS addresses for interface $($interfaceName) :"
    $currentDNSServers.ServerAddresses
} else {
    Write-Host -ForegroundColor $red "No DNS servers configured for interface $interfaceName"
}

# Offer user a choice of DNS options

#$dnsOption = Read-Host -ForegroundColor $yellow "Enter 'D' for dynamic DNS or 'S' for static DNS"
 
Write-host -ForegroundColor $yellow "Enter 'D' for dynamic DNS or 'S' for static DNS or X to EXIT"
$dnsOption = Read-Host


# Configure DNS based on user's selection
if ($dnsOption -eq "D") {
    # Configure dynamic DNS
    Write-Host -ForegroundColor $yellow "Configuring dynamic DNS for interface $interfaceName"
    Set-DnsClientServerAddress -InterfaceAlias $interfaceName -ResetServerAddresses
    # Display current DNS addresses for the selected interface after setting dynamic DNS
    $currentDNSServers = Get-DnsClientServerAddress -InterfaceAlias $interfaceName | Where-Object {$_.ServerAddresses -ne "127.0.0.1"}
    if ($currentDNSServers) {
        Write-Host -ForegroundColor $yellow "Current DNS addresses for interface $($interfaceName):"
        $currentDNSServers.ServerAddresses
    } else {
        Write-Host -ForegroundColor $red "No DNS servers configured for interface $interfaceName"
    }
    
} elseif ($dnsOption -eq "S") {
    # Configure static DNS
    Write-Host -ForegroundColor $yellow "Configuring static DNS for interface $interfaceName"
    $dnsServers = "8.8.8.8","1.1.1.1"
    $dnsServersString = $dnsServers -join ","
    Set-DnsClientServerAddress -InterfaceAlias $interfaceName -ServerAddresses $dnsServersString
    #Pause
    # Display current DNS addresses for the selected interface after setting static DNS
    #$currentDNSServers = Get-DnsClientServerAddress -InterfaceAlias $interfaceName | Where-Object {$_.ServerAddresses -ne "127.0.0.1"}
    # Pause for 5 seconds
    #Start-Sleep -Seconds 5
    Write-Host -ForegroundColor $yellow "Current DNS addresses for interface $($interfaceName):"
    #Pause
    
# Flush DNS resolver cache
#ipconfig /flushdns
#        $currentDNSServers.ServerAddresses
# Flush DNS resolver cache
#ipconfig /flushdns
        $currentDNSServers.ServerAddresses

   


} elseif ($dnsOption -eq "X") {
    # Configure static DNS
    Write-Host -ForegroundColor $blue "No Changes" EXIT
}