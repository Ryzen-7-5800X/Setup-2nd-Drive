# ================================
# D: als standaard data-schijf
# (gebruikersmappen verplaatsen)
# ================================

# 1. Check of D: bestaat
if (-not (Test-Path "D:\")) {
    Write-Host "D:\ bestaat niet. Stop. Maak eerst een D-schijf aan." -ForegroundColor Red
    exit 1
}

Write-Host "D:\ gevonden, verdergaan..." -ForegroundColor Green

# 2. Basisvariabelen
$userName   = $env:USERNAME
$baseUserD  = "D:\Users\$userName"

# 3. Mappen op D: aanmaken
$folders = @(
    "$baseUserD\Desktop",
    "$baseUserD\Documents",
    "$baseUserD\Downloads",
    "$baseUserD\Pictures",
    "$baseUserD\Music",
    "$baseUserD\Videos"
)

foreach ($folder in $folders) {
    if (-not (Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder | Out-Null
        Write-Host "Map aangemaakt: $folder"
    } else {
        Write-Host "Bestaat al: $folder"
    }
}

# 4. Registry: User Shell Folders aanpassen
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"

# Mapping: registry key -> nieuwe locatie
$map = @{
    "Desktop"                               = "$baseUserD\Desktop"
    "Personal"                              = "$baseUserD\Documents"   # Documenten
    "{374DE290-123F-4565-9164-39C4925E467B}" = "$baseUserD\Downloads"  # Downloads
    "My Pictures"                           = "$baseUserD\Pictures"
    "My Music"                              = "$baseUserD\Music"
    "My Video"                              = "$baseUserD\Videos"
}

foreach ($key in $map.Keys) {
    $value = $map[$key]
    Set-ItemProperty -Path $regPath -Name $key -Value $value -Type ExpandString
    Write-Host "Registry aangepast: $key -> $value"
}

Write-Host ""
Write-Host "Gebruikersmappen staan nu naar D:. Je moet even uit- en opnieuw inloggen," `
           "of de pc herstarten, zodat Windows de nieuwe locaties gaat gebruiken." -ForegroundColor Yellow

# 5. Extra mappen voor programma's op D:
$appFolders = @(
    "D:\Apps",
    "D:\Games",
    "D:\Tools"
)

foreach ($folder in $appFolders) {
    if (-not (Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder | Out-Null
        Write-Host "Programmamap aangemaakt: $folder"
    } else {
        Write-Host "Programmamap bestaat al: $folder"
    }
}

Write-Host ""
Write-Host "Klaar! D: is nu standaard voor data (Documenten/Downloads/etc.)." -ForegroundColor Green
Write-Host "Na een herstart zal die andere gebruiker niets van paden moeten snappen." -ForegroundColor Green
