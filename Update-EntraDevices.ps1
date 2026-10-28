[CmdletBinding()]
param (
    [Parameter(Mandatory = $true, Position = 0, HelpMessage = "Percorso del file CSV da importare")]
    [ValidateNotNullOrEmpty()]
    [string]$CsvPath
)

# Bypass Execution Policy per la sessione corrente
Set-ExecutionPolicy Bypass -Scope Process -Force

if (-not (Get-MgContext)) {
    Write-Host "[>] Connessione a Microsoft Graph in corso..." -ForegroundColor Cyan
    Connect-MgGraph -Scopes "Device.ReadWrite.All"
}

if (-not (Test-Path -Path $CsvPath)) {
    Write-Error "Impossibile trovare il file CSV al percorso specificato: $CsvPath"
    exit
}

# Importazione file CSV
$csvData = Import-Csv -Path $CsvPath -Delimiter ","
Write-Host "[>] Trovate $($csvData.Count) righe nel file CSV. Inizio elaborazione..." -ForegroundColor Green

# Elaborazione dispositivi
foreach ($row in $csvData) {
    $searchName = if ($row.searchName) { $row.searchName.Trim() } else { $null }

    if ([string]::IsNullOrWhiteSpace($searchName)) {
        Write-Warning "[--] Riga saltata: il campo 'searchName' è vuoto."
        continue
    }

    Write-Host "  ['$searchName'] Recupero dispositivo..." -ForegroundColor Yellow

    $device = Get-MgDevice -Filter "displayName eq '$searchName'" -ErrorAction SilentlyContinue | Select-Object -First 1

    if (-not $device) {
        Write-Warning "['$searchName'] Dispositivo non trovato su Entra ID. Saltato."
        continue
    }

    # Costruzione della hashtable extensionAttributes (1-5)
    $extAttributes = @{}
    1..5 | ForEach-Object {
        $attrName = "extensionAttribute$_"
        $val = $row.$attrName
        if ([string]::IsNullOrWhiteSpace($val)) {
            $extAttributes[$attrName] = ""
        } else {
            $extAttributes[$attrName] = $val.Trim()
        }
    }

    $params = @{
        extensionAttributes = $extAttributes
    }

    try {
        Update-MgDevice -DeviceId $device.Id -BodyParameter $params
        Write-Host "  ['$searchName'] Dispositivo aggiornato con successo (ID: $($device.Id))." -ForegroundColor Green
    }
    catch {
        Write-Error "['$searchName'] Errore durante l'aggiornamento del dispositivo: $_"
    }
}

Write-Host "[>] Elaborazione completata!" -ForegroundColor Cyan
