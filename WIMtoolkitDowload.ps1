if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Output "WIMToolkit necessita di essere lanciato come Amministratore. Riavvio."
    Start-Process -Verb runas -FilePath powershell.exe -ArgumentList "irm -Uri https://raw.githubusercontent.com/AMStore-server/WIMToolkit/refs/heads/main/WIMtoolkitDowload.ps1 | iex"
    break
}

Remove-Item -Path "C:\WIMToolkit" -Recurse -Force | out-null

# Change to the desktop directory
cd "C:\"

# Download the script from GitHub
Invoke-WebRequest -Uri "https://github.com/AMStore-server/WIMToolkit/archive/refs/heads/main.zip" -OutFile "WIMToolkit-main.zip"

Expand-Archive -Path "WIMToolkit-main.zip" -DestinationPath "." -Force

Move-Item -Path "WIMToolkit-main" -Destination "WIMToolkit" -Force

Remove-Item -Path "WIMToolkit-main.zip" -Force

Start-Process -FilePath ".\WIMToolkit\WIMToolkit.bat"
